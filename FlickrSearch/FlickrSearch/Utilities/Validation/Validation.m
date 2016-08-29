//
//  Validation.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "Validation.h"

@implementation Validation
+(NSDictionary *)textValidation:(UITextField *)textField {
    BOOL isSuccess = YES;
    NSString *alertMessage;
    NSInteger maxLimit = 200;       //fail-safe maximum arbitrary text length
    
    if (textField.text.length == 0) {        //minimum 1 characters required for search
        isSuccess = NO;
        alertMessage = @"Please type something to search";
    } else if (textField.text.length > maxLimit) {
        isSuccess = NO;
        alertMessage = [NSString stringWithFormat:@"Search text can not exceed %ld characters", maxLimit];
    }
    NSDictionary *returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:@(isSuccess), @"value", alertMessage, @"message", nil];
    return returnDict;
}

//remove leading space character from input text
+(NSString *)removeLeadingSpace:(NSString *)text {
    NSRange range = [text rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
    NSString *result = [text stringByReplacingCharactersInRange:range withString:@""];
    return result;
}

//remove trailing space character from input text
+(NSString *)removeTrailingSpace:(NSString *)text {
    NSRange range = [text rangeOfString:@"\\s*$" options:NSRegularExpressionSearch];
    NSString *result = [text stringByReplacingCharactersInRange:range withString:@""];
    return result;
}

//convert special characters to URL friendly chars
+(NSString *)specialToURLTranslation:(NSString *)text {
    NSString *convertedText = text;
    //TODO: enhance url creation further
    //convertedText = [convertedText stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    convertedText = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)text, NULL, (CFStringRef)@"!*'();:@=$&/?%#[]\"", kCFStringEncodingUTF8));
    convertedText = [convertedText stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];      //space = +

    return convertedText;
}

//Calculate the byte size of input UIImageView
+(long long)checkImageByteSize:(UIImageView *)imageView {
    NSData *data = UIImageJPEGRepresentation(imageView.image, 1.0);
    return [data length];
}

//detect if iOS version is 9 for Force Touch call
+(BOOL)isVersion9 {
    NSOperatingSystemVersion iosVersion = (NSOperatingSystemVersion){0, 0, 9};
    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:iosVersion]) {
        return YES;     //iOS 9 or greater
    } else {
        return NO;      //below iOS 9
    }
}

//Save History to NSUserDefaults
+(void)saveHistory:(NSString *)text {
    NSMutableArray *arrayHistory = [NSMutableArray array];

    //check if history exist
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"history"]) {
        //read history then append new text
        arrayHistory = [[[NSUserDefaults standardUserDefaults] valueForKey:@"history"] mutableCopy];
    }
    [arrayHistory addObject:text];

    //Fixme: Correct the order of search history after removal
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayHistory]; //remove any duplicate search
    arrayHistory = [[orderedSet array] copy];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:arrayHistory forKey:@"history"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSMutableArray *)readHistory {
    NSMutableArray *arrayHistory = [NSMutableArray array];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"history"]) {
        //read history then append new text
        arrayHistory = [[[NSUserDefaults standardUserDefaults] valueForKey:@"history"] mutableCopy];
        arrayHistory=[[[arrayHistory reverseObjectEnumerator] allObjects] mutableCopy]; //reverse the array for latest search on top
    }
    return arrayHistory;
}


//remove history, single data at a time
+(void)removeFromHistory:(NSString *)text {
    NSMutableArray *arrayHistory = [NSMutableArray array];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"history"]) {
        arrayHistory = [[[NSUserDefaults standardUserDefaults] valueForKey:@"history"] mutableCopy];
        [arrayHistory removeObject:text];
        
        //save updated history
        [[NSUserDefaults standardUserDefaults] setObject:arrayHistory forKey:@"history"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
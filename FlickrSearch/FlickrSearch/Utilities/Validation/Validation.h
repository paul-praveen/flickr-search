//
//  Validation.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Validation : NSObject
/**
 
 Perform validation on text field
 
 @param     textfield   input is textField object
 
 @return Dictionary  2 Keys, Value and Message. Value = YES if textfield is ok, NO - textfield not ok. Message = defined message
 */
+(NSDictionary *)textValidation:(UITextField *)textField;

/**
 Remove leading space character
 
 @param text    text to be processed
 
 @return NSString
 */
+ (NSString *)removeLeadingSpace:(NSString * )text;

/**
 Remove trailing space character
 
 @param text    text to be processed
 
 @return NSString
 */
+ (NSString *)removeTrailingSpace:(NSString *)text;

/**
    Convert special characters to URL friendly ASCII
 @param text    text to be processed
 
 @return NSString   converted text
 */
+(NSString *)specialToURLTranslation:(NSString *)text;

/**
 Check the byte size of image
 
 @param imageView   input UIImageView
 
 @return long long  byte size
 */
+(long long)checkImageByteSize:(UIImageView *)imageView;

/**
 Check if version is 9 or below 
 
 @return BOOL   Yes = iOS 9 or greater, No = below iOS 9
 */
+(BOOL)isVersion9;


/**
    Save search history in NSUserDefaults
 
 @param text    text to add in history
 
 */
+(void)saveHistory:(NSString *)text;

/**
    Read search history from NSUserDefaults
 
 @return    NSArray     List of array
 */
 
+(NSMutableArray *)readHistory;

/**
 Remove single entry from history
 
 @param text    Entry to be remove
 */
+(void)removeFromHistory:(NSString *)text;
@end
//
//  DisplayAlert.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "DisplayAlert.h"

@implementation DisplayAlert

+ (void) displayAlertView : (NSString *) title andMessage:(NSString *) message {
    UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[alertMsg show];
    [alertMsg performSelector:@selector(show) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    alertMsg.delegate = nil;
    alertMsg = nil;
}
@end
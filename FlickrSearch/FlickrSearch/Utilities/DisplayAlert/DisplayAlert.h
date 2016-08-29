//
//  DisplayAlert.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DisplayAlert : NSObject
/**
 This method is used to display alert message in the application
 
 @param  title    passed as NSString
 
 @param  message   passed as NSString
 
 */
+ (void)displayAlertView:(NSString *)title andMessage:(NSString *)message;
@end
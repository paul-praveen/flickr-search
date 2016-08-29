//
//  ShareActionSheet.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareActionSheet : UIViewController
/**
    Share the image through default actionsheet
 
 @param title   Title of the shared image
 
 @param image   Image to be shared
 */
+(void)shareWithActionSheet:(NSString *)title andImage:(UIImageView *)image fromSender:(UIViewController *)sender;
@end
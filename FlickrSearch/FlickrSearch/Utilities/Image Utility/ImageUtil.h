//
//  ImageUtil.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageUtil : NSObject

/**
    Save the input image in photo library 
 
 @param image   Input UIImage
 
 @param title   Title name of the image
 
 */

+(void)saveImageToAlbum:(UIImage *)image andTitle:(NSString *)title;
@end
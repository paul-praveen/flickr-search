//
//  UIColor+CustomColor.h
//  FlickrSearch
//
//  Created by Praveen on 27/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CustomColor)

/**
 This method returns custum light black transparancy color
 
 [UIColor colorWithRed:225/255.0 green:85/255.0 blue:85/255.0 alpha:1];
 
 @return  UIColor
 */

+ (UIColor *) customColorTransculant;

/**
 This method returns custum light black transparancy color
 
 [UIColor colorWithRed:225/255.0 green:85/255.0 blue:85/255.0 alpha:1];
 
 @param alpha value in float 0.0, 2.0, 0, 1 etc
 
 @return  UIColor
 */
+ (UIColor *) customColorTransculantWithAlpha:(float) value;
@end
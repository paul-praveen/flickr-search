//
//  UIColor+CustomColor.m
//  FlickrSearch
//
//  Created by Praveen on 27/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (CustomColor)

+ (UIColor *) customColorTransculant {
    return  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];        //black shade transculance
}

+ (UIColor *) customColorTransculantWithAlpha:(float) value {
    return  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:value];      //black shade transculance with alpha adjustment
}
@end
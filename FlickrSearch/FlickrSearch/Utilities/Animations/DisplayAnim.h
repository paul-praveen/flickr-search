//
//  DisplayAnim.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DisplayAnim : NSObject

/**
 Perform appear Animation on the requestedView
 
 @param  requestedView    passed as UIView
 
 */
+(void)animateViewForAppearAnimation:(UIView *)requestedView;

/**
 Perform move out and disappear of view Animation on the requestedView
 
 @param  viewHeader    passed as UIView
 
 @param  viewFooter    passed as UIView

 */
+ (void) animateViewForMoveOut:(UIView *)viewHeader andFooterView:(UIView *)viewFooter;


/**
 Perform move in and appear of view Animation on the requestedView
 
 @param  viewHeader    passed as UIView
 
 @param  viewFooter    passed as UIView

 */
+ (void) animateViewForMoveIn:(UIView *)viewHeader andFooterView:(UIView *)viewFooter;

/**
 
 This method is used for bringing ViewController from PushViewController animation (Set animation NO)
 
 usage:  usage :  [viewController.view.layer addAnimation:[DisplayAnim viewControllerTransition] forKey:nil];
 
 @return CATransition
 
 */

+ (CATransition *) viewControllerTransition;


/**
 Removes refresh control from the Collection view
 
 @param requestedView   usually from target view. or UIViewController.view
 */
+ (void) removeRefreshControl:(UIView *) requestedView;
@end
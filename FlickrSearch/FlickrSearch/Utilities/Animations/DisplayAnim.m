//
//  DisplayAnim.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "DisplayAnim.h"

@implementation DisplayAnim

//Appear animation, alpha 0 to 1 and hidden from Yes to No
+ (void) animateViewForAppearAnimation:(UIView *)requestedView {
    __block UIView *tmpView = requestedView;
    tmpView.hidden = NO;
    tmpView.alpha = 0.0;
    [UIView animateWithDuration:0.1
                     animations:^{
                         tmpView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         
                     }];
}


//Disappear animation for custom Footer & Header view
+ (void) animateViewForMoveOut:(UIView *)viewHeader andFooterView:(UIView *)viewFooter {
    __block UIView *tempHeaderView = viewHeader;
    __block UIView *tmpFooterView = viewFooter;
    
    __block CGRect headerFrame = viewHeader.frame;
    __block CGRect footerFrame = viewFooter.frame;
    
    tempHeaderView.hidden = NO;
    tempHeaderView.alpha = 1.0;
    
    tmpFooterView.hidden = NO;
    tmpFooterView.alpha = 1.0;

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.3
                     animations:^{
                         tempHeaderView.alpha = 0.0;
                         tmpFooterView.alpha = 0.0;
                         
                         headerFrame.origin.y = headerFrame.origin.y - 100;
                         tempHeaderView.frame = headerFrame;
                         
                         footerFrame.origin.y = footerFrame.origin.y + 100;
                         tmpFooterView.frame = footerFrame;
                         
                       

                     } completion:^(BOOL finished) {
                         
                     }];
}


//Appear and move-in animation for custom Footer & Header view
+ (void) animateViewForMoveIn:(UIView *)viewHeader andFooterView:(UIView *)viewFooter {
    __block UIView *tempHeaderView = viewHeader;
    __block UIView *tmpFooterView = viewFooter;
    
    __block CGRect headerFrame = viewHeader.frame;
    __block CGRect footerFrame = viewFooter.frame;
    
    tempHeaderView.hidden = NO;
    tempHeaderView.alpha = 0.0;
    
    tmpFooterView.hidden = NO;
    tmpFooterView.alpha = 0.0;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         tempHeaderView.alpha = 1.0;
                         tmpFooterView.alpha = 1.0;
                         headerFrame.origin.y = headerFrame.origin.y + 100;
                         tempHeaderView.frame = headerFrame;
                         
                         footerFrame.origin.y = footerFrame.origin.y - 100;
                         tmpFooterView.frame = footerFrame;
                     } completion:^(BOOL finished) {
                         
                     }];
}



//Animation for bringing ViewController from PushViewController (Set animation NO)
//usage :  [viewController.view.layer addAnimation:[displayAlertView viewControllerTransition] forKey:nil];
+ (CATransition *) viewControllerTransition {
    CATransition *transitionVCAppearance = [CATransition animation];
    transitionVCAppearance.duration = 0.3;
    transitionVCAppearance.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transitionVCAppearance.type = kCATransitionFade;
    transitionVCAppearance.subtype =kCATransitionFromTop;
    transitionVCAppearance.delegate = self;
    
    return transitionVCAppearance;
}


//Remove Refresh control indicator from table view on view-controller
+ (void) removeRefreshControl:(UIView *) requestedView {
    UIRefreshControl *refreshControl = (UIRefreshControl *)[requestedView viewWithTag:7070];            //global Tag for refreshControl
    if (refreshControl) {
        [refreshControl endRefreshing];
        refreshControl = nil;
    }
}
@end
//
//  DetailsViewController.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "DetailsCollectionViewCell.h"
#import "DetailsHeaderContainerViewController.h"
#import "DetailsHeaderContainerViewController.h"

@interface DetailsViewController : UICollectionViewController <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate> {
//    IBOutlet UIView *viewHeaderView;
//    IBOutlet UIView *viewFooterView;
    
    
    SDWebImageManager *sdManager;
    NSInteger cellCount;
    NSInteger currentPage;
    
    BOOL isAutoScrollCompleted;         //auto scroll to tapped image
    BOOL isFullScreen;                  //Full screen hides Header & Footer views
    BOOL shouldHideStatusBar;
    BOOL isShowingInfo;                 //if showing info

    UIImageView *shareImage;
    UIViewController *detailsHeaderVC;
    UIViewController *detailsFooterVC;
    
}

/**
    Shared with childview controller, to save currently displayed image
 */
-(void)sharedSaveCurrentImage;

/**
    Share currently displayed image with ActionSheet
 */
-(void)sharedShareCurrentImage;

/**
    Display image info
 */
-(BOOL)sharedDisplayInfo;

/**
 On tapping top right cancel icon, dismiss current viewcontroller
 */
-(void)sharedDismissViewController;
@end
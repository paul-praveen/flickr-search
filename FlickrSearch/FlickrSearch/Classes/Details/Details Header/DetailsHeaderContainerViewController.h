//
//  DetailsHeaderContainerViewController.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"

@interface DetailsHeaderContainerViewController : UIViewController {
    IBOutlet UIScrollView *customHeaderScrollView;
    IBOutlet UIView *viewHeaderBackground;
}
@property (nonatomic,retain)UILabel *lblTitle;

/**
 
 After setting label adjust content inset
 */
-(void)adjustHeaderTitleSize;
@end
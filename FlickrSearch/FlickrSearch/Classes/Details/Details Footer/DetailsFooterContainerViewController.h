//
//  DetailsFooterContainerViewController.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"

@interface DetailsFooterContainerViewController : UIViewController {
    DetailsViewController *detailsParent;           //parent viewcontroller = Detail View controller
    IBOutlet UIView *viewTopBackground;
}
@property (nonatomic,retain)IBOutlet UIButton *btnSaveImage;
@end
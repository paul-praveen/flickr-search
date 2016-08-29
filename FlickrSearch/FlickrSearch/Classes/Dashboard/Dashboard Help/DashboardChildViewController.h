//
//  DashboardChildViewController.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardCollectionViewController.h"

@interface DashboardChildViewController : UIViewController {
    IBOutlet UILabel *lblTextOR;        //text OR
    IBOutlet UITextView *tvHelpInfo;

}
@property(nonatomic,retain) IBOutlet UIButton *btnPopularPhotos;

@end
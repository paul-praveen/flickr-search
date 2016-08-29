//
//  DetailsFooterContainerViewController.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "DetailsFooterContainerViewController.h"
#import "DetailsViewController.h"
#import "UIColor+CustomColor.h"

@interface DetailsFooterContainerViewController ()

@end

@implementation DetailsFooterContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initFrames];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)initFrames {
   // self.view.backgroundColor = [UIColor customColorTransculantWithAlpha:1.0];
}

//save the displayed image
-(IBAction)btnSaveImage:(id)sender {
    //NSLog(@"save image tapped");
    //call back to parent's method to save image
    if (! detailsParent) {
        detailsParent = (DetailsViewController*)[self parentViewController];
    }
    [detailsParent sharedSaveCurrentImage];
}

//share the displayed image
-(IBAction)btnShareImage:(id)sender {
    //NSLog(@"share image tapped");
    //call back to parent's method to share image
    if (! detailsParent) {
        detailsParent = (DetailsViewController*)[self parentViewController];
    }
    [detailsParent sharedShareCurrentImage];
}

//share the displayed image
-(IBAction)btnDisplayInfo:(id)sender {
    //NSLog(@"share image tapped");
    //call back to parent's method to share image
    if (! detailsParent) {
        detailsParent = (DetailsViewController*)[self parentViewController];
    }
    BOOL isDisplayingInfo = [detailsParent sharedDisplayInfo];
    if (isDisplayingInfo) {
        viewTopBackground.backgroundColor = [UIColor customColorTransculantWithAlpha:1.0];
    } else {
        viewTopBackground.backgroundColor = [UIColor clearColor];
    }
}
@end
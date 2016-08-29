//
//  DetailsHeaderContainerViewController.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "DetailsHeaderContainerViewController.h"
#import "UIColor+CustomColor.h"

@interface DetailsHeaderContainerViewController ()

@end

@implementation DetailsHeaderContainerViewController
@synthesize lblTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initFrames];
    [self initTitleScroll];
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

#pragma mark - INITS
-(void)initFrames {
    self.view.backgroundColor = [UIColor customColorTransculantWithAlpha:1.0];
}

//Make Title scrollable for longer text
-(void)initTitleScroll {
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewHeaderBackground.frame.size.width, 20)];
    lblTitle.font =[UIFont fontWithName:@"Helvetica" size:14];
    lblTitle.textColor = [UIColor lightGrayColor];
    lblTitle.numberOfLines = 1;
    [lblTitle sizeToFit];

    [customHeaderScrollView addSubview:lblTitle];
    [viewHeaderBackground addSubview:customHeaderScrollView];
}

//after setting label adjust content inset
-(void)adjustHeaderTitleSize {
    [lblTitle sizeToFit];
    
    customHeaderScrollView.contentSize = CGSizeMake( lblTitle.frame.size.width  , 20);
    customHeaderScrollView.showsVerticalScrollIndicator = NO;
    customHeaderScrollView.showsHorizontalScrollIndicator = NO;
}

#pragma mark - ACTIONS
-(IBAction)btnClose:(id)sender {
    //NSLog(@"dismiss VC tapped");
    //call back to parent's method to share image
    DetailsViewController *detailsParent;           //parent viewcontroller = Detail View controller
    detailsParent = (DetailsViewController*)[self parentViewController];
    [detailsParent sharedDismissViewController];
}
@end
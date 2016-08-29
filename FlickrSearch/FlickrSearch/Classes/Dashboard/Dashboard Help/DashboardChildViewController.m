//
//  DashboardChildViewController.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "DashboardChildViewController.h"

@interface DashboardChildViewController ()

@end

@implementation DashboardChildViewController
@synthesize btnPopularPhotos;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initFrames];
    [self initDisplayHelp];

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

#pragma mark - METHODS
-(void)initFrames {
    lblTextOR.clipsToBounds = YES;
    lblTextOR.alpha = 0.5;
    lblTextOR.layer.cornerRadius = lblTextOR.frame.size.width/2;
    lblTextOR.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lblTextOR.layer.borderWidth = 1.0;
    //lblTextOR.backgroundColor = [UIColor lightGrayColor];
    
    btnPopularPhotos.layer.cornerRadius = 5;
    btnPopularPhotos.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnPopularPhotos.layer.borderWidth = 0.3;
}


//display help on dashboard
-(void)initDisplayHelp {
    if (! [[NSUserDefaults standardUserDefaults] objectForKey:@"dashboard_help"]) {     //if key not found = fresh installation
        NSString *counter = @"1";
        [[NSUserDefaults standardUserDefaults] setObject:counter forKey:@"dashboard_help"];     //set 1
        [[NSUserDefaults standardUserDefaults] synchronize];
        tvHelpInfo.hidden = NO;
    } else {        //key exist, only show help twice
        NSString *counter = [[NSUserDefaults standardUserDefaults] valueForKey:@"dashboard_help"];
        if ([counter isEqualToString:@"2"]) {
            tvHelpInfo.hidden = YES;
        } else {        //counter is 1
            counter = @"2";
            [[NSUserDefaults standardUserDefaults] setObject:counter forKey:@"dashboard_help"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            tvHelpInfo.hidden = NO;
        }
    }
}

#pragma mark - ACTIONS
-(IBAction)btnShowPopularPhotos:(id)sender {
    //NSLog(@"popular button tapped");
    //call back to parent's method
    DashboardCollectionViewController *dashboardParent;
    dashboardParent = (DashboardCollectionViewController*)[self parentViewController];
    btnPopularPhotos.userInteractionEnabled = NO;
    [dashboardParent sharedLoadPopularPhotos];
}
@end
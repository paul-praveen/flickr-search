//
//  PreviewViewController.m
//  FlickrSearch
//
//  Created by Praveen on 27/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "PreviewViewController.h"
#import "globalData.h"
#import "SDWebImageManager.h"
#import "UIColor+CustomColor.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController
@synthesize ivPhoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initFrames];
    [self displayPhotoPreview];
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
-(void)initData {
    sdManager = [SDWebImageManager sharedManager];

}

-(void)initFrames {
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark - METHODS
-(void)displayPhotoPreview {
    //NSLog(@"Displaying Preview");
    NSIndexPath *indexPath = [[globalData sharedInstance].globalDictionarySharedData objectForKey:@"dashboard_cell_indexpath"];
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[globalData sharedInstance].globalArrayImageURL objectAtIndex:indexPath.row]]] ;
    
    if (imageUrl) {     //if URL is valid and exist
        [sdManager downloadImageWithURL:imageUrl
                                options:0
                               progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                   //NOP
                               }
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                  if (! error) {
                                      if (image) {
                                          ivPhoto.alpha = 0.0;
                                          [UIView animateWithDuration:0.3           //animate for visual effect
                                                           animations:^{
                                                               ivPhoto.alpha = 1.0;
                                                               ivPhoto.image = image;
                                                           } completion:^(BOOL finished) {
                                                               
                                                           }];
                                      } else {
                                          ivPhoto.backgroundColor = [UIColor lightGrayColor];
                                      }
                                  } else {
                                      //NSLog(@"Error: %@", error.description);
                                  }
                              }];
    }
    
}
@end
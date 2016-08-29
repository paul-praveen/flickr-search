//
//  DetailsViewController.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "DetailsViewController.h"
#import "globalData.h"
#import "DisplayAnim.h"
#import "DisplayAlert.h"
#import "ImageUtil.h"
#import "ShareActionSheet.h"
#import "Validation.h"
#import "UIColor+CustomColor.h"

@interface DetailsViewController () {
    DetailsHeaderContainerViewController *headerVC;
}

@end

@implementation DetailsViewController

static NSString *identifierCell = @"customCell";

- (BOOL)prefersStatusBarHidden {
    return shouldHideStatusBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    
    [self initData];
    [self initFrames];
    [self initCustomGestureRecognizer];
    [self initCollectionViewLayouts];
    [self initCustomView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//use it to scroll to selected image, then continue scroll index from there
- (void)viewDidLayoutSubviews {
    if (! isAutoScrollCompleted) {
        isAutoScrollCompleted = YES;
        NSIndexPath *indexPath = [[globalData sharedInstance].globalDictionarySharedData objectForKey:@"dashboard_cell_indexpath"];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        currentPage = indexPath.row;
        //NSLog(@"currentpage:%ld - URL:%@",currentPage, [globalData sharedInstance].globalArrayImageURL [indexPath.row]);
        [self showImageTitle:indexPath];
    }
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
       // [self.navigationItem setHidesBackButton:YES animated:NO];
    isAutoScrollCompleted = NO;
    isFullScreen = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    sdManager = [SDWebImageManager sharedManager];
    
    cellCount = [globalData sharedInstance].globalArrayImageURL.count;
}

-(void)initFrames {
    self.collectionView.backgroundColor = [UIColor customColorTransculantWithAlpha:1.0];

}
//Collection View Flow layout
-(void)initCollectionViewLayouts {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

//Add custom header and footer details views
-(void)initCustomView {
    //add Header viewcontroller
    detailsHeaderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsHeaderVC"];
    [self addChildViewController:detailsHeaderVC];
    [detailsHeaderVC didMoveToParentViewController:self];
    detailsHeaderVC.view.frame = CGRectMake(0, 20, self.view.frame.size.width, 50);
    [self.view addSubview:detailsHeaderVC.view];
    headerVC = [self.childViewControllers firstObject];
 
    //add footer viewcontroller
    detailsFooterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsFooterVC"];
    [self addChildViewController:detailsFooterVC];
    [detailsFooterVC didMoveToParentViewController:self];
    detailsFooterVC.view.frame = CGRectMake(0, self.view.frame.size.height -50, self.view.frame.size.width, self.view.frame.size.height - 40);
    [self.view addSubview:detailsFooterVC.view];
}

#pragma mark - METHODS
-(void) initCustomGestureRecognizer {
    //swipe up gesture to dismiss
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUp.delegate = self;
    [self.collectionView addGestureRecognizer:swipeUp];
    
    //single tap to go full screen without header/footer
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    singleTapGesture.numberOfTapsRequired = 1;
    [self.collectionView addGestureRecognizer:singleTapGesture];
    
    //double tap to zoom out (enable when scrollview zooming is enabled
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureHandlerMethod:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    //[self.collectionView addGestureRecognizer:doubleTapGesture];
    
    //[singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}

//handle swipe to dismiss gesture
- (void)swipeRecognizer:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionUp){
        [self dismissViewWithAnimation];
    }
}

-(void)gestureHandlerMethod:(UIGestureRecognizer*)sender {
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        //NSLog(@"tapped gesture");
        if (isFullScreen) {
            [DisplayAnim animateViewForMoveIn:detailsHeaderVC.view andFooterView:detailsFooterVC.view];
        } else {
            [DisplayAnim animateViewForMoveOut:detailsHeaderVC.view andFooterView:detailsFooterVC.view];
        }
        [self updateStatusBarVisibility];
        isFullScreen = !isFullScreen;
    }
}

-(void)doubleTapGestureHandlerMethod:(UIGestureRecognizer*)sender {
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        //NSLog(@"double tapped gesture");
    
        CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
        
        //NSLog(@"Values: %f %f %f", self.collectionView.contentOffset.x, self.collectionView.frame.size.width, ceil(currentPage));
        
        UIScrollView *tempScrollview = (UIScrollView *)[self.collectionView viewWithTag:indexPath.row];
        [tempScrollview setZoomScale:1.0 animated:YES];
    }
}

//Set the title of displaed image
-(void)showImageTitle:(NSIndexPath *)indexPath {
    //NSLog(@"showing: %@", [globalData sharedInstance].globalDictionaryPhotoDetails [currentPage]);
    headerVC.lblTitle.text =  [[globalData sharedInstance].globalDictionaryPhotoDetails [indexPath.row] valueForKey:@"title"];  //set title
    [headerVC adjustHeaderTitleSize];       //adjust title to be scrollable
}

//Hide/Show statusbar on fullscreen
-(void)updateStatusBarVisibility {
    shouldHideStatusBar = (shouldHideStatusBar)? NO: YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

//Perform key layer animation and dismiss current model view controller
-(void)dismissViewWithAnimation {
   __block CGRect frame = self.view.frame;
    [UIView animateWithDuration:0.3
                     animations:^{
                         frame.origin.y = frame.origin.y - 200;
                         self.view.frame = frame;
                         self.view.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self.view.layer addAnimation:[DisplayAnim viewControllerTransition] forKey:nil];
                         [self dismissViewControllerAnimated:NO completion:nil];
                         
                     }];

}
#pragma mark - SHARED METHODS
//shared method for Child-Parent header/footer controllers
-(void)sharedSaveCurrentImage {
    //NSLog(@"parent save image");
    if ([Validation checkImageByteSize:shareImage] > 0) {            //check if shareImage has some data
        NSString *title = [NSString stringWithFormat:@"FL%@", [NSDate date]];
        [ImageUtil saveImageToAlbum:shareImage.image andTitle:title];
    } else {        //file size is zero, inform user
        [DisplayAlert displayAlertView:@"Alert !!" andMessage:@"File size is zero."];
    }


}

//shared method for Child-Parent header/footer controllers
-(void)sharedShareCurrentImage {
    //NSLog(@"parent share image");
    if ([Validation checkImageByteSize:shareImage] > 0) {            //check if shareImage has some data
        [ShareActionSheet shareWithActionSheet:@"Flickr" andImage:shareImage fromSender:self];
    } else  {
        [DisplayAlert displayAlertView:@"Alert !!" andMessage:@"File size is zero."];
    }
}

//Display photo details in full screen child view controller
//Animate to bring view slide up or down to hide
-(BOOL)sharedDisplayInfo {
    __block CGRect frame = detailsFooterVC.view.frame;

    if (isShowingInfo) {        //if showing then hide info
        isShowingInfo = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             frame.origin.y = self.view.frame.size.height - 100;;
                             detailsFooterVC.view.frame = CGRectMake(0, self.view.frame.size.height -50, self.view.frame.size.width, self.view.frame.size.height - 40);
                         } completion:^(BOOL finished) {
                         }];
    } else {        //if not showing then show info
        isShowingInfo = YES;
        [UIView animateWithDuration:0.3
                         animations:^{
                             //frame.size.height = 240;
                             frame.origin.y = 100;
                             detailsFooterVC.view.frame = frame;
                             
                         } completion:^(BOOL finished) {
                         }];
            }
    return isShowingInfo;
}

//Dismiss view controller
-(void)sharedDismissViewController {
      [self dismissViewWithAnimation];
}

#pragma mark - ScrollView Delegate
//Enable it after testing
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return shareImage;      
//}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor customColorTransculantWithAlpha:1.0];
    //dequeue loads two imgares, remove other one
    for (UIView *innerViews in cell.contentView.subviews) {
        [innerViews removeFromSuperview];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    scrollView.minimumZoomScale=1.0;
    scrollView.maximumZoomScale=5.0;
    scrollView.tag = indexPath.row;
    scrollView.backgroundColor = [UIColor customColorTransculantWithAlpha:1.0];
    scrollView.delegate=self;
    
    UIImageView *ivPhoto = [[UIImageView alloc] init];
    ivPhoto.frame = scrollView.frame;
    ivPhoto.contentMode = UIViewContentModeScaleAspectFit;
    ivPhoto.tag = indexPath.row;
    [scrollView addSubview:ivPhoto];
    ivPhoto.backgroundColor = [UIColor customColorTransculantWithAlpha:1.0];
    //ivPhoto.image = nil;
    [cell.contentView addSubview:scrollView];
 
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
                                          shareImage = ivPhoto;
                                          
                                          [UIView animateWithDuration:0.3           //animate for visual effect
                                                           animations:^{
                                                               ivPhoto.alpha = 1.0;
                                                               ivPhoto.image = image;
                                                               scrollView.frame = ivPhoto.frame;
                                                                scrollView.contentSize = ivPhoto.frame.size;
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
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //find the visible image indexPath
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    
    currentPage = (indexPath.row);
    [self showImageTitle:indexPath];
    //NSLog(@"Values: %f %f %f", self.collectionView.contentOffset.x, self.collectionView.frame.size.width, ceil(currentPage));
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}
@end
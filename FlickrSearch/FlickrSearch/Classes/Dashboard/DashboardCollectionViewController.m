//
//  DashboardCollectionViewController.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "DashboardCollectionViewController.h"
#import "Validation.h"
#import "DisplayAlert.h"
#import "DisplayAnim.h"
#import "ErrorCodeDefinition.h"
#import "DataManager.h"
#import "DetailsViewController.h"
#import "DashboardCollectionViewCell.h"
#import "PreviewViewController.h"
#import "UIColor+CustomColor.h"

@interface DashboardCollectionViewController ()

@end

@implementation DashboardCollectionViewController
@synthesize previewingContext;

static NSString * const reuseIdentifier = @"customCell";
static NSInteger itemPerPage = 20;     //define how many results per call
static NSString * const imageQuality = @"m";            //s=low, m=medium, l=HD
static NSInteger distanceFromBottom = 800;              //arbitrary value to set with what distance automatically do search API call


NSString *const flickrAPIKey = @"56788e14389f9bab7930c239718e5a9e";
NSString *const flickrSecretKey = @"bf861c804d05e217";

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initData];
    [self initArrays];
    [self initRefreshControl];
    [self initCollectionViewFlowLayout];
    [self initCustomView];
    [self initTableView];
    
    [self isForceTouchAvailable];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self startKeyboardObservers];
    self.navigationController.hidesBarsOnSwipe = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.hidesBarsOnSwipe = NO;
    [self hideKeyboard];
    [self stopKeyboardObservers];
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
//initialize instance variable or default setting of objects
//Use it to initialize Header & Footer views
-(void)registerCellClass {
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
    
//    [tblView registerClass:[UITableViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [tblView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}

-(void)initData {
    isFreshSearch = YES;
    isSearchingPupularPhotos = NO;
    
    cellCount = 0;
    cellHeight = 30;
    
    paginationPageNumber = 1;
    paginationPageNumberPopularImage = 1;
    sdManager = [SDWebImageManager sharedManager];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

-(void)initArrays {
    //read user defaults and get history data
    arrayTableData = [NSMutableArray array];
}

-(void)initCollectionViewFlowLayout {
    //Flow layout
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumInteritemSpacing = 5.0f;
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.bounces = YES;
}

-(void)initRefreshControl {
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tag = 7070;
    [self.collectionView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshCollectionView:) forControlEvents:UIControlEventValueChanged];
}


//Add custom header and footer details views
-(void)initCustomView {
    //add static helper viewcontroller
    dashboardStaticHelperVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboardHelper"];
    [self addChildViewController:dashboardStaticHelperVC];
    [dashboardStaticHelperVC didMoveToParentViewController:self];
    dashboardStaticHelperVC.view.frame = self.collectionView.frame;
    
    self.collectionView.backgroundView =[[UIView alloc]initWithFrame:self.collectionView.bounds];
    [self.collectionView.backgroundView addSubview:dashboardStaticHelperVC.view];

    self.navigationController.navigationBar.barTintColor =[UIColor customColorTransculantWithAlpha:1.0];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [tfSearch setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)startKeyboardObservers  {
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)stopKeyboardObservers {
      [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initTableView {
    tblView = [[UITableView alloc] init];
    tblView.frame = CGRectMake(50, 60, self.view.frame.size.width - 110, 120);
    tblView.backgroundColor = [UIColor lightGrayColor];
    tblView.delegate = self;
    tblView.dataSource = self;
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.navigationController.view.window addSubview:tblView];
    arrayTableData = [[Validation readHistory] copy];
    tblView.hidden = YES;
}

- (void)keyboardDidShow: (NSNotification *) notif{
    tblView.hidden = NO;
    arrayTableData = [[Validation readHistory] copy];
    [tblView reloadData];
}

- (void)keyboardWillHide: (NSNotification *) notif{
    tblView.hidden = YES;
}

#pragma mark - METHODS
//Hide keyboard
-(void)hideKeyboard {
    [tfSearch resignFirstResponder];
}

//On pull down to refresh display popular photos
-(void)refreshCollectionView:(UIRefreshControl *)refreshControl {
    isFreshSearch = YES;
    [self requestMostInterestingPhotosWithPageNumber:paginationPageNumberPopularImage];
}

/**
 This method will set the tableview content inset to proper postiion and remove collectionview's pull-down-to-refresh activity indicator
 */
-(void)dismissRefreshControl {
    [refreshControl endRefreshing];
}

/**
 based on dragging collectionview, hide/show navigation bar
 
 @param hide    Bool: Yes=Hide, No=Unhide
 */
-(void)showHideNavBar:(BOOL)hide {
    [self.navigationController setNavigationBarHidden:hide animated:YES];
    if (hide) {     //hide the table
        __block CGRect frame = tblView.frame;
        [UIView animateWithDuration:0.3
                         animations:^{
                             frame.origin.y = frame.origin.y - 100;
                             tblView.frame = frame;
                         } completion:^(BOOL finished) {
                             
                         }];

    } else {        //unhide the table
        [UIView animateWithDuration:0.3
                         animations:^{
                             tblView.frame = CGRectMake(50, 60, self.view.frame.size.width - 110, 120);//default position
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

//perform text validation
-(BOOL)validationOnText {
    NSDictionary *validationResponse = [Validation textValidation:tfSearch];
    if ([[validationResponse valueForKey:@"value"]  isEqual: @(NO)]) {    //if validation failed, just return
        [DisplayAlert displayAlertView:@"" andMessage:[validationResponse valueForKey:@"message"]];     //display validation alert message
        return NO;
    } else {        //All good, proceed
        [Validation saveHistory:tfSearch.text];
        [self hideKeyboard];
        isFreshSearch = YES;
        [self requestSearchFlickrWithPageNumber:1];       //fresh search always begins with page one
        return YES;
    }
}

/** 
 Load a viewcontroller by its storyboard id
 
 @param storyboardID Storyboard id of the view controller
 */
-(void)loadNextViewController:(NSString *)storyboardID {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardID];
    [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];

    [self presentViewController:viewController animated:NO completion:nil];
}

/**
    Add new data at the end of the collectionview Cell
 
 @param arrayPhotoURL    Data to be added to existing datasource
 */
-(void)addNewCellWithArray:(NSArray *)arrayPhotoURL {
    [self.collectionView performBatchUpdates:^{
        NSInteger resultsSize = [[globalData sharedInstance].globalArrayImageURL count];
        [[globalData sharedInstance].globalArrayImageURL addObjectsFromArray:arrayPhotoURL];
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        
        for (NSInteger i = resultsSize; i < resultsSize + arrayPhotoURL.count; i++) {
            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
        cellCount = [globalData sharedInstance].globalArrayImageURL.count;           //set the cell count
    } completion:nil];
    
}

//For a fresh search scroll collection view to top start position
-(void)scrollCollectionViewToTop {
    CGFloat compensateHeight = -(self.navigationController.navigationBar.bounds.size.height+[UIApplication sharedApplication].statusBarFrame.size.height);
    [self.collectionView setContentOffset:CGPointMake(0, compensateHeight) animated:YES];
}

#pragma mark - SHARED METHOD
//from child view controller, load request
-(void)sharedLoadPopularPhotos {
    [self requestMostInterestingPhotosWithPageNumber:1];    //start from 1 each time from fresh view
}

#pragma mark - ACTIONS
-(IBAction)btnSearch:(id)sender {
    [self validationOnText];
}

#pragma mark - WEB SERVICE
/** 
 create search request URL
 
 @param pageNumber Use it for pagination
 */
-(void)requestSearchFlickrWithPageNumber:(NSInteger)pageNumber  {
    //cancel any running operation
    DataManager *wsRequest = [[DataManager alloc] init];
    [wsRequest canceAllTasks];
    [sdManager cancelAll];
    
    isSearchingPupularPhotos = NO;
    //format search string for multiple tags
    NSString *searchText = [Validation removeLeadingSpace:tfSearch.text];
    searchText = [Validation removeTrailingSpace:tfSearch.text];
   
    //convert special characters to URL friendly syntax
    searchText = [Validation specialToURLTranslation:searchText];
    //NSLog(@"cstring string:%@", searchText);

    NSString *requestURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=%ld&page=%ld&format=json&nojsoncallback=1", flickrAPIKey, searchText,itemPerPage, pageNumber];
    
    //NSLog(@"Requested URL: %@", requestURL);
    
    //create webservice call
    [wsRequest webServiceRequestForURL:requestURL target:self selector:@selector(responseSearchRequest:)];
}

/**
 Callback method for response of search request.
 This method should not take input parameter.
 
 @param responseDict as NSDictionary is the response from DataManagers.
 */
- (void)responseSearchRequest:(NSDictionary *)responseDict {
    @try {
        if ([responseDict objectForKey:@"stat"]) {
            NSString *resultStat = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"stat"]];
            if ([[resultStat lowercaseString] isEqualToString:@"fail"]) {
                //display alert of error description
                [DisplayAlert displayAlertView:@"Failed" andMessage:[responseDict valueForKey:@"message"]];
            } else {        //stat = OK, check if any image found
                if ([[[responseDict objectForKey:@"photos"] objectForKey:@"pages"] integerValue] == 0) {    //if Zero results found
                    [DisplayAlert displayAlertView:@"" andMessage:@"No image found"];
                } else {    //All good, create imageURL & perform UI update
                    self.collectionView.backgroundView.hidden = YES;
                    self.collectionView.backgroundColor = [UIColor customColorTransculantWithAlpha:1.0];

                    if (isSearchingPupularPhotos) { //clear search term from textfield if it is popular photo searcy
                        tfSearch.text = @"";
                    }
                    
                    if (isFreshSearch) {        //clear cached data from screen
                        [[globalData sharedInstance].globalArrayImageURL removeAllObjects];
                        [[globalData sharedInstance].globalDictionaryPhotoDetails removeAllObjects];    //for fresh search remove previous responses
                        cellCount = 0;
                        maxPageNumbersToLoad = 0;
                        //[self.collectionView reloadData];
                    } else {        //if not fresh search then cancel SDWebimage Download
                        [sdManager cancelAll];
                    }

                    maxPageNumbersToLoad =  [[[responseDict objectForKey:@"photos"] objectForKey:@"pages"] integerValue];
                    //maxPageNumbersToLoad = 2;       //FIXME: for testing remove in final build
                    
                    NSArray *arrayPhotos = [[responseDict objectForKey:@"photos"] objectForKey:@"photo"];
                    NSMutableArray *arrayPhotoURL = [NSMutableArray array];
                    NSMutableArray *arrayPhotoDetails = [NSMutableArray array];
                    
                    for (NSDictionary *photo in arrayPhotos) {
                        NSString *photoURLString = [NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@_%@.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"],imageQuality];     //create image URL from response data
                        [arrayPhotoURL addObject:[NSURL URLWithString:photoURLString]];
                        [arrayPhotoDetails addObject:photo];
                    }
                    
                    if (! isFreshSearch) {        //call addNewCell only for existing search
                        [self addNewCellWithArray:arrayPhotoURL];
                        [[globalData sharedInstance].globalDictionaryPhotoDetails addObjectsFromArray:arrayPhotoDetails];
                    } else {    //for fresh search do not call addNewCell method to avoid crash
                        [[globalData sharedInstance].globalArrayImageURL addObjectsFromArray:arrayPhotoURL];
                        [globalData sharedInstance].globalDictionaryPhotoDetails = arrayPhotoDetails;

                        cellCount = [globalData sharedInstance].globalArrayImageURL.count;           //set the cell count
                        [self.collectionView reloadData];
                        [self performSelector:@selector(scrollCollectionViewToTop) withObject:nil afterDelay:0.2];
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        //NSLog(@"%@",exception.description);
        [DisplayAlert displayAlertView:@"" andMessage:exception.description];
    } @finally {
        [self dismissRefreshControl];   //dismiss, if any
    }
}

-(void)requestMostInterestingPhotosWithPageNumber:(NSInteger)pageNumber {
    isSearchingPupularPhotos = YES;
    //format search string for multiple tags
    NSString *searchText = [Validation removeLeadingSpace:tfSearch.text];
    searchText = [Validation removeTrailingSpace:tfSearch.text];
    
    //convert special characters to URL friendly syntax
    searchText = [Validation specialToURLTranslation:searchText];
    //NSLog(@"cstring string:%@", searchText);
    
    NSString *requestURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=%@&per_page=%ld&page=%ld&format=json&nojsoncallback=1", flickrAPIKey,itemPerPage, pageNumber];
    
    //NSLog(@"Requested URL: %@", requestURL);
    
    //create webservice call
    DataManager *wsRequest = [[DataManager alloc] init];
    [wsRequest webServiceRequestForURL:requestURL target:self selector:@selector(responseSearchRequest:)];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierCell = @"customCell";
    
    DashboardCollectionViewCell *cell = (DashboardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    
    
    cell.ivPhoto.image = nil;
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
                                          cell.ivPhoto.alpha = 0.0;
                                          [UIView animateWithDuration:0.3           //animate for visual effect
                                                           animations:^{
                                                                cell.ivPhoto.alpha = 1.0;
                                                               cell.ivPhoto.image = image;
                                                           } completion:nil];
                                      } else {
                                          cell.ivPhoto.backgroundColor = [UIColor lightGrayColor];
                                      }
                                  } else {
                                      //NSLog(@"Error: %@", error.description);
                                  }
                              }];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"selected image:%ld, %@", indexPath.row, [globalData sharedInstance].globalArrayImageURL[indexPath.row]);
    [[globalData sharedInstance].globalDictionarySharedData setObject:indexPath forKey:@"dashboard_cell_indexpath"];
    [self loadNextViewController:@"details"];       //load details viewcontroller
}

//Set width and height of cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(120, 120);
}


#pragma mark - Scrollview Delegate
//use this to show hide top Navigation controller
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != tblView) {
        lastScrollviewOffset = scrollView.contentOffset.y;
    }
}

//When swipping thumb up = Hide Navigation, swiping thumb down = Show navigation
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView != tblView) {
        if (lastScrollviewOffset < scrollView.contentOffset.y) {        //Up
            [self showHideNavBar:(velocity.y > 0)];
            //NSLog(@"Thumb Scrolling UP");
        } else if (lastScrollviewOffset > scrollView.contentOffset.y) { //Down
            [self showHideNavBar:(velocity.y > 0)];
            //NSLog(@"Thumb Scrolling Down");
        }
    }
}

//After dragging find out user is on which page
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView != tblView) {

        CGFloat currentOffset = scrollView.contentOffset.y;
        CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;

        if (maximumOffset - currentOffset <= distanceFromBottom) {
            //[self loadOneMorePage];
            //NSLog(@"Call Search API");
            
            //check if max result reached by pagecount
            if(paginationPageNumber <= maxPageNumbersToLoad) {
                paginationPageNumber++;
                isFreshSearch = NO;
                if (isSearchingPupularPhotos) {     //request popular phoro request
                    paginationPageNumberPopularImage++;
                    [self requestMostInterestingPhotosWithPageNumber:paginationPageNumberPopularImage];
                } else {        //request user search request
                    [self requestSearchFlickrWithPageNumber:paginationPageNumber];
                }
            } else {        //reached end of result. No more to show
                //TODO: Add a footer view to table about reached end of results
                //NOP
            }
        }
        
        if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //user has scrolled to the bottom
            //NSLog(@"at bottom");
        }
    }
}

#pragma mark - Textfield Delegate
/**
 UITextField delegate method.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self validationOnText];
    return YES;
}

#pragma mark - Force Touch Delegates
//Check if force touch is available on device
-(void)isForceTouchAvailable {
    if ([Validation isVersion9]) {
        [self.traitCollection respondsToSelector:@selector(forceTouchCapability)];
    } else {        //version below 9
        //Do nothing
    }
}

//perform PEEK here
- (UIViewController *)previewingContext:(id )previewingContext viewControllerForLocation:(CGPoint)location{
    //fail-safe check if not already showing
    if ([self.presentedViewController isKindOfClass:[PreviewViewController class]]) {
        return nil;
    }
    
    CGPoint cellPostion = [self.collectionView convertPoint:location fromView:self.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:cellPostion];

    if (indexPath) {        //fail-safe check
        [[globalData sharedInstance].globalDictionarySharedData setObject:indexPath forKey:@"dashboard_cell_indexpath"];
        
        PreviewViewController *previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"preview"];
    
        return previewController;
    }
    return nil;
}

//perform POP here
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0); {
    //NSLog(@"POP");
    [self loadNextViewController:@"details"];       //load details viewcontroller
}


//check if force touch
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            // retain the context to avoid registering more than once
            if (!self.previewingContext) {
                self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
            }
        } else {        //force touch not exist/disabled
            [self unregisterForPreviewingWithContext:self.previewingContext];
            self.previewingContext = nil;
        }
    }
}

#pragma mark - TABLEVIEW  SEARCH
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CGRect frame = tblView.frame;
    NSInteger rowCount = arrayTableData.count;
    
    if (rowCount < 6) { //if history data is <6 item, then dynamically adjust height.
        frame.size.height = cellHeight * rowCount;
    } else {        //if history data is > 6 items, then statically fix height
        frame.size.height = cellHeight * 6;
    }
    tblView.frame = frame;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableIdentifierCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifierCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableIdentifierCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = arrayTableData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"sel: %@", arrayTableData[indexPath.row]);
    tfSearch.text = arrayTableData[indexPath.row];
    [self btnSearch:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Deleting row.");
    [Validation removeFromHistory:arrayTableData[indexPath.row]];
    arrayTableData = [Validation readHistory];
    [tblView reloadData];
}
@end
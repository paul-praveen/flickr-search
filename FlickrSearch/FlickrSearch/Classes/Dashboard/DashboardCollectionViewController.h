//
//  DashboardCollectionViewController.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "globalData.h"
#import "DashboardChildViewController.h"

@interface DashboardCollectionViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource , UIViewControllerPreviewingDelegate> {
    
    IBOutlet UIView *viewSearchBackground;              //background view of serach textfield
    IBOutlet UITextField *tfSearch;
    
    UIViewController *dashboardStaticHelperVC;

    NSInteger cellCount;
    NSInteger paginationPageNumber;         //use this for load more automatically
    NSInteger paginationPageNumberPopularImage;         //use this for load more automatically

    NSInteger maxPageNumbersToLoad;         //maximum page number can be loaded
    NSInteger cellHeight;
    
    BOOL isFreshSearch;                     //on fresh search, clear cached data
    BOOL isSearchingPupularPhotos;          //Flag user or popular photo search
    
    SDWebImageManager *sdManager;
    
    CGFloat lastScrollviewOffset;
    
    UIRefreshControl *refreshControl;
    
    IBOutlet UITableView *tblView;
    NSMutableArray *arrayTableData;
    
}
@property (nonatomic, strong) id previewingContext;

/**
    From child view controller, load request
 */
-(void)sharedLoadPopularPhotos;
@end
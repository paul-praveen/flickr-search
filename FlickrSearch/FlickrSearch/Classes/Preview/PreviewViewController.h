//
//  PreviewViewController.h
//  FlickrSearch
//
//  Created by Praveen on 27/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

@interface PreviewViewController : UIViewController {
    SDWebImageManager *sdManager;
}
@property(nonatomic, retain)IBOutlet UIImageView *ivPhoto;
@end
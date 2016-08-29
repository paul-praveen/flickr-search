//
//  DetailsCollectionViewCell.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>
@property(nonatomic,retain)IBOutlet UIScrollView *customScrollView;
@property (nonatomic,retain)IBOutlet UIImageView *ivPhoto;
@end
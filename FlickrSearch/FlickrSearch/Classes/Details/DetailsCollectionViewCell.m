//
//  DetailsCollectionViewCell.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "DetailsCollectionViewCell.h"

@implementation DetailsCollectionViewCell
@synthesize customScrollView;
@synthesize ivPhoto;

-(instancetype)init {
    customScrollView.delegate = self;
    customScrollView.minimumZoomScale=1.0;
    customScrollView.maximumZoomScale=6.0;
    //customScrollView.contentSize=CGSizeMake(1280, 960);
    customScrollView.delegate=self;
    
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return ivPhoto;
}
@end
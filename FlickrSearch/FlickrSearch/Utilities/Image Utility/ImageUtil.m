//
//  ImageUtil.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "ImageUtil.h"
#import "DisplayAlert.h"
@import Photos;

@implementation ImageUtil

+(void)saveImageToAlbum:(UIImage *)image andTitle:(NSString *)title {
    // Create new album.
    __block PHObjectPlaceholder *albumPlaceholder;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        albumPlaceholder = changeRequest.placeholderForCreatedAssetCollection;
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumPlaceholder.localIdentifier] options:nil];
            PHAssetCollection *assetCollection = fetchResult.firstObject;
            
            // Add it to the photo library
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                
                PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
            } completionHandler:^(BOOL success, NSError *error) {
                if (!success) {
                    //NSLog(@"Error creating asset: %@", error);
                } else {
                    [DisplayAlert displayAlertView:@"" andMessage:@"Saved in photos"];
                }
            }];
        } else {
            //NSLog(@"Error creating album: %@", error);
        }
    }];
}
@end
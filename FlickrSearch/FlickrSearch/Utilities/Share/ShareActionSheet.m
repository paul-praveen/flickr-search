//
//  ShareActionSheet.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "ShareActionSheet.h"

@implementation ShareActionSheet

+(void)shareWithActionSheet:(NSString *)title andImage:(UIImageView *)image fromSender:(UIViewController *)sender
{
    NSArray *arrayObjects = [[NSArray alloc] initWithObjects:title, image, nil];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:arrayObjects applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityView.excludedActivityTypes = excludeActivities;
    
    [sender presentViewController:activityView animated:YES completion:nil];
}
@end
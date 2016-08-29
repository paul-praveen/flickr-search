//
//  GlobalData.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "globalData.h"

@implementation globalData

@synthesize globalNSURLSession;
@synthesize globalArrayImageURL;
@synthesize globalDictionaryPhotoDetails;
@synthesize globalDictionarySharedData;

+(instancetype)sharedInstance {
    static globalData *sharedInstance = nil;
    static dispatch_once_t onceToken;   //create thread-safe singleton
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[globalData alloc] init];
        [sharedInstance initArrays];
        [sharedInstance initDictionaries];
    });
    return sharedInstance;
}

//Initialize shared global arrays here
-(void)initArrays {
    globalArrayImageURL = [NSMutableArray array];
    globalDictionaryPhotoDetails = [NSMutableArray array];
}

//Initialize shared global dictionaries here
-(void)initDictionaries {
    globalDictionarySharedData = [NSMutableDictionary dictionary];
}
@end
//
//  globalData.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface globalData : NSObject
/**
 Singleton class for shared data and one time instance creation
 
 @return  globalData
 
 */
+ (globalData*)sharedInstance;

/**
 Shared instance of NSURLSession
 */
@property (nonatomic, retain) NSURLSession *globalNSURLSession;     //maintain single instance of NSURLSession

/**
 Shared array holds image URL
 */
@property (nonatomic, retain) NSMutableArray *globalArrayImageURL;

/**
 Shared dictionary holds responses for photo details
 */
@property (nonatomic, retain) NSMutableArray *globalDictionaryPhotoDetails;

/**
 Shared mutable dictionary for passing data
 */
@property (nonatomic, retain) NSMutableDictionary *globalDictionarySharedData;
@end
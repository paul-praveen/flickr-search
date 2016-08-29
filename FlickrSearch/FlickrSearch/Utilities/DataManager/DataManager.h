//
//  DataManager.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "globalData.h"
#import "DisplayAlert.h"
#import "Reachability.h"
#import "ErrorCodeDefinition.h"

@interface DataManager : NSObject <NSURLSessionDelegate>

/**
 Initialize the instance of NSURLSession
 */
- (void)initDownloadSession;

/**
 Web service request
 
 @param dictionary
 
 @param url
 
 @param target the object which requested the service request
 
 @param selector the method to run from target class
 */

- (void) webServiceRequestForURL:(NSString *)urlString target:(id)target selector:(SEL)selector;

/**
 Cancel all tasks
 
 */
- (void)canceAllTasks;

/**
 Cancel a specific task
 
 */
- (void)cancelTaskListForURL:(NSString *)url;

/**
 Check for the network connections in the device
 
 @return BOOL
 */
-(BOOL)hasConnectivity;

/**
 Display alert if no network
 */
- (void)noNetworkError:(id)target;
@end
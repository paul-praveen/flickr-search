//
//  DataManager.m
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import "DataManager.h"
#import "DisplayAnim.h"

@implementation DataManager

#pragma mark - INIT Session
//Initialize NSURLSession singleton
- (void)initDownloadSession {
    //if (! [globalData sharedInstance].globalNSURLSession)     //fail-safe check
    {
        //NSLog(@"initSharedSession");
        NSURLSessionConfiguration *sessionConfiguration;
        sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.sessionSendsLaunchEvents = YES;
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
        sessionConfiguration.timeoutIntervalForResource = 60;
        sessionConfiguration.timeoutIntervalForRequest = 60;
        [globalData sharedInstance].globalNSURLSession = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                                                             delegate:self
                                                                                        delegateQueue:[NSOperationQueue mainQueue]];
    }
}

#pragma mark - WEB SERVICES
// V2=========================================
- (void) webServiceRequestForURL:(NSString *)urlString target:(id)target selector:(SEL)selector {
    if ([self hasConnectivity]) {
        urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [[NSURL alloc] initWithString:urlString];      ///final URL to process
        
        NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[UIDevice currentDevice].name forHTTPHeaderField:@"device"];
        [request setTimeoutInterval:60];
        
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        NSURLSessionDataTask * sessionDataTask;
        sessionDataTask = [[globalData sharedInstance].globalNSURLSession
                           dataTaskWithRequest:request
                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                               // The server answers with an error
                               // handle response
                               NSString *userDefinedErrorCode = [NSString stringWithFormat:@"%u", (errorCode)parseError];
                               NSDictionary *responseJSONDict ;
                               if (error) {   //YES error, alert
                                   //NSLog(@"Err: %@", error.description);
                                   
                                   userDefinedErrorCode = [NSString stringWithFormat:@"%u", (errorCode)parseError];
                                   NSDictionary *dictInnerInfo = [[NSDictionary alloc] initWithObjectsAndKeys:userDefinedErrorCode, @"code", nil];
                                   responseJSONDict = [[NSDictionary alloc] initWithObjectsAndKeys:dictInnerInfo, @"info", nil];
                               }
                               //continue passing the responseJSONDict
                               if (data.length > 0) {
                                   responseJSONDict = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
                               } else {
                                   userDefinedErrorCode = [NSString stringWithFormat:@"%u", (errorCode)parseError];
                                   NSDictionary *dictInnerInfo = [[NSDictionary alloc] initWithObjectsAndKeys:userDefinedErrorCode, @"code", nil];
                                   responseJSONDict = [[NSDictionary alloc] initWithObjectsAndKeys:dictInnerInfo, @"info", nil];
                               }
                               
                               if (error) {      //error occurred during JSON parsing
                                   //Error occurred, add error code in result_code and let target handle it.
                                   userDefinedErrorCode = [NSString stringWithFormat:@"%u", (errorCode)parseError];
                                   NSDictionary *dictInnerInfo = [[NSDictionary alloc] initWithObjectsAndKeys:userDefinedErrorCode, @"code", nil];
                                   responseJSONDict = [[NSDictionary alloc] initWithObjectsAndKeys:dictInnerInfo, @"info", nil];
                               }
                               
                               ////NSLog(@"lJSONDict:%@\n%@", responseJSONDict,urlString);
                               if (target) {
                                   [target performSelectorOnMainThread:selector withObject:responseJSONDict waitUntilDone:YES];
                               }
                               [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                           }];
        
        [sessionDataTask resume];
    } else {
        [self noNetworkError:target];
    }
}

#pragma mark - CANCEL TASKS
/// Cancel all running or pending tasks
- (void)canceAllTasks {
    //NSLog(@"inside displayTaskList");
    
    [[globalData sharedInstance].globalNSURLSession  getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionTask *task in dataTasks) {
            [task cancel];
        }
    }];
}

/// Cancel a single task using input URL
- (void)cancelTaskListForURL:(NSString *)url {
    //NSLog(@"inside displayTaskList");
    [[globalData sharedInstance].globalNSURLSession  getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        for (NSURLSessionTask *task in dataTasks) {
            //NSLog(@"TaskDesc: %@",task.originalRequest.URL);
            NSString *str = [NSString stringWithFormat:@"%@", task.originalRequest.URL];
            if ([str isEqualToString:url]) {
                //NSLog(@"cancelling task for URL:%@", url);      //display which task is cancelled
                [task cancel];
            }
        }
    }];
}

#pragma mark - METHODS
- (void) noNetworkError:(id)target{
    [DisplayAlert displayAlertView:@"No Network" andMessage:@"Please check your internet connection"];
    [DisplayAnim removeRefreshControl:[target view]];
}

#pragma mark - REACHABILITY CHECK
//************  NETWORK CHECK STARTS *********************
-(BOOL)hasConnectivity {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;      //No internet available
    } else {
        return YES;     //Internel available
    }
}
//************  NETWORK CHECK ENDS *********************
@end
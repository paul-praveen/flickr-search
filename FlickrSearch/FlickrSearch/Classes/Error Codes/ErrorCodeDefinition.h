//
//  ErrorCodeDefinition.h
//  FlickrSearch
//
//  Created by Praveen on 26/08/16.
//  Copyright © 2016 #PPT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 User defined error code used for web-service response set.
 
 @usage: NSString *userDefinedErrorCode = [NSString stringWithFormat:@"%u", (errorCodeDeclaration)parseError];
 */
typedef enum {              //use it to define error code number
    APIKeyError = 100,
    parseError = 989898        //If json parsing or any such error occurs
}  errorCode;

@interface ErrorCodeDefinition: NSObject
@end
//
//  BaseController.h
//  iOSRepairApp
//
//  Created by Max on 10/28/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <office365_drive_sdk/office365_drive_sdk.h>

@interface BaseController : NSObject
//+(void)getClient : (void (^) (MSSharePointClient* ))callback;
+(UIActivityIndicatorView*)getSpinner : (UIView*)view;
@end

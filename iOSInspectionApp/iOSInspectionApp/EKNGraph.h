//
//  EKNGraph.h
//  iOSInspectionApp
//
//  Created by canviz on 10/23/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ADALiOS/ADAuthenticationContext.h>
#import <ADALiOS/ADAuthenticationParameters.h>
#import <ADALiOS/ADAuthenticationSettings.h>
#import <ADALiOS/ADLogger.h>
#import <ADALiOS/ADInstanceDiscovery.h>

@interface EKNGraph : NSObject
-(void)sendMail:(NSDictionary *)sendDataDic callback:(void (^)(int returnValue, NSError *error))callback;
@end

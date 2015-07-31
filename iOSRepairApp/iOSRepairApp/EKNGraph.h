//
//  EKNGraph.h
//  iOSRepairApp
//
//  Created by Tyler Lu on 5/14/15.
//  Copyright (c) 2015 canviz. All rights reserved.
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

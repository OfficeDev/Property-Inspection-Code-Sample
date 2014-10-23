//
//  EKNExchange.h
//  iOSInspectionApp
//
//  Created by canviz on 10/23/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKNExchange : NSObject
-(void)sendMailUsingExchange:(NSDictionary *)sendDataDic callback:(void (^)(int returnValue, NSError *error))callback;
@end

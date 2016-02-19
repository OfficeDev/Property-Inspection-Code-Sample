//
//  EKNGraph.h
//  iOSInspectionApp
//
//  Created by canviz on 10/23/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ADALiOS/ADAL.h>
#import <impl/impl.h>
#import <MSGraph-SDK-iOS/MSGraphService.h>


@interface EKNGraph : NSObject
-(void)sendMail:(NSDictionary *)sendDataDic callback:(void (^)(int returnValue, NSError *error))callback;
@end

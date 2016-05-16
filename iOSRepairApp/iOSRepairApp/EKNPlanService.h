//
//  EKNPlanService.h
//  iOSRepairApp
//
//  Created by canviz on 4/27/16.
//  Copyright © 2016 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKNGraphService.h"
#import "EKNEKNGlobalInfo.h"

@interface EKNPlanService : NSObject
-(void)updateTask:(NSString *)groupId incidentId:(NSString *)incidentId callback:(void (^)(NSString *error))updateTaskCallBack;
@end

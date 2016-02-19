//
//  EKNGraphService.h
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
#import <MSGraph-SDK-iOS/MSGraphServiceConversation.h>
#import <MSGraph-SDK-iOS/MSGraphService.h>
#import <MSGraph-SDK-iOS/MSGraphServiceClient.h>
#import "EKNEKNGlobalInfo.h"
#include "EKNOneNoteService.h"

@interface EKNGraphService : NSObject
-(void)sendMail:(NSDictionary *)sendDataDic callback:(void (^)(int returnValue, NSError *error))callback;
-(void)getGroupNotes: (NSString *)groupId  incidentId:(NSString *)incidentId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack;
-(void)getGroupFiles: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic,NSError *error))getGroupCallBack;
-(void)getGroupMembers: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack;
-(void)getGroupConversations: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack;
//-(void)uploadFileToGroup: (NSString *)groupId fileName:(NSString*)fileName fileStream:(NSStream*)fileStream callback:(void (^)(MSGraphServiceItem *file, NSError *error))uploadFileCallBack;

-(void)getPersonImage:(NSString *)groupId memberid:(NSString *)memberId callback:(void (^)(UIImage *image, NSError *error))getPersonImageCallBack;

-(void)updateTask:(NSString *)groupId incidentId:(NSString *)incidentId callback:(void (^)(NSString *error))updateTaskCallBack;
@end

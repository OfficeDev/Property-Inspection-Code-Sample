//
//  EKNGraphService.h
//  iOSRepairApp
//
//  Created by Tyler Lu on 5/14/15.
//  Copyright (c) 2015 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ADAL.h>
#import <MSGraphSDK.h>
#import <MSBlockAuthenticationProvider.h>
#import "NSString+NSStringExtensions.h"
#import "EKNEKNGlobalInfo.h"

@interface EKNGraphService : NSObject
-(void)clearUserTokenCachStore;
-(void)sendMail:(NSDictionary *)sendDataDic callback:(void (^)(int returnValue, NSError *error))callback;

-(void)getGroupFiles: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic,NSError *error))getGroupCallBack;
-(void)getGroupMembers: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSString *error))getGroupCallBack;
-(void)getGroupConversations: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack;
-(void)getPersonImage:(NSString *)groupId memberid:(NSString *)memberId callback:(void (^)(UIImage *image, NSError *error))getPersonImageCallBack;

-(void)getGraphServiceAccessToken:(void (^)(NSString* accessToken))callback;
-(void)getGraphServiceClient:(void (^)(MSGraphClient* client, NSError *error))callback;
@end

//
//  EKNOneNoteService.h
//  
//
//  Created by Tyler Lu on 9/1/15.
//
//

#import <Foundation/Foundation.h>
#import <MSGraphSDK.h>
#import "EKNGraphService.h"
#import "EKNEKNGlobalInfo.h"

@interface EKNOneNoteService : NSObject
-(void)getGroupNotePages: (NSString *)groupId  incidentId:(NSString *)incidentId callback:(void (^)(NSMutableDictionary *listDic, NSString *error))getGroupCallBack;
@end
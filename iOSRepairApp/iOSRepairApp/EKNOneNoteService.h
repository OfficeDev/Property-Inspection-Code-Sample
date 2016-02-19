//
//  EKNOneNoteService.h
//  
//
//  Created by Tyler Lu on 9/1/15.
//
//

#import <Foundation/Foundation.h>
#import <api/api.h>
#import <MSOneNote-SDK-iOS/MSOneNoteApi.h>
#import <ADALiOS/ADAuthenticationContext.h>
#import <ADALiOS/ADAuthenticationParameters.h>
#import <ADALiOS/ADAuthenticationSettings.h>
#import <ADALiOS/ADLogger.h>
#import <ADALiOS/ADInstanceDiscovery.h>
#import <MSGraph-SDK-iOS/MSGraphService.h>
#import <impl/impl.h>

@interface EKNOneNoteService : NSObject

-(void)getPagesWithCallBack: (MSGraphServiceGroup *)group incidentId:(NSString*)incidentId callback:(void (^)(NSString * notBookUrl, NSArray *pages, MSOrcError *error))callback;

@end
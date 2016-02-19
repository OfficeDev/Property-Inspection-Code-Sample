//
//  EKNVideoService.h
//  
//
//  Created by Tyler Lu on 9/8/15.
//
//

#import <Foundation/Foundation.h>
#import <ADALiOS/ADAuthenticationContext.h>
#import <ADALiOS/ADAuthenticationParameters.h>
#import <ADALiOS/ADAuthenticationSettings.h>
#import <ADALiOS/ADLogger.h>
#import <ADALiOS/ADInstanceDiscovery.h>
#import "SPVideoItem.h"
#import <core/core.h>
#import <impl/impl.h>

@interface EKNVedioService : NSObject
-(void)getVideos:(int)incidentId callback:(void (^)(NSArray *videoItems, MSOrcError *error))callback;
-(void)uploadVideo: (NSString*)title fileName:(NSString*)fileName fileData:(NSData*)fileData description:(NSString*)description callback:(void (^)(SPVideoItem *videoItem, MSOrcError *error))callback;
-(void)uploadDemoVideoForIncident:(NSString *)incidentId  callback:(void(^)(MSOrcError *error))callback;
@end
//
//  EKNVideoService.c
//  
//
//  Created by Tyler Lu on 9/8/15.
//
//

#import "orc.h"
#import <core/core.h>
#import "EKNVideoService.h"
#import "SPVideoChannel.h"
#import "SPVideoItemOperations.h"

@implementation EKNVedioService

-(void)getVideos:(int)incidentId callback:(void (^)(NSArray *videoItems, MSOrcError *error))callback
{
    MSOrcBaseContainer *videoClient = [self getVideoClient];
    [self getIncidentsChannel:videoClient callback:^(SPVideoChannel *channel, MSOrcError *error) {
        [self getVideos:videoClient channel:channel incidentId:incidentId callback: callback];
    }];
}

-(void)uploadVideo: (NSString*)title fileName:(NSString*)fileName fileData:(NSData*)fileData description:(NSString*)description callback:(void (^)(SPVideoItem *videoItem, MSOrcError *error))callback{
    
    MSOrcBaseContainer *videoClient = [self getVideoClient];
    [self getIncidentsChannel:videoClient callback:^(SPVideoChannel *channel, MSOrcError *error) {
        if(error != nil){
            callback(nil, error);
        }
        
        NSString *channelUrl = [NSString stringWithFormat:@"Channels('%@')", channel.Id];
        MSOrcEntityFetcher *channelFetcher = [[MSOrcEntityFetcher alloc] initWithUrl:channelUrl parent:videoClient asClass:[MSOrcBaseEntity class]];
        
        MSOrcCollectionFetcher *videoCollectionFetcher = [[MSOrcCollectionFetcher alloc] initWithUrl:@"Videos" parent:channelFetcher asClass:[SPVideoItem class]];
        SPVideoItem *videoItem = [[SPVideoItem alloc] init];
        videoItem.ID = nil;
        videoItem.Title = title;
        videoItem.FileName = fileName;
        videoItem.Description = description;
        
        [videoCollectionFetcher add:videoItem callback:^(SPVideoItem *videoItem, MSOrcError *error) {
            NSString *videoUrl = [NSString stringWithFormat:@"Videos(guid'%@')", videoItem.ID];
            MSOrcEntityFetcher *videoFetcher = [[MSOrcEntityFetcher alloc] initWithUrl:videoUrl parent:channelFetcher asClass:[SPVideoItem class]];
            SPVideoItemOperations *operations = [[SPVideoItemOperations alloc] initOperationWithUrl:@"GetFile()" parent:videoFetcher];
            [operations saveBinaryStream:fileData callback:^(int returnValue, MSOrcError *error) {
                //
            }];
            
            callback(videoItem, error);
        }];
        
    }];
}

-(void)getIncidentsChannel:(MSOrcBaseContainer*)videoClient callback:(void (^)(SPVideoChannel *channel, MSOrcError *error))callback{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *videoPortalIncidentsChannelName =[ standardUserDefaults objectForKey:@"videoPortalIncidentsChannelName"];
    
    MSOrcCollectionFetcher *channelsFetcher = [[MSOrcCollectionFetcher alloc] initWithUrl:@"Channels" parent:videoClient asClass:[SPVideoChannel class]];
    MSOrcCollectionFetcher *incidentsChannelFetcher = [[channelsFetcher filter:[NSString stringWithFormat:@"Title eq '%@'", videoPortalIncidentsChannelName]] top:1];
    
    [incidentsChannelFetcher  readWithCallback:^(NSArray *channels, MSOrcError *error) {
        SPVideoChannel *channel = channels.firstObject;
        callback(channel, error);
    }];
}

-(void)getVideos:(MSOrcBaseContainer*)videoClient channel:(SPVideoChannel*)channel incidentId:(int)incidentId callback:(void (^)(NSArray *videoItems, MSOrcError *error))callback{
    
    NSString *channelUrl = [NSString stringWithFormat:@"Channels('%@')", channel.Id];
    MSOrcEntityFetcher *channelFetcher = [[MSOrcEntityFetcher alloc] initWithUrl:channelUrl parent:videoClient asClass:[MSOrcBaseEntity class]];
    MSOrcCollectionFetcher *allVideosFetcher = [[MSOrcCollectionFetcher alloc]initWithUrl:@"GetAllVideos" parent:channelFetcher asClass:[SPVideoItem class]];
    [allVideosFetcher readWithCallback:^(NSArray *videoItems, MSOrcError *error) {
        NSString *incidentVideoTitleSuffix = [NSString stringWithFormat:@"[%d]", incidentId];
        NSMutableArray* incidentVideos = [[NSMutableArray alloc] init];
        for (SPVideoItem *videoItem in videoItems) {
            if ([videoItem.Title hasSuffix:incidentVideoTitleSuffix]) {
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:videoItem.Title forKey:@"title"];
                [item setObject:videoItem.YammerObjectUrl forKey:@"webUrl"];
                [incidentVideos addObject: item];
            }
        }
        callback(incidentVideos, error);
    }];

}

-(MSOrcBaseContainer*)getVideoClient{

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *demoSiteServiceResourceId = [standardUserDefaults objectForKey:@"demoSiteServiceResourceId"];
    NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];
    NSString *videoPortalEndpointUri = [standardUserDefaults objectForKey:@"videoPortalEndpointUri"];
    
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:[standardUserDefaults objectForKey:@"authority"] error:&error];
    if (!context) { return NULL; }
    
    ADALDependencyResolver *resolver = [[ADALDependencyResolver alloc] initWithContext:context resourceId:demoSiteServiceResourceId clientId: clientId redirectUri:redirectUri];
    
    
    NSString *videoServiceUrl = [NSString stringWithFormat:@"%@/_api/VideoService", videoPortalEndpointUri];
    return [[MSOrcBaseContainer alloc] initWithUrl:videoServiceUrl dependencyResolver:resolver];
}

@end
//
//  EKNPlanService.m
//  iOSRepairApp
//
//  Created by canviz on 4/27/16.
//  Copyright © 2016 canviz. All rights reserved.
//

#import "EKNPlanService.h"

@implementation EKNPlanService
-(void)getGroupPlane:(NSString *)groupId accessToken:(NSString *)accesstoken callbakc:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler{
    NSString *graphResourceUrl = [EKNEKNGlobalInfo getGraphBetaResourceUrl];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/groups/%@/plans", graphResourceUrl , groupId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", accesstoken] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        completionHandler(data, response, error);
    }];
    [task resume];
}
-(void)getPlaneBuckets:(NSString *)planId accessToken:(NSString *)accesstoken callbakc:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler{
    NSString *graphResourceUrl = [EKNEKNGlobalInfo getGraphBetaResourceUrl];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/plans/%@/buckets", graphResourceUrl , planId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", accesstoken] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        completionHandler(data, response, error);
    }];
    [task resume];
    
}
-(void)getBucketTasks:(NSString *)bucketId accessToken:(NSString *)accesstoken callbakc:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler{
    NSString *graphResourceUrl = [EKNEKNGlobalInfo getGraphBetaResourceUrl];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/buckets/%@/tasks", graphResourceUrl , bucketId];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", accesstoken] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        completionHandler(data, response, error);
    }];
    [task resume];
    
}
-(void)patchTask:(NSString *)taskId eTag:(NSString*)etag accessToken:(NSString *)accesstoken callbakc:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler{
    NSString *graphResourceUrl = [EKNEKNGlobalInfo getGraphBetaResourceUrl];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/tasks/%@", graphResourceUrl , taskId];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", accesstoken] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [request addValue:etag forHTTPHeaderField:@"If-Match"];
    [request setHTTPMethod:@"PATCH"];
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [NSNumber numberWithInteger:100], @"percentComplete",
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task  = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        completionHandler(data, response, error);
    }];
    [task resume];
}
-(void)updateTask:(NSString *)groupId incidentId:(NSString *)incidentId callback:(void (^)(NSString *error))updateTaskCallBack{
    
    EKNGraphService *graphService = [[EKNGraphService alloc] init];
    [graphService getGraphServiceAccessToken:^(NSString *accessToken) {
        if(accessToken != nil){
            [self getGroupPlane:groupId accessToken:accessToken callbakc:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSArray *planArray = [EKNEKNGlobalInfo parseResponseDataToArray:data];
                if(planArray != nil && [planArray count] > 0){
                    NSString *planId = [(NSDictionary *)[planArray objectAtIndex:0] objectForKey:@"id"];
                    [self getPlaneBuckets:planId accessToken:accessToken callbakc:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSArray *bucketArray = [EKNEKNGlobalInfo parseResponseDataToArray:data];
                        if(bucketArray != nil && [bucketArray count] > 0){
                            NSString *bucketId =@"";
                            for(NSDictionary* item in bucketArray) {
                                if([[item objectForKey:@"name"] isEqualToString: [NSString stringWithFormat:@"Incident [%@]", incidentId]]){
                                    bucketId = [item objectForKey:@"id"];
                                    break;
                                }
                            }
                            if(bucketId.length>0){
                                [self getBucketTasks:bucketId accessToken:accessToken callbakc:^(NSData *data, NSURLResponse *response, NSError *error){
                                    NSArray *tasksArray = [EKNEKNGlobalInfo parseResponseDataToArray: data];
                                    if(tasksArray != nil && [tasksArray count] > 0){
                                        for(NSDictionary* item in tasksArray){
                                            NSString *taskid = [item objectForKey:@"id"];
                                            NSString *etag = [item objectForKey:@"@odata.etag"];
                                            [self patchTask:taskid eTag:etag accessToken:accessToken callbakc:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if(![EKNEKNGlobalInfo requestSuccess:response])
                                                    {
                                                        NSLog(@"Patch Error");
                                                    }
                                                    else{
                                                        NSLog(@"Patch Success");
                                                    }
                                                });
                                            }];
                                        }
                                    }
                                }];
                            }
                        }
                    }];
                }
            }];
        }
        else{
            updateTaskCallBack(@"Get Graph AccessToken Fail.");
        }
    }];
}
@end

//
//  EKNOneNoteService.c
//  
//
//  Created by Tyler Lu on 9/1/15.
//
//
#include "EKNOneNoteService.h"


@implementation EKNOneNoteService

-(void)getGroupNoteBookByName:(NSString *)groupId groupNotebookName:(NSString *)notebookname accessToken:(NSString *)accesstoken callbakc:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler{
    
    NSString *graphResourceUrl = [EKNEKNGlobalInfo getGraphBetaResourceUrl];
    NSString *filter = [NSString stringWithFormat:@"$filter=name eq '%@'",notebookname];
    filter = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/groups/%@/notes/notebooks?%@", graphResourceUrl, groupId, filter];
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

-(void)getGroupNoteBookSectionByName:(NSString *)groupId sectionName:(NSString *)sectionName accessToken:(NSString *)accesstoken callbakc:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler{
    
    NSString *graphResourceUrl = [EKNEKNGlobalInfo getGraphBetaResourceUrl];
    NSString *filter = [NSString stringWithFormat:@"$filter=name eq '%@'",sectionName];
    filter = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/groups/%@/notes/sections?%@", graphResourceUrl, groupId, filter];
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
-(void)getGroupNoteBookPagesBySection:(NSString *)groupId sectionId:(NSString *)sectionId accessToken:(NSString *)accesstoken callbakc:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler{
    
    NSString *graphResourceUrl = [EKNEKNGlobalInfo getGraphBetaResourceUrl];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/groups/%@/notes/sections/%@/pages", graphResourceUrl, groupId, sectionId];
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

-(void)getGroupNotePages: (NSString *)groupId incidentId:(NSString *)incidentId callback:(void (^)(NSMutableDictionary *listDic, NSString *error))getGroupCallBack{
    EKNGraphService *graphService = [[EKNGraphService alloc] init];
    [graphService getGraphServiceClient:^(MSGraphClient *client, NSError *error){
        [[[client groups:groupId] request] getWithCompletion:^(MSGraphGroup *response, NSError *error) {
            if(response != nil){
                NSString *groupName = response.displayName;
                NSString *groupNotebookName =  [groupName stringByAppendingString:@" Notebook"];
                [graphService getGraphServiceAccessToken:^(NSString *accessToken) {
                    if(accessToken != nil){
                        [self getGroupNoteBookByName:groupId groupNotebookName:groupNotebookName accessToken:accessToken callbakc:^(NSData *data, NSURLResponse *response, NSError *error) {
                            NSArray *noteBookArray = [EKNEKNGlobalInfo parseResponseDataToArray: data];
                            if(noteBookArray != nil){
                                NSString * oneNoteBookWebUrl = [[[(NSDictionary *)[noteBookArray objectAtIndex:0] objectForKey:@"links"] objectForKey:@"oneNoteWebUrl"] objectForKey:@"href"];
                                [self getGroupNoteBookSectionByName:groupId sectionName:groupName accessToken:accessToken callbakc:^(NSData *data, NSURLResponse *response, NSError *error) {
                                    NSArray *sectionArray = [EKNEKNGlobalInfo parseResponseDataToArray: data];
                                    if(sectionArray != nil && [sectionArray count] >0 ){
                                        NSString * sectionId = [(NSDictionary *)[sectionArray objectAtIndex:0] objectForKey:@"id"];
                                        [self getGroupNoteBookPagesBySection:groupId sectionId:sectionId accessToken:accessToken callbakc:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSArray * pageArray = [EKNEKNGlobalInfo parseResponseDataToArray: data];
                                            if(pageArray != nil){
                                                NSMutableArray *array = [NSMutableArray array];
                                                for(NSDictionary *page in pageArray){
                                                    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                                                    [item setObject:[page objectForKey:@"title"] forKey:@"title"];
                                                    [item setObject:[[[page objectForKey:@"links"] objectForKey:@"oneNoteWebUrl"] objectForKey:@"href"] forKey:@"webUrl"];
                                                    [item setObject:[[[page objectForKey:@"links"] objectForKey:@"oneNoteClientUrl"] objectForKey:@"href"] forKey:@"clientUrl"];
                                                    [array addObject:item];
                                                }
                                                NSMutableDictionary *listDic = [[NSMutableDictionary alloc] init];
                                                [listDic setObject:array forKey:@"list"];
                                                [listDic setObject:oneNoteBookWebUrl forKey:@"viewAll"];
                                                getGroupCallBack(listDic ,nil);
                                                return;
                                            }
                                            getGroupCallBack(nil, @"Get getPagesArray Failure");
                                        }];
                                        return;
                                    }
                                    
                                    getGroupCallBack(nil, @"Get getGroupSection Failure");
                                }];
                                return;
                            }
                            getGroupCallBack(nil, @"Get getGroupNoteBook Failure");
                        }];
                    }
                    else{
                        getGroupCallBack(nil, @"Get accessToken Failure");
                    }
                }];
            }
        }];
    }];
}

@end


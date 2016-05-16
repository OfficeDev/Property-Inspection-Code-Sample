//
//  EKNGraphService.m
//  iOSInspectionApp
//
//  Created by canviz on 10/23/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNGraphService.h"

@import Foundation;

@implementation EKNGraphService

-(void)sendMail:(NSDictionary *)sendDataDic callback:(void (^)(int returnValue, NSError *error))callback
{
    NSString *to = [sendDataDic objectForKey:@"to"];
    NSString *cc = [sendDataDic objectForKey:@"cc"];
    NSString *subject = [sendDataDic objectForKey:@"subject"];
    NSString *body = [sendDataDic objectForKey:@"body"];
    
    [self getGraphServiceClient:^(MSGraphClient *client, NSError *error) {
        if(client != nil){
            MSGraphMessage *message = [[MSGraphMessage alloc] init];
            message.subject = subject;
            message.toRecipients= [self getRecipients:to];
            message.ccRecipients = [self getRecipients:cc];
            
            MSGraphItemBody *itemBody = [[MSGraphItemBody alloc] init];
            [itemBody setContent:body];
            message.body = itemBody;
            
            MSGraphUserSendMailRequest *req = [[[client me] sendMailWithMessage:message saveToSentItems:true] request];
            [req executeWithCompletion:^(NSDictionary *response, NSError *error) {
                callback(0,error);
            }];
        }
        else{
            //error
            callback(-1, nil);
        }
        
    }];
}
-(NSMutableArray*)getRecipients : (NSString*)text{
    NSMutableArray* result = (NSMutableArray*)[NSMutableArray array];
    NSArray* recipients = [text componentsSeparatedByString:@","];
    for (NSString* r in recipients) {
        MSGraphRecipient * recipient = [[MSGraphRecipient alloc] init];
        MSGraphEmailAddress *emailAddress = [[MSGraphEmailAddress alloc] init];
        emailAddress.address = [r stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [recipient setEmailAddress:emailAddress];
        [result addObject: recipient];
    }
    return result;
}

-(void)getGroupFiles: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack{
    
    [self getGraphServiceClient:^(MSGraphClient *client, NSError *error) {
        if(client != nil){
            [[[[[[client groups:groupId] drive] root] children] request] getWithCompletion:^(MSCollection *response, MSGraphDriveItemChildrenCollectionRequest *nextRequest, NSError *error) {
                if(response != nil){
                    NSMutableArray *array = [NSMutableArray array];
                    for(MSGraphDriveItem *file in response.value){
                        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                        [item setObject:file.name forKey:@"fileName"];  
                        [item setObject:file.createdBy.user.displayName forKey:@"author"];
                        [item setObject:file.lastModifiedDateTime forKey:@"lastmodified"];
                        [item setObject:[NSString stringWithFormat:@"%lli",file.size] forKey:@"size"];
                        [item setObject:file.webUrl forKey:@"webUrl"];
                        
                        if ([file.name.lowercaseString hasSuffix:@".docx"] | [file.name.lowercaseString hasSuffix:@".xlsx"] | [file.name.lowercaseString hasSuffix:@".pptx"]) {
                            [item setObject:file.webUrl forKey:@"webUrl"];
                            if([file.name.lowercaseString hasSuffix:@".docx"] ){
                                [item setObject:[NSString stringWithFormat:@"%@%@",[@"ms-word:ofv|u|" urlencode],file.webUrl] forKey:@"clientUrl"];
                            }
                            else if([file.name.lowercaseString hasSuffix:@".xlsx"] ){
                                [item setObject:[NSString stringWithFormat:@"%@%@",[@"ms-excel:ofv|u|" urlencode],file.webUrl] forKey:@"clientUrl"];
                            }
                            else if([file.name.lowercaseString hasSuffix:@".pptx"] ){
                                [item setObject:[NSString stringWithFormat:@"%@%@",[@"ms-powerpoint:ofv|u|" urlencode],file.webUrl] forKey:@"clientUrl"];
                            }
                        }
                        [array addObject:item];
                    }
                    NSMutableDictionary *listDic = [[NSMutableDictionary alloc] init];
                    [listDic setObject:array forKey:@"list"];
                    
                    
                    [listDic setObject:[NSString stringWithFormat:@"%@/_layouts/groupstatus.aspx?id=%@&target=Documents",[EKNEKNGlobalInfo getDemoSiteServiceResourceId],groupId] forKey:@"viewAll"];
                    getGroupCallBack(listDic ,nil);
                    return;
                }
                getGroupCallBack(nil, nil);
            }];
        }
        else{
            //error
            getGroupCallBack(nil, nil);
        }
        
    }];
    
    
}

-(void)getGroupMembers: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSString *error))getGroupCallBack{
    
    [self getGraphServiceClient:^(MSGraphClient *client, NSError *error) {
        if(client != nil){
            [[[client groups:groupId] request] getWithCompletion:^(MSGraphGroup *response, NSError *error) {
                MSGraphGroup *group = response;
                [[[[client groups:groupId] members] request] getWithCompletion:^(MSCollection *response, MSGraphGroupMembersCollectionWithReferencesRequest *nextRequest, NSError *error) {
                    if(response != nil){
                        NSMutableArray *array = [NSMutableArray array];
                        
                        for (MSGraphDirectoryObject *dictoryobj in response.value) {
                            MSGraphUser *member =[[MSGraphUser alloc] initWithDictionary:[dictoryobj dictionaryFromItem]];
                            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                            [item setObject:member.displayName forKey:@"name"];
                            [item setObject:member.entityId forKey:@"memberId"];
                            [array addObject:item];
                        }
                        
                        NSMutableDictionary *listDic = [[NSMutableDictionary alloc] init];
                        [listDic setObject:array forKey:@"list"];
                        
                        [listDic setObject:[NSString stringWithFormat:@"%@owa/#path=/group/%@/people",[EKNEKNGlobalInfo getOutlookResourceId],group.mail] forKey:@"viewAll"];
                        getGroupCallBack(listDic ,nil);
                    }
                    else{
                        getGroupCallBack(nil, nil);
                    }
                }];
            }];
            

        }
        else{
            //error
            getGroupCallBack(nil, nil);
        }
        
    }];
}

-(void)getPersonImage:(NSString *)groupId memberid:(NSString *)memberId callback:(void (^)(UIImage *image, NSError *error))getPersonImageCallBack{
    
    [self getGraphServiceClient:^(MSGraphClient *client, NSError *error) {
        if(client != nil){
            [[[client users:memberId] photoValue] downloadWithCompletion:^(NSURL *location, NSURLResponse *response, NSError *error) {
                NSData * data = [NSData dataWithContentsOfURL:location];
                UIImage *image  = [UIImage imageWithData:data];
                getPersonImageCallBack(image, nil);
            }];
        }
        else{
            getPersonImageCallBack(nil, nil);
        }
    }];
}

-(void)getGroupConversations: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack{
    
    [self getGraphServiceClient:^(MSGraphClient *client, NSError *error) {
        if(client != nil){
            [[[client groups:groupId] request] getWithCompletion:^(MSGraphGroup *response, NSError *error) {
                MSGraphGroup *group =response;
                [[[[client groups:groupId] conversations] request] getWithCompletion:^(MSCollection *response, MSGraphGroupConversationsCollectionRequest *nextRequest, NSError *error) {
                    NSMutableArray *array = [NSMutableArray array];
                    for(MSGraphConversation *conversation in response.value){
                        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                        [item setObject:conversation.topic forKey:@"topic"];
                        [item setObject:conversation.preview forKey:@"preview"];
                        [array addObject:item];
                    }
                    NSMutableDictionary *listDic = [[NSMutableDictionary alloc] init];
                    [listDic setObject:array forKey:@"list"];
                    [listDic setObject:[NSString stringWithFormat:@"%@owa/#path=/group/%@/mail",[EKNEKNGlobalInfo getOutlookResourceId],group.mail] forKey:@"viewAll"];
                    getGroupCallBack(listDic ,nil);
                }];
            }];
        }
        else{
            getGroupCallBack(nil, nil);
        }
    }];
}
-(void)getGraphServiceAccessToken:(void (^)(NSString* accessToken))callback{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    NSString *authority = [standardUserDefaults objectForKey:@"authority"];
    NSString *redirectUriString = [standardUserDefaults objectForKey:@"redirectUriString"];
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    if (!context)
    {
        callback(nil);
        return;
    }
    
    [context acquireTokenWithResource:graphResourceId clientId:clientId redirectUri:[NSURL URLWithString:redirectUriString] completionBlock:^(ADAuthenticationResult *result) {
        if(result != nil && result.status == AD_SUCCEEDED){
            callback(result.accessToken);
        }
        else{
            [self clearUserTokenCachStore];
            callback(nil);
        }
    }];
    
}
-(void)clearUserTokenCachStore{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *authority = [standardUserDefaults objectForKey:@"authority"];
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    if (!context)
    {
        return;
    }
    [[context tokenCacheStore] removeAllWithError:&error];
}
-(void)getGraphServiceClient:(void (^)(MSGraphClient* client, NSError *error))callback{
    
    [self getGraphServiceAccessToken:^(NSString *accessToken) {
        if(accessToken != nil){
            MSBlockAuthenticationProvider *provider = [MSBlockAuthenticationProvider providerWithBlock:^(NSMutableURLRequest *request, MSAuthenticationCompletion completion) {
                NSString *oauthAuthorizationHeader = [NSString stringWithFormat:@"bearer %@", accessToken];
                [request setValue:oauthAuthorizationHeader forHTTPHeaderField:@"Authorization"];
                completion(request, nil);
            }];
            [MSGraphClient setAuthenticationProvider:provider];
            callback([MSGraphClient client], nil);
        }
        else{
            callback(nil, nil);
        }
    }];
}
@end

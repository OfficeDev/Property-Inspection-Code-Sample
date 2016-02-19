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
    
    MSGraphServiceMessage *message = [MSGraphServiceMessage alloc];
    message.Subject = subject;
    message.ToRecipients = [self getRecipients:to];
    message.CcRecipients = [self getRecipients:cc];
    message.Body = [[MSGraphServiceItemBody alloc] init];
    [message.body setContent:body];
    //message.Body.Content = body;
    
    ADAuthenticationError *error;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:[standardUserDefaults objectForKey:@"authority"] error:&error];
    if (!context) { return; }
    
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    NSString *graphResourceUrl = [standardUserDefaults objectForKey:@"graphResourceUrl"];
    NSString *loginUser = [standardUserDefaults objectForKey:@"LogInUser"];
    NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];
    
    ADALDependencyResolver *resolver = [[ADALDependencyResolver alloc] initWithContext:context resourceId:graphResourceId clientId: clientId redirectUri:redirectUri];
    MSGraphServiceClient *client = [[MSGraphServiceClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphServiceUserFetcher *me = [[client users] getById:loginUser];
    
    [[me operations] sendMailWithMessage:message saveToSentItems:true callback:^(int returnValue, MSOrcError *error) {
        callback(0,error);
    }];
    return;
}

-(NSMutableArray*)getRecipients : (NSString*)text{
    NSMutableArray* result = (NSMutableArray*)[NSMutableArray array];
    NSArray* recipients = [text componentsSeparatedByString:@","];
    for (NSString* r in recipients) {
        MSGraphServiceRecipient* recipient = [[MSGraphServiceRecipient alloc] init];
        recipient.emailAddress = [MSGraphServiceEmailAddress alloc];
        [recipient.emailAddress setAddress:[r stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [result addObject: recipient];
    }
    return result;
}

-(void)getGroupNotes: (NSString *)groupId incidentId:(NSString *)incidentId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString * authority =[standardUserDefaults objectForKey:@"authority"];
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];
    NSString *oneNoteResourceId = [standardUserDefaults objectForKey:@"oneNoteResourceId"];
    NSString *graphResourceUrl = [standardUserDefaults objectForKey:@"graphResourceUrl"];
    
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    if (!context)
    {
        return getGroupCallBack(nil,error);
    };
    
    ADALDependencyResolver *resolver = [[ADALDependencyResolver alloc] initWithContext:context resourceId:graphResourceId clientId: clientId redirectUri:redirectUri];
    MSGraphServiceClient *client = [[MSGraphServiceClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphServiceGroupFetcher *groupFetcher = [[client groups] getById:groupId];
    [groupFetcher readWithCallback:^(MSGraphServiceGroup *group, MSOrcError *error) {
        if(error!=nil){
            return getGroupCallBack(nil,error);
        }        
        
        EKNOneNoteService *oneNoteService = [[EKNOneNoteService alloc] init];
        [oneNoteService getPagesWithCallBack:group incidentId:incidentId callback:^(NSString * notBookUrl,NSArray *pages, MSOrcError *error) {
            NSMutableArray *array = [NSMutableArray array];
            for(MSOneNoteApiPage *page in pages){
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:page.title forKey:@"title"];
                [item setObject:page.links.oneNoteWebUrl.href forKey:@"webUrl"];
                [item setObject:page.links.oneNoteClientUrl.href forKey:@"clientUrl"];
                [array addObject:item];
            }
            NSMutableDictionary *listDic = [[NSMutableDictionary alloc] init];
            [listDic setObject:array forKey:@"list"];
            [listDic setObject:notBookUrl forKey:@"viewAll"];
            getGroupCallBack(listDic ,nil);
        }];
        
    }];
}

-(void)getGroupFiles: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString * authority =[standardUserDefaults objectForKey:@"authority"];
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];
    NSString *graphResourceUrl = [standardUserDefaults objectForKey:@"graphResourceUrl"];
    NSString *demoSiteServiceResourceId = [standardUserDefaults objectForKey:@"demoSiteServiceResourceId"];
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    if (!context)
    {
        return getGroupCallBack(nil,error);
    };
    
    ADALDependencyResolver *resolver = [[ADALDependencyResolver alloc] initWithContext:context resourceId:graphResourceId clientId: clientId redirectUri:redirectUri];
    MSGraphServiceClient *client = [[MSGraphServiceClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphServiceGroupFetcher *groupFetcher = [[client groups] getById:groupId];
    [groupFetcher readWithCallback:^(MSGraphServiceGroup *group, MSOrcError *error) {
        if(error!=nil){
            return getGroupCallBack(nil,error);
        }
        
        
        //files
        NSMutableArray *array = [NSMutableArray array];
        [groupFetcher.drive.root.children readWithCallback:^(NSArray *files, MSOrcError *error) {
            for (MSGraphServiceDriveItem *file in files) {
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:file.name forKey:@"fileName"];
                [item setObject:file.createdBy.user.displayName forKey:@"author"];
                [item setObject:file.lastModifiedDateTime forKey:@"lastmodified"];
                [item setObject:[NSString stringWithFormat:@"%lli",file.size] forKey:@"size"];
                [item setObject:file.webUrl forKey:@"webUrl"];
                
                if ([file.name.lowercaseString hasSuffix:@".docx"] | [file.name.lowercaseString hasSuffix:@".xlsx"] | [file.name.lowercaseString hasSuffix:@".pptx"]) {
                    
                    [item setObject:/*webUrl*/file.webUrl forKey:@"webUrl"];
                    if([file.name.lowercaseString hasSuffix:@".docx"] ){
                        [item setObject:[NSString stringWithFormat:@"%@%@",[@"ms-word:ofv|u|" urlEncode],file.webUrl] forKey:@"clientUrl"];
                    }
                    else if([file.name.lowercaseString hasSuffix:@".xlsx"] ){
                        [item setObject:[NSString stringWithFormat:@"%@%@",[@"ms-excel:ofv|u|" urlEncode],file.webUrl] forKey:@"clientUrl"];
                    }
                    else if([file.name.lowercaseString hasSuffix:@".pptx"] ){
                        [item setObject:[NSString stringWithFormat:@"%@%@",[@"ms-powerpoint:ofv|u|" urlEncode],file.webUrl] forKey:@"clientUrl"];
                    }
                }
                [array addObject:item];
                
            };
            NSMutableDictionary *listDic = [[NSMutableDictionary alloc] init];
            [listDic setObject:array forKey:@"list"];
            
            
            [listDic setObject:[NSString stringWithFormat:@"%@/_layouts/groupstatus.aspx?id=%@&target=Documents",demoSiteServiceResourceId,groupId] forKey:@"viewAll"];
            getGroupCallBack(listDic ,nil);
        }];
        
    }];
}

-(void)getGroupMembers: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString * authority =[standardUserDefaults objectForKey:@"authority"];
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];
    NSString *graphResourceUrl = [standardUserDefaults objectForKey:@"graphResourceUrl"];
    NSString *outlookResourceId = [standardUserDefaults objectForKey:@"outlookResourceId"];
    
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    if (!context)
    {
        return getGroupCallBack(nil,error);
    };
    
    ADALDependencyResolver *resolver = [[ADALDependencyResolver alloc] initWithContext:context resourceId:graphResourceId clientId: clientId redirectUri:redirectUri];
    MSGraphServiceClient *client = [[MSGraphServiceClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphServiceGroupFetcher *groupFetcher = [[client groups] getById:groupId];
    [groupFetcher readWithCallback:^(MSGraphServiceGroup *group, MSOrcError *error) {
        
        if(error!=nil){
            return getGroupCallBack(nil,error);
        }
        
        MSGraphServiceDirectoryObjectCollectionFetcher *getMembers = [[MSGraphServiceDirectoryObjectCollectionFetcher alloc] initWithUrl:@"members" parent:groupFetcher asClass:[MSGraphServiceUser class]];
        [getMembers readWithCallback:^(NSArray *members, MSOrcError *error) {
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (MSGraphServiceUser *member in members) {
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:member.displayName forKey:@"name"];
                [item setObject:member._id forKey:@"memberId"];
                [array addObject:item];
            }
            
            NSMutableDictionary *listDic = [[NSMutableDictionary alloc] init];
            [listDic setObject:array forKey:@"list"];
            
            [listDic setObject:[NSString stringWithFormat:@"%@owa/#path=/group/%@/people",outlookResourceId,group.mail] forKey:@"viewAll"];
            getGroupCallBack(listDic ,nil);
        }];
    }];
}

-(void)getPersonImage:(NSString *)groupId memberid:(NSString *)memberId callback:(void (^)(UIImage *image, NSError *error))getPersonImageCallBack{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString * authority =[standardUserDefaults objectForKey:@"authority"];
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];
    NSString *graphResourceUrl = [standardUserDefaults objectForKey:@"graphResourceUrl"];
    
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    if (!context){
        return getPersonImageCallBack(nil,error);
    };
    
    ADALDependencyResolver *resolver = [[ADALDependencyResolver alloc] initWithContext:context resourceId:graphResourceId clientId: clientId redirectUri:redirectUri];
    MSGraphServiceClient *client = [[MSGraphServiceClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    
    //MSGraphServicePhotoFetcher *photoFetcher = [[[[client users] getById:memberId] userPhotos] getById:@"48X48"];
    MSOrcEntityFetcher *photoBinaryFetcher = [[MSOrcEntityFetcher alloc] initWithUrl:@"$value" parent:[client.users getById:memberId].photo/*photoFetcher*/ asClass:[MSOrcEntityFetcher class]];
    id<MSOrcRequest> request = [photoBinaryFetcher.parent.resolver createOrcRequest];
    [photoBinaryFetcher orcExecuteRequest:request callback:^(id<MSOrcResponse> response, MSOrcError *error) {
        UIImage *image = [UIImage imageWithData:response.data] ;
        getPersonImageCallBack(image,nil);
    }];
}

-(void)getGroupConversations: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString * authority =[standardUserDefaults objectForKey:@"authority"];
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];
    NSString *graphResourceUrl = [standardUserDefaults objectForKey:@"graphResourceUrl"];
    NSString *outlookResourceId = [standardUserDefaults objectForKey:@"outlookResourceId"];
    
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    if (!context)
    {
        return getGroupCallBack(nil,error);
    };
    
    ADALDependencyResolver *resolver = [[ADALDependencyResolver alloc] initWithContext:context resourceId:graphResourceId clientId: clientId redirectUri:redirectUri];
    MSGraphServiceClient *client = [[MSGraphServiceClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphServiceGroupFetcher *groupFetcher = [[client groups] getById:groupId];
    [groupFetcher readWithCallback:^(MSGraphServiceGroup *group, MSOrcError *error) {
        if(error!=nil){
            return getGroupCallBack(nil,error);
        }
        
        MSGraphServiceDirectoryObjectCollectionFetcher *getConversations = [[MSGraphServiceDirectoryObjectCollectionFetcher alloc] initWithUrl:@"Conversations" parent:groupFetcher asClass:[MSGraphServiceConversation  class]];
        [getConversations readWithCallback:^(NSArray *conversations, MSOrcError *error) {
            NSMutableArray *array = [NSMutableArray array];
            for (MSGraphServiceConversation *conversation in conversations) {
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:conversation.topic forKey:@"topic"];
                [item setObject:conversation.preview forKey:@"preview"];
                [array addObject:item];
            }
            NSMutableDictionary *listDic = [[NSMutableDictionary alloc] init];
            [listDic setObject:array forKey:@"list"];
            [listDic setObject:[NSString stringWithFormat:@"%@owa/#path=/group/%@/mail",outlookResourceId,group.mail] forKey:@"viewAll"];
            getGroupCallBack(listDic ,nil);
            
        }];
        
    }];
}

-(void)updateTask:(NSString *)groupId incidentId:(NSString *)incidentId callback:(void (^)(NSString *error))updateTaskCallBack{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString * authority =[standardUserDefaults objectForKey:@"authority"];
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];
    NSString *graphResourceUrl = [standardUserDefaults objectForKey:@"graphResourceUrl"];
    
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    if (!context)
    {
        return;
    }
    
    [context acquireTokenWithResource:graphResourceId clientId:clientId redirectUri:redirectUri completionBlock:^(ADAuthenticationResult *result) {
        if (result.status != AD_SUCCEEDED)
        {
            updateTaskCallBack(@"ADAuthenticationError");
        }
        else
        {
            NSString *requestUrl = [NSString stringWithFormat:@"%@/groups/%@/plans", graphResourceUrl , groupId];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
            [request addValue:[NSString stringWithFormat:@"Bearer %@", result.accessToken] forHTTPHeaderField:@"Authorization"];
            [request addValue:@"application/json" forHTTPHeaderField:@"accept"];
            [request setHTTPMethod:@"GET"];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSDictionary *retDict = [EKNEKNGlobalInfo parseResponseDataToDic: data];
                                              if(retDict != nil){
                                                  NSArray *retArray = [retDict objectForKey:@"value"];
                                                  if(retArray != nil){
                                                      NSString *planId = [(NSDictionary *)[retArray objectAtIndex:0] objectForKey:@"id"];
                                                      NSString *requestUrl = [NSString stringWithFormat:@"%@/plans/%@/buckets", graphResourceUrl , planId];
                                                      NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
                                                      [request addValue:[NSString stringWithFormat:@"Bearer %@", result.accessToken] forHTTPHeaderField:@"Authorization"];
                                                      [request addValue:@"application/json" forHTTPHeaderField:@"accept"];
                                                      [request setHTTPMethod:@"GET"];
                                                      NSURLSessionDataTask *task  = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                          NSDictionary *retDict = [EKNEKNGlobalInfo parseResponseDataToDic: data];
                                                          if(retDict != nil){
                                                              NSArray *retArray = [retDict objectForKey:@"value"];
                                                              NSString *bucketId =@"";
                                                              for(NSDictionary* item in retArray) {
                                                                  if([[item objectForKey:@"name"] isEqualToString: [NSString stringWithFormat:@"Incident [%@]", incidentId]]){
                                                                      bucketId = [item objectForKey:@"id"];
                                                                      break;
                                                                  }
                                                              }
                                                              if(bucketId.length>0){
                                                                  NSString *requestUrl = [NSString stringWithFormat:@"%@/buckets/%@/tasks", graphResourceUrl , bucketId];
                                                                  
                                                                  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
                                                                  [request addValue:[NSString stringWithFormat:@"Bearer %@", result.accessToken] forHTTPHeaderField:@"Authorization"];
                                                                  [request addValue:@"application/json" forHTTPHeaderField:@"accept"];
                                                                  [request setHTTPMethod:@"GET"];
                                                                  NSURLSessionDataTask *task  = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                                                                 {
                                                                                                     NSDictionary *retDict = [EKNEKNGlobalInfo parseResponseDataToDic: data];
                                                                                                     if(retDict != nil){
                                                                                                         NSArray *retArray = [retDict objectForKey:@"value"];
                                                                                                         for(NSDictionary* item in retArray) {
                                                                                                             NSString *taskid =[item objectForKey:@"id"];
                                                                                                             NSString *requestUrl = [NSString stringWithFormat:@"%@/tasks/%@", graphResourceUrl , taskid];
                                                                                                             
                                                                                                             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
                                                                                                             [request addValue:[NSString stringWithFormat:@"Bearer %@", result.accessToken] forHTTPHeaderField:@"Authorization"];
                                                                                                             [request addValue:@"application/json" forHTTPHeaderField:@"accept"];
                                                                                                             [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
                                                                                                             
                                                                                                             [request addValue:[item objectForKey:@"@odata.etag"] forHTTPHeaderField:@"If-Match"];
                                                                                                             [request setHTTPMethod:@"PATCH"];
                                                                                                             
                                                                                                             
                                                                                                             NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                                                                                  [NSNumber numberWithInteger:100], @"percentComplete",
                                                                                                                                  nil];
                                                                                                             NSError *error;
                                                                                                             NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
                                                                                                             [request setHTTPBody:postdata];
                                                                                                             NSURLSessionDataTask *task  = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
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
                                                                                                             [task resume];
                                                                                                         }
                                                                                                     }
                                                                                                 }];
                                                                  [task resume];
                                                              }
                                                          }
                                                          
                                                      }];
                                                      [task resume];
                                                      
                                                  }
                                              }
                                              
                                          }];
            [task resume];
        }
    }];
    
    
}
/*-(void)uploadFileToGroup: (NSString *)groupId fileName:(NSString*)fileName fileStream:(NSStream*)fileStream callback:(void (^)(MSGraphItem *file, NSError *error))uploadFileCallBack{
 NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
 NSString * authority =[standardUserDefaults objectForKey:@"authority"];
 NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
 NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
 NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];    NSString *graphResourceUrl = [standardUserDefaults objectForKey:@"graphResourceUrl"];
 
 ADAuthenticationError *error;
 ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
 if (!context)
 {
 return uploadFileCallBack(nil,error);
 };
 
 ADALDependencyResolver *resolver = [[ADALDependencyResolver alloc] initWithContext:context resourceId:graphResourceId clientId: clientId redirectUri:redirectUri];
 MSGraphClient *client = [[MSGraphClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
 
 MSGraphGroupFetcher *groupFetcher = [[client groups] getById:groupId];
 [groupFetcher readWithCallback:^(MSGraphGroup *group, MSOrcError *error) {
 if(error!=nil){
 return uploadFileCallBack(nil,error);
 }
 
 MSGraphFile *file = [[MSGraphFile alloc] init];
 file.name = fileName;
 
 [[groupFetcher files] add:file callback:^(MSGraphItem *item, MSOrcError *error) {
 MSGraphItemFetcher *fileFecther = [[groupFetcher files] getById:item.id];
 [[fileFecther operations] uploadContentWithContentStream:fileStream callback:^(int returnValue, MSOrcError *error) {
 uploadFileCallBack(item, error);
 }];
 }];
 }];
 }*/

@end

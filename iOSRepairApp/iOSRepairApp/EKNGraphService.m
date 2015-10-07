//
//  EKNGraphService.m
//  iOSInspectionApp
//
//  Created by canviz on 10/23/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "orc.h"
#import "EKNGraphService.h"
#import "EKNEKNGlobalInfo.h"
#import <unified_services/unified_services.h>
#import <unified_services/MSGraphModels.h>
#include "EKNOneNoteService.h"
#include "MSGraphConversation.h"
@import Foundation;

@implementation EKNGraphService

-(void)sendMail:(NSDictionary *)sendDataDic callback:(void (^)(int returnValue, NSError *error))callback
{
    NSString *to = [sendDataDic objectForKey:@"to"];
    NSString *cc = [sendDataDic objectForKey:@"cc"];
    NSString *subject = [sendDataDic objectForKey:@"subject"];
    NSString *body = [sendDataDic objectForKey:@"body"];
    
    MSGraphMessage *message = [MSGraphMessage alloc];
    message.Subject = subject;
    message.ToRecipients = [self getRecipients:to];
    message.CcRecipients = [self getRecipients:cc];
    message.Body = [[MSGraphItemBody alloc] init];
    message.Body.Content = body;    
    
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
    MSGraphClient *client = [[MSGraphClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphUserFetcher *me = [[client users] getById:loginUser];
    
    [[me operations] sendMailWithMessage:message saveToSentItems:true callback:^(int returnValue, MSOrcError *error) {
        callback(0,error);
    }];
    return;
}

-(NSMutableArray*)getRecipients : (NSString*)text{
    NSMutableArray* result = (NSMutableArray*)[NSMutableArray array];
    NSArray* recipients = [text componentsSeparatedByString:@","];
    for (NSString* r in recipients) {
        MSGraphRecipient* recipient = [[MSGraphRecipient alloc] init];
        recipient.emailAddress = [MSGraphEmailAddress alloc];
        recipient.EmailAddress.Address = [r stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [result addObject: recipient];
    }
    return result;
}

-(void)getGroupNotes: (NSString *)groupId callback:(void (^)(NSMutableDictionary *listDic, NSError *error))getGroupCallBack{
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
    MSGraphClient *client = [[MSGraphClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphGroupFetcher *groupFetcher = [[client groups] getById:groupId];
    [groupFetcher readWithCallback:^(MSGraphGroup *group, MSOrcError *error) {
        if(error!=nil){
           return getGroupCallBack(nil,error);
        }
        [context acquireTokenWithResource:oneNoteResourceId clientId:clientId  redirectUri:redirectUri completionBlock:^(ADAuthenticationResult *result) {
            
            EKNOneNoteService *oneNoteService = [[EKNOneNoteService alloc] init];
            [oneNoteService getPagesWithCallBack:group propertyName:@"Au Residence" incidentId:19 callback:^(NSString * notBookUrl,NSArray *pages, MSOrcError *error) {
                NSMutableArray *array = [NSMutableArray array];
                for(MSOneNotePage *page in pages){
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
    MSGraphClient *client = [[MSGraphClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphGroupFetcher *groupFetcher = [[client groups] getById:groupId];
    [groupFetcher readWithCallback:^(MSGraphGroup *group, MSOrcError *error) {
        if(error!=nil){
            return getGroupCallBack(nil,error);
        }
        //files
        NSMutableArray *array = [NSMutableArray array];
        [[groupFetcher files] readWithCallback:^(NSArray *files, MSOrcError *error) {
            for (MSGraphItem *file in files) {
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:file.name forKey:@"fileName"];
                [item setObject:file.createdBy.user.displayName forKey:@"author"];
                [item setObject:file.dateTimeLastModified forKey:@"lastmodified"];
                [item setObject:[NSString stringWithFormat:@"%d",file.size] forKey:@"size"];
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
    MSGraphClient *client = [[MSGraphClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphGroupFetcher *groupFetcher = [[client groups] getById:groupId];
    [groupFetcher readWithCallback:^(MSGraphGroup *group, MSOrcError *error) {
        
        if(error!=nil){
            return getGroupCallBack(nil,error);
        }
        
        MSGraphDirectoryObjectCollectionFetcher *getMembers = [[MSGraphDirectoryObjectCollectionFetcher alloc] initWithUrl:@"members" parent:groupFetcher asClass:[MSGraphUser class]];
        [getMembers readWithCallback:^(NSArray *members, MSOrcError *error) {
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (MSGraphUser *member in members) {
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:member.displayName forKey:@"name"];
                [item setObject:member.objectId forKey:@"memberId"];
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
    MSGraphClient *client = [[MSGraphClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphPhotoFetcher *photoFetcher = [[[[client users] getById:memberId] userPhotos] getById:@"48X48"];
    MSOrcEntityFetcher *photoBinaryFetcher = [[MSOrcEntityFetcher alloc] initWithUrl:@"$value" parent:photoFetcher asClass:[MSOrcEntityFetcher class]];
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
    MSGraphClient *client = [[MSGraphClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    
    MSGraphGroupFetcher *groupFetcher = [[client groups] getById:groupId];
    [groupFetcher readWithCallback:^(MSGraphGroup *group, MSOrcError *error) {
        if(error!=nil){
            return getGroupCallBack(nil,error);
        }

        MSGraphDirectoryObjectCollectionFetcher *getConversations = [[MSGraphDirectoryObjectCollectionFetcher alloc] initWithUrl:@"Conversations" parent:groupFetcher asClass:[MSGraphConversation  class]];
        [getConversations readWithCallback:^(NSArray *conversations, MSOrcError *error) {
            NSMutableArray *array = [NSMutableArray array];
            for (MSGraphConversation *conversation in conversations) {
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

-(void)uploadFileToGroup: (NSString *)groupId fileName:(NSString*)fileName fileStream:(NSStream*)fileStream callback:(void (^)(MSGraphItem *file, NSError *error))uploadFileCallBack{
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
}

@end

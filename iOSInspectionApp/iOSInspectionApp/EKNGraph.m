//
//  EKNGraph.m
//  iOSInspectionApp
//
//  Created by canviz on 10/23/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNGraph.h"
#import "EKNEKNGlobalInfo.h"
@import Foundation;

@implementation EKNGraph

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

-(void)getGraphServiceAccessToken:(void (^)(ADAuthenticationResult* result))callback{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    NSString *authority = [standardUserDefaults objectForKey:@"authority"];
    NSString *redirectUriString = [standardUserDefaults objectForKey:@"redirectUriString"];
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    if (!context)
    {
        //here need
        callback(nil);
        return;
    }
    
    [context acquireTokenWithResource:graphResourceId clientId:clientId redirectUri:[NSURL URLWithString:redirectUriString] completionBlock:^(ADAuthenticationResult *result) {
        callback(result);
    }];
    
}
-(void)signOut{
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
    
    [self getGraphServiceAccessToken:^(ADAuthenticationResult *result) {
        if(result != nil && result.status == AD_SUCCEEDED){
            NSString *accessToken = result.accessToken;
            MSBlockAuthenticationProvider *provider = [MSBlockAuthenticationProvider providerWithBlock:^(NSMutableURLRequest *request, MSAuthenticationCompletion completion) {
                NSString *oauthAuthorizationHeader = [NSString stringWithFormat:@"bearer %@", accessToken];
                [request setValue:oauthAuthorizationHeader forHTTPHeaderField:@"Authorization"];
                completion(request, nil);
            }];
            [MSGraphClient setAuthenticationProvider:provider];
            
            callback([MSGraphClient client], nil);
        }
        else{
            [self signOut];
            callback(nil, nil);
        }
    }];
}

@end

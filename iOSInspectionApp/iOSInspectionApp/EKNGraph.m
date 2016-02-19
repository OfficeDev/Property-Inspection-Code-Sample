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
    NSString *loginUser = [sendDataDic objectForKey:@"LogInUser"];
   
    MSGraphServiceMessage *message = [[MSGraphServiceMessage alloc] init];
    message.subject = subject;
    message.toRecipients = [self getRecipients:to];
    message.ccRecipients = [self getRecipients:cc];
    
    MSGraphServiceItemBody *itembody =[[MSGraphServiceItemBody alloc] init];
    [itembody setContent:body];
    
    message.body = itembody;
        
    ADAuthenticationError *error;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:[standardUserDefaults objectForKey:@"authority"] error:&error];
    if (!context) { return; }
    
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    NSString *graphResourceUrl = [standardUserDefaults objectForKey:@"graphResourceUrl"];
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

@end

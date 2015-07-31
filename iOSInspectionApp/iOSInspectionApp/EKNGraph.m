//
//  EKNGraph.m
//  iOSInspectionApp
//
//  Created by canviz on 10/23/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNGraph.h"
#import "EKNEKNGlobalInfo.h"
#import <office365_odata_base/office365_odata_base.h>
#import <office365_graph_sdk/office365_graph_sdk.h>
@import Foundation;

@implementation EKNGraph

-(void)sendMail:(NSDictionary *)sendDataDic callback:(void (^)(int returnValue, NSError *error))callback
{
    NSString *to = [sendDataDic objectForKey:@"to"];
    NSString *cc = [sendDataDic objectForKey:@"cc"];
    NSString *subject = [sendDataDic objectForKey:@"subject"];
    NSString *body = [sendDataDic objectForKey:@"body"];
    NSString *loginUser = [sendDataDic objectForKey:@"LogInUser"];
   
    MSGraphServiceMessage *message = [MSGraphServiceMessage alloc];
    message.Subject = subject;
    message.ToRecipients = [self getRecipients:to];
    message.CcRecipients = [self getRecipients:cc];
    message.Body = [[MSGraphServiceItemBody alloc] init];
    message.Body.Content = body;
        
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
    
    MSGraphServiceUserFetcher *me = [[client getusers] getById:loginUser];
    NSURLSessionTask *task = [me.operations sendMailWithMessage:message saveToSentItems:true callback:^(int returnValue, MSODataException *exception) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Message sent!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [alert show];
    }];
    [task resume];
    return;
}

-(NSMutableArray<MSGraphServiceRecipient>*)getRecipients : (NSString*)text{
    NSMutableArray<MSGraphServiceRecipient>* result = (NSMutableArray<MSGraphServiceRecipient>*)[NSMutableArray array];
    NSArray* recipients = [text componentsSeparatedByString:@","];
    for (NSString* r in recipients) {
        MSGraphServiceRecipient* recipient = [[MSGraphServiceRecipient alloc] init];
        recipient.EmailAddress = [MSGraphServiceEmailAddress alloc];
        recipient.EmailAddress.Address = [r stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [result addObject: recipient];
    }
    return result;
}

@end

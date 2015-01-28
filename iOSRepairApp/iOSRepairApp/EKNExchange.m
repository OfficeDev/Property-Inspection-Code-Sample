//
//  EKNExchange.m
//  iOSInspectionApp
//
//  Created by canviz on 10/23/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNExchange.h"
#import "EKNEKNGlobalInfo.h"
#import <office365_odata_base/office365_odata_base.h>
#import <office365_exchange_sdk/office365_exchange_sdk.h>

@implementation EKNExchange

-(void)sendMailUsingExchange:(NSDictionary *)sendDataDic callback:(void (^)(int returnValue, NSError *error))callback
{
    NSString *to = [sendDataDic objectForKey:@"to"];
    NSString *cc = [sendDataDic objectForKey:@"cc"];
    NSString *subject = [sendDataDic objectForKey:@"subject"];
    NSString *token =[sendDataDic objectForKey:@"exchangetoken"];
    NSString *body = [sendDataDic objectForKey:@"body"];
    
    
    MSDefaultDependencyResolver* resolver = [MSDefaultDependencyResolver alloc];
    MSOAuthCredentials* credentials = [MSOAuthCredentials alloc];
    [credentials addToken:token];
    
    MSCredentialsImpl* credentialsImpl = [MSCredentialsImpl alloc];
    
    [credentialsImpl setCredentials:credentials];
    [resolver setCredentialsFactory:credentialsImpl];
    
    MSOutlookClient *client = [[MSOutlookClient alloc] initWitUrl:@"https://outlook.office365.com/api/v1.0" dependencyResolver:resolver];
    
    
    MSOutlookMessage *message = [MSOutlookMessage alloc];
    
    message.Subject = subject;
    message.ToRecipients = [self getRecipients:to];
    message.CcRecipients = [self getRecipients:cc];
    message.Body = [[MSOutlookItemBody alloc] init];
    message.Body.Content = body;
    
    NSURLSessionDataTask* task = [[[client getMe] getOperations]sendMail:message :true :callback];
    [task resume];
    
    /*
     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Message sent!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
     
     [alert show];
     */
    
    return;
}

-(NSMutableArray<MSOutlookRecipient>*)getRecipients : (NSString*)text{
    
    NSMutableArray<MSOutlookRecipient>* result = (NSMutableArray<MSOutlookRecipient>*)[NSMutableArray array];
    
    NSArray* recipients = [text componentsSeparatedByString:@","];
    
    for (NSString* r in recipients) {
        
        MSOutlookRecipient* recipient = [[MSOutlookRecipient alloc] init];
        recipient.EmailAddress = [MSOutlookEmailAddress alloc];
        recipient.EmailAddress.Address = [r stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [result addObject: recipient];
    }
    return result;
}

@end

//
//  EKNExchange.m
//  iOSInspectionApp
//
//  Created by canviz on 10/23/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNExchange.h"
#import "EKNEKNGlobalInfo.h"
#import <office365_exchange_sdk/MSOMessage.h>
#import <office365_exchange_sdk/MSORecipient.h>
#import <office365_exchange_sdk/MSOEmailAddress.h>
#import <office365_exchange_sdk/MSOItemBody.h>
#import <office365_exchange_sdk/MSOMessageOperations.h>
#import <office365_exchange_sdk/MSOMessageFetcher.h>
#import <office365_odata_base/office365_odata_base.h>
#import <office365_exchange_sdk/MSOEntityContainerClient.h>

#import <ADALiOS/ADAuthenticationContext.h>
#import <ADALiOS/ADAuthenticationSettings.h>

@implementation EKNExchange

-(void)sendMailUsingExchange:(NSDictionary *)sendDataDic callback:(void (^)(int returnValue, NSError *error))callback
{
    NSString *to = [sendDataDic objectForKey:@"to"];
    NSString *cc = [sendDataDic objectForKey:@"cc"];
    NSString *subject = [sendDataDic objectForKey:@"subject"];
    NSString *token =[sendDataDic objectForKey:@"exchangetoken"];
    NSString *body = [sendDataDic objectForKey:@"body"];
    
    
     MSODefaultDependencyResolver* resolver = [MSODefaultDependencyResolver alloc];
     MSOOAuthCredentials* credentials = [MSOOAuthCredentials alloc];
     [credentials addToken:token];
     
     MSOCredentialsImpl* credentialsImpl = [MSOCredentialsImpl alloc];
     
     [credentialsImpl setCredentials:credentials];
     [resolver setCredentialsFactory:credentialsImpl];
     
     MSOEntityContainerClient *client = [[MSOEntityContainerClient alloc] initWitUrl:@"https://sdfpilot.outlook.com/ews/odata" dependencyResolver:resolver];
     
     
     MSOMessage *message = [MSOMessage alloc];
     
     message.Subject = subject;
     message.ToRecipients = [self getRecipients:to];
     message.CcRecipients = [self getRecipients:cc];
     message.Body = [[MSOItemBody alloc] init];
     message.Body.Content = body;
     
     NSURLSessionDataTask* task = [[[client getMe] getOperations]sendMail:message :true :callback];
     [task resume];
    
    /*
     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Message sent!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
     
     [alert show];
     */
     
     return;
}

-(NSMutableArray<MSORecipient>*)getRecipients : (NSString*)text{
    
    NSMutableArray<MSORecipient>* result = (NSMutableArray<MSORecipient>*)[NSMutableArray array];
    
    NSArray* recipients = [text componentsSeparatedByString:@","];
    
    for (NSString* r in recipients) {
        
        MSORecipient* recipient = [[MSORecipient alloc] init];
        recipient.EmailAddress = [MSOEmailAddress alloc];
        recipient.EmailAddress.Address = [r stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [result addObject: recipient];
    }
    return result;
}

@end

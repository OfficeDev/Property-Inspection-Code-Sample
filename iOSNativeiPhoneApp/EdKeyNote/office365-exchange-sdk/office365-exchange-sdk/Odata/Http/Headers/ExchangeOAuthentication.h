//
//  OAuthentication.h
//  office365-base-sdk
//
//  Copyright (c) 2014 Microsoft Open Technologies, Inc.
//  All rights reserved.
//

#import "ExchangeCredentials.h"

@interface ExchangeOAuthentication : ExchangeCredentials

@property ()NSString *token;

-(id)initWith : (NSString *)token;
-(void)prepareRequest:(NSMutableURLRequest *)request;
-(NSString*)getToken;

@end
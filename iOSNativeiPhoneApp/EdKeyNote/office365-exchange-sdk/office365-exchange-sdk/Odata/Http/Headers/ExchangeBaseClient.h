//
//  BaseClient.h
//
//  Copyright (c) 2014 Microsoft Open Technologies, Inc.
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeCredentials.h"

@interface ExchangeBaseClient : NSObject

@property (nonatomic) ExchangeCredentials *Credential;
@property (nonatomic) NSString *Url;
@property (nonatomic) NSMutableData *data;

- (id)initWithUrl:(NSString *)url credentials:(ExchangeCredentials *)credentials;
- (NSMutableArray *)parseData:(NSData *)data;

@end
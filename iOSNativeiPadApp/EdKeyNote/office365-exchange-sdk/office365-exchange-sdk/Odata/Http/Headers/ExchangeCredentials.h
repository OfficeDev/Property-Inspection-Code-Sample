//
//  Credentials.h
//
//  Copyright (c) 2014 Microsoft Open Technologies, Inc.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeCredentials : NSObject

- (void)prepareRequest:(NSMutableURLRequest *)request;

@end
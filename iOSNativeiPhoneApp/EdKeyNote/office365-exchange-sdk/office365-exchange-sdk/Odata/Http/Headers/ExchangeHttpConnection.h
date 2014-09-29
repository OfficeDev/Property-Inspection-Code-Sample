//
//  HttpConection.h
//
//  Copyright (c) 2014 Microsoft Open Technologies, Inc.
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeCredentials.h"

@interface ExchangeHttpConnection : NSObject

@property (nonatomic) NSMutableURLRequest *request;
@property (nonatomic) ExchangeCredentials *credentials;

- (instancetype)initWithCredentials:(ExchangeCredentials *)credentials url:(NSString *)url;
- (instancetype)initWithCredentials:(ExchangeCredentials *)credentials url:(NSString *)url body:(NSString *)body;
- (instancetype)initWithCredentials:(ExchangeCredentials *)credentials url:(NSString *)url bodyArray:(NSData *)bodyArray;
- (NSURLSessionDataTask *)execute:(NSString *)method callback:(void (^)(NSData *, NSURLResponse *, NSError *))callback;
- (NSURLSessionDownloadTask*) download: (NSString*) method delegate:(id <NSURLSessionDelegate>)delegate;

@end
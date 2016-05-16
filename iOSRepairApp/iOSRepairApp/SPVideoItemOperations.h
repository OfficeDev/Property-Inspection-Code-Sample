//
//  SPVideoItemOperations.h
//  
//
//  Created by Tyler Lu on 9/10/15.
//
//

#import <core/core.h>

@interface SPVideoItemOperations : MSOrcOperations

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent;
- (void)saveBinaryStream:(NSData *)data callback:(void (^)(int returnValue, MSOrcError *error))callback;

@end
//
//  SPVideoItemOperations.c
//  
//
//  Created by Tyler Lu on 9/10/15.
//
//

#import "SPVideoItemOperations.h"

@implementation SPVideoItemOperations


- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent {
    
    return [super initOperationWithUrl:urlComponent parent:parent];
}

- (void)saveBinaryStream:(NSData *)data callback:(void (^)(int returnValue, MSOrcError *error))callback {
    
    return [self uploadContentRawWithContent:data callback:^(NSString *returnValue, MSOrcError *e) {
        
        if (e == nil) {
            
            //cloirs modify for new sdk
            //int result = (int)[super.resolver.jsonSerializer deserialize:[returnValue dataUsingEncoding:NSUTF8StringEncoding] asClass:nil];
            callback(0, e);
        }
        else {
            
            callback((int)[returnValue integerValue], e);
        }
    }];
}

- (void)uploadContentRawWithContent:(NSData *)content callback:(void(^)(NSString *returnValue, MSOrcError *error))callback {
    
    id<MSOrcRequest> request = [super.resolver createOrcRequest];
    
    [request setContent:content];
    [request setVerb:HTTP_VERB_POST];
    [request.url appendPathComponent:@"SaveBinaryStream"];
    
    return [super orcExecuteRequest:request callback:^(id<MSOrcResponse> response, MSOrcError *e) {
        
        if (e == nil) {
            
            callback([[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding], e);
        }
        else {
            
            callback([[NSString alloc] initWithFormat:@"%d", response.status], e);
        }
    }];
}


@end
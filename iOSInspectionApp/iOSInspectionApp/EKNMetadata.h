//
//  EKNMetadata.h
//  EdKeyNote
//
//  Created by canviz on 10/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKNMetadata : NSObject
@property (nonatomic) NSString *Id;
@property (nonatomic) NSString *Uri;
@property (nonatomic) NSString *type;
- (instancetype)initWith:(NSDictionary *) data;
@end

//
//  EKNListItem.h
//  office365-lists-sdk
//
//  Created by Lagash on 8/13/14.
//  Copyright (c) 2014 Lagash. All rights reserved.
//
#import "EKNMetadata.h"
@interface EKNListItem : NSObject

@property NSString *Id;
@property EKNMetadata *Metadata;
- (id) initWithDictionary:(NSDictionary *)dictionary;
-(NSObject*) getData:(NSString *)name;
@end

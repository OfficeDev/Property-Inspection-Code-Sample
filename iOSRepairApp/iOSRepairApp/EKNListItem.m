//
//  ListItem.m
//  office365-lists-sdk
//
//  Created by Lagash on 8/13/14.
//  Copyright (c) 2014 Lagash. All rights reserved.
//

#import "EKNListItem.h"

@interface EKNListItem ()
@property NSDictionary *jsonData;
@end

@implementation EKNListItem

- (id) initWithDictionary:(NSDictionary *)dictionary{
    
    [self createFromJson:dictionary];
    return self;
}

-(void) createMetadata : (NSDictionary *) data{
    self.Metadata = [[EKNMetadata alloc] initWith:data];
}


- (void)createFromJson:(NSDictionary *)data{
    NSDictionary *metadata = [data valueForKey : @"__metadata"];
    
    [self createMetadata : metadata];
    
    self.Id =[data valueForKey: @"Id"];
    self.jsonData = data;
}
-(NSObject*) getData:(NSString *)name{
    return [self.jsonData valueForKey:name];
}
@end

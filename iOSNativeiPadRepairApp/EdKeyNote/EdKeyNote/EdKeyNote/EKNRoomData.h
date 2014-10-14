//
//  EKNRoomData.h
//  EdKeyNote
//
//  Created by canviz on 9/30/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKNRoomData : NSObject
@property(nonatomic) NSNumber *roomId;
@property(nonatomic) NSString *roomTitle;

@property(nonatomic) NSMutableArray *roomImages;

-(void)initParameter:(NSNumber* )roomid
               Title:(NSString *)title
               RoomImages:(NSMutableArray *)roomimagesarray;
@end

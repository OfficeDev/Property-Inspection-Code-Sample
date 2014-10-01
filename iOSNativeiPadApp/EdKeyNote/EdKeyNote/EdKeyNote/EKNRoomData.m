//
//  EKNRoomData.m
//  EdKeyNote
//
//  Created by canviz on 9/30/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNRoomData.h"

@implementation EKNRoomData
-(void)initParameter:(NSNumber* )roomid
               Title:(NSString *)title
          RoomImages:(NSMutableArray *)roomimagesarray
{
    self.roomId = roomid;
    self.roomTitle = title;
    self.roomImages = roomimagesarray;
}
@end

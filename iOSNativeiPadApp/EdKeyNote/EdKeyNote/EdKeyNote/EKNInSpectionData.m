//
//  EKNInspectionData.m
//  EdKeyNote
//
//  Created by canviz on 9/30/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNInspectionData.h"

@implementation EKNInspectionData

-(void)initParameter:(NSNumber* )inspectionid
     InspectionTitle:(NSString *)title
  InspectionDateTime:(NSString *)datetime
       InspectorName:(NSString *)name
   InspectionProperty:(EKNPropertyData *)property
      InspectionRooms:(EKNRoomData *)rooms
{
    self.inspectionId = inspectionid;
    self.inspectionTitle = title;
    self.inspectionDateTime = datetime;
    self.inspectorName = name;
    self.inspectionProperty = property;
    self.inspectionRooms = rooms;
}
@end

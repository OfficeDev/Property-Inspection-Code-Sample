//
//  EKNInSpectionData.m
//  EdKeyNote
//
//  Created by canviz on 9/30/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNInSpectionData.h"

@implementation EKNInSpectionData

-(void)initParameter:(NSNumber* )inspectionid
     InspectionTitle:(NSString *)title
  InspectionDateTime:(NSString *)datetime
       InspectorName:(NSString *)name
   InspectorProperty:(EKNPropertyData *)property
      InspectorRooms:(EKNRoomData *)rooms
{
    self.inspectionId = inspectionid;
    self.inspectionTitle = title;
    self.inspectionDateTime = datetime;
    self.inspectorName = name;
    self.inspectionProperty = property;
    self.inspectionRooms = rooms;
}
@end

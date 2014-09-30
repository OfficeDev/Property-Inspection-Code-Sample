//
//  EKNInSpectionData.h
//  EdKeyNote
//
//  Created by canviz on 9/30/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKNRoomData.h"
#import "EKNPropertyData.h"
@interface EKNInSpectionData : NSObject

@property(nonatomic) NSNumber *inspectionId;
@property(nonatomic) NSString *inspectionTitle;
@property(nonatomic) NSString *inspectionDateTime;

@property(nonatomic) NSString *inspectorName;

@property(nonatomic) EKNPropertyData *inspectionProperty;
@property(nonatomic) EKNRoomData *inspectionRooms;


-(void)initParameter:(NSNumber* )inspectionid
               InspectionTitle:(NSString *)title
               InspectionDateTime:(NSString *)datetime
               InspectorName:(NSString *)name
               InspectorProperty:(EKNPropertyData *)property
               InspectorRooms:(EKNRoomData *)rooms;
@end

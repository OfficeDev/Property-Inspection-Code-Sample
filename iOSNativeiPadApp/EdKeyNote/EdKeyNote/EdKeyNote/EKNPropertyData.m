//
//  EKNPropertyData.m
//  EdKeyNote
//
//  Created by canviz on 9/30/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNPropertyData.h"

@implementation EKNPropertyData

-(void)initParameter:(NSNumber* )propertyid
               Title:(NSString *)title
               Owner:(NSString *)owner
             Adress1:(NSString *)adress1
             Adress2:(NSString *)adress2
                City:(NSString *)city
               State:(NSString *)state
          PostalCode:(NSString *)postalcode
            Latitude:(NSString *)latitude
           Longitude:(NSString *)longitude
{
    self.propertyId = propertyid;
    self.propertyTitle = title;
    self.propertyOwner = owner;
    self.propertyAdress1 = adress1;
    self.propertyAdress2 = adress2;
    self.propertyCity = city;
    self.propertyState = state;
    self.propertyPostalCode = postalcode;
    self.propertyLatitude = latitude;
    self.propertyLongitude = longitude;
}
@end

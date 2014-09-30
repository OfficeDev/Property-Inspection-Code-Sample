//
//  EKNPropertyData.h
//  EdKeyNote
//
//  Created by canviz on 9/30/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKNPropertyData : NSObject
@property(nonatomic) NSNumber *propertyId;
@property(nonatomic) NSString *propertyTitle;
@property(nonatomic) NSString *propertyOwner;
@property(nonatomic) NSString *propertyAdress1;
@property(nonatomic) NSString *propertyAdress2;
@property(nonatomic) NSString *propertyCity;
@property(nonatomic) NSString *propertyState;
@property(nonatomic) NSString *propertyPostalCode;

-(void)initParameter:(NSNumber* )propertyid
                    Title:(NSString *)title
                    Owner:(NSString *)owner
                    Adress1:(NSString *)adress1
                    Adress2:(NSString *)adress2
                    City:(NSString *)city
                    State:(NSString *)state
                    PostalCode:(NSString *)postalcode;
@end

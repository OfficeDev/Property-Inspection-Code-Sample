//
//  ListClient.h
//  office365-lists-sdk
//
//  Created by Gustavo on 7/22/14.
//  Copyright (c) 2014 Lagash. All rights reserved.
//
#import "NSString+NSStringExtensions.h"
@interface ListClient : NSObject

@property (nonatomic) NSString *Url;
@property (nonatomic) NSString *token;
- (id)initWithUrl:(NSString *)url token:(NSString *)token;

- (void)getListItems:(NSString *)name callback:(void (^)(NSMutableArray *listItems, NSError *error))callback;
- (void)getListItemsByFilter:(NSString *)name filter:(NSString *)filter callback:(void (^)(NSMutableArray *listItems, NSError *))callback;
- (void)getListItemFileByFilter:(NSString *)name FileId:(NSString *)fileId filter:(NSString *)filter callback:(void (^)(NSMutableArray *listItems, NSError *))callback;
- (void)uploadImageToRepairPhotos:(NSString *)token image:(UIImage *)image inspectionId:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId callback:(void (^)(NSError *error))callback;
@end

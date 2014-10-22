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

- (NSMutableArray *)parseDataArray:(NSData *)data;
- (NSData*) sanitizeJson : (NSData*) data;

- (void)createListItem:(NSString *)listName body:(NSString *)body callback:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback;

- (void)updateListItem:(NSString *)listName itemID:(NSString *)itemID body:(NSString *)body callback:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback;

-(void)getFileValueByPath:(NSString *)filePath callback:(void (^)(NSData *data,NSURLResponse *response,NSError *error))callback;

-(void)getFieldValue:(NSString *)listTitle field:(NSString *)fieldTitle propertyName:(NSString *)propertyName callback:(void (^)(NSMutableArray *listItems, NSError *error))callback;

- (void)uploadImage:(UIImage *)image libraryName:(NSString *)libraryName imageName:(NSString *)imageName
           callback:(void (^)(NSData *data,  NSURLResponse *response, NSError *error))callback;
- (void)getFileItemIDByFileName:(NSString *)libraryName imageName:(NSString *)imageName
                       callback:(void (^)(NSMutableArray *listItems, NSError *error))callback;
@end

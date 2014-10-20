//
//  ListClient.h
//  office365-lists-sdk
//
//  Created by Gustavo on 7/22/14.
//  Copyright (c) 2014 Lagash. All rights reserved.
//

#import <office365-base-sdk/BaseClient.h>

@interface ListClient : BaseClient

- (NSURLSessionDataTask *)getListItems:(NSString *)name callback:(void (^)(NSMutableArray *listItems, NSError *error))callback;
- (NSURLSessionDataTask *)getListItemsByFilter:(NSString *)name filter:(NSString *)filter callback:(void (^)(NSMutableArray *listItems, NSError *))callback;
- (NSURLSessionDataTask *)getListItemFileByFilter:(NSString *)name FileId:(NSString *)fileId filter:(NSString *)filter callback:(void (^)(NSMutableArray *listItems, NSError *))callback;

- (NSMutableArray *)parseDataArray:(NSData *)data;
- (NSData*) sanitizeJson : (NSData*) data;

- (void)createListItem:(NSString *)token listName:(NSString *)listName body:(NSString *)body callback:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback;

- (void)updateListItem:(NSString *)token listName:(NSString *)listName itemID:(NSString *)itemID body:(NSString *)body callback:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback;

-(void)getFileValueByPath:(NSString *)token ServerRelativeUrl:(NSString *)filePath callback:(void (^)(NSData *data,NSURLResponse *response,NSError *error))callback;

-(void)getFieldValue:(NSString* )token listTitle:(NSString *)listTitle field:(NSString *)fieldTitle propertyName:(NSString *)propertyName callback:(void (^)(NSMutableArray *listItems, NSError *error))callback;

- (void)uploadImage:(NSString *)token image:(UIImage *)image libraryName:(NSString *)libraryName imageName:(NSString *)imageName
           callback:(void (^)(NSData *data,  NSURLResponse *response, NSError *error))callback;
- (void)getFileItemIDByFileName:(NSString *)token libraryName:(NSString *)libraryName imageName:(NSString *)imageName
                       callback:(void (^)(NSMutableArray *listItems, NSError *error))callback;
@end

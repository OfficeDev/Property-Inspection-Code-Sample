  //
//  ListClient.m
//  office365-lists-sdk
//
//  Created by Gustavo on 7/22/14.
//  Copyright (c) 2014 Lagash. All rights reserved.
//
#import "ListClient.h"
#import "ListItem.h"
#import <office365-base-sdk/HttpConnection.h>
#import <office365-base-sdk/Constants.h>
#import <office365-base-sdk/NSString+NSStringExtensions.h>

@implementation ListClient

const NSString *apiUrl = @"/_api/lists";

- (NSURLSessionDataTask *)getListItems:(NSString *)name callback:(void (^)(NSMutableArray *listItems, NSError *))callback{
 
    NSString *url = [NSString stringWithFormat:@"%@%@/GetByTitle('%@')/Items", self.Url , apiUrl, [name urlencode]];
    HttpConnection *connection = [[HttpConnection alloc] initWithCredentials:self.Credential url:url];
    
    NSString *method = (NSString*)[[Constants alloc] init].Method_Get;
    
    return [connection execute:method callback:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray *array = [NSMutableArray array];

        NSMutableArray *listsItemsArray =[self parseDataArray: data];
        for (NSDictionary* value in listsItemsArray) {
            [array addObject: [[ListItem alloc] initWithDictionary:value]];
        }
        
        callback(array ,error);
    }];
}
- (NSURLSessionDataTask *)getListItemsByFilter:(NSString *)name filter:(NSString *)filter callback:(void (^)(NSMutableArray *listItems, NSError *))callback{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/GetByTitle('%@')/Items?%@", self.Url , apiUrl, [name urlencode],filter];
    HttpConnection *connection = [[HttpConnection alloc] initWithCredentials:self.Credential url:url];
    
    NSLog(@"URL %@",url);
    
    NSString *method = (NSString*)[[Constants alloc] init].Method_Get;
    
    return [connection execute:method callback:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response %@",response);
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *listsItemsArray =[self parseDataArray: data];
        for (NSDictionary* value in listsItemsArray) {
            [array addObject: [[ListItem alloc] initWithDictionary:value]];
        }
        callback(array ,error);
    }];
}
- (NSURLSessionDataTask *)getListItemFileByFilter:(NSString *)name FileId:(NSString *)fileId filter:(NSString *)filter callback:(void (^)(NSMutableArray *listItems, NSError *))callback{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/GetByTitle('%@')/Items(%@)/File?%@", self.Url , apiUrl, [name urlencode],fileId,filter];
    HttpConnection *connection = [[HttpConnection alloc] initWithCredentials:self.Credential url:url];
    
    NSString *method = (NSString*)[[Constants alloc] init].Method_Get;
    
    return [connection execute:method callback:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *listsItemsArray =[self parseDataArray: data];
        for (NSDictionary* value in listsItemsArray) {
            [array addObject: [[ListItem alloc] initWithDictionary:value]];
        }
        callback(array ,error);
    }];
}



/*- (BOOL)uploadImageToDocumentLibrary:(NSString *)token libraryName:(NSString *)libraryName image:(UIImage *)image
{
    BOOL success = NO;
    NSString *imageName = [self createFileName:@".jpg"];
    NSString *listName = [libraryName urlencode];
    if([self uploadImage:token image:image libraryName:listName imageName:imageName])
    {
        int itemID = [self getItemID:token libraryName:listName imageName:imageName];
        if(itemID > 0)
        {
            //update sl_inspectionID, sl_incidentID,sl_roomID
            
        }
        else
        {
            NSLog(@"Get Item ID failed.");
        }
    }
    else
    {
        NSLog(@"upload image failed.");
    }
    
    return success;
}*/
- (void)updateItemPropertiesByID:(NSString *)token listName:(NSString *)listName itemID:(NSInteger)itemID
{
    NSInteger inspectionID = 1, incidentID = 1, roomID = 1;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *siteUrl = [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"];
    listName = [@"Room Inspection Photos" urlencode];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/lists/GetByTitle('%@')/Items(83)",siteUrl,listName];
    NSString *postString = [NSString stringWithFormat:@"{'__metadata': { 'type': 'SP.Data.RoomInspectionPhotosItem' },'sl_inspectionIDId':%i,'sl_incidentIDId':%i,'sl_roomIDId':%i}",inspectionID,incidentID,roomID];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"content-type"];
    [request addValue:@"*" forHTTPHeaderField:@"IF-MATCH"];
    [request addValue:@"MERGE" forHTTPHeaderField:@"X-HTTP-Method"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"upload image property error %@,response %@,data %@",error,response,data);
            
        });
    }];
    [task resume];
}

/*
 NSMutableDictionary *metadata = [[NSMutableDictionary alloc] init];
 [metadata setValue:@"SP.List" forKey:@"type"];
 
 
 NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
 [payload setObject:metadata forKey:@"_metadata"];
 [payload setValue:@"true" forKey:@"AllowContentTypes"];
 [payload setValue:[NSNumber numberWithInteger: 104] forKey:@"BaseTemplate"];
 [payload setValue:@"true" forKey:@"ContentTypesEnabled"];
 [payload setValue:newList.description forKey:@"Description"];
 [payload setValue:newList.title forKey:@"Title"];
 
 NSArray *array = [[NSArray alloc] initWithObjects:payload, nil];
 
 NSData *myData = [NSJSONSerialization dataWithJSONObject:array
 options:NSJSONWritingPrettyPrinted
 error:nil];
 */
//NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:payload];
/*
 NSString *json = [NSJSONSerialization JSONObjectWithData:myData
 options: NSJSONReadingMutableContainers
 error:nil];
 
 myData = [NSJSONSerialization JSONObjectWithData:json
 options: NSJSONReadingMutableContainers
 error:nil];
 */
//NSData *body = [NSKeyedArchiver archivedDataWithRootObject:payload];

/*
 {
 '_metadata':{'type':SP.List},
 'AllowContentTypes': true,
 'BaseTemplate': 104,
 'ContentTypesEnabled': true,
 'Description': 'My list description',
 'Title': 'RestTest'
 }
 */

- (NSMutableArray *)parseDataArray:(NSData *)data{
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSError *error ;
    
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:[self sanitizeJson:data]
                                                               options: NSJSONReadingMutableContainers
                                                                 error:&error];
    
    NSArray *jsonArray = [[jsonResult valueForKey : @"d"] valueForKey : @"results"];
    
    if(jsonArray != nil){
        for (NSDictionary *value in jsonArray) {
            [array addObject: value];
        }
    }else{
        NSDictionary *jsonItem =[jsonResult valueForKey : @"d"];
        
        if(jsonItem != nil){
            [array addObject:jsonItem];
        }
    }
    
    return array;
}

/* HACK to avoid an error when serializing json with unsupported NSDecimal type.
 
 For more info refer to: http://stackoverflow.com/questions/18650365/valid-json-but-cocoa-error-3840-from-afnetworking-nsjsonserialization
 
 */

- (NSData*) sanitizeJson : (NSData*) data{
    NSString * dataString = [[NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"sanitizeJson:%@",dataString);
    NSString* replacedDataString = [dataString stringByReplacingOccurrencesOfString:@"E+308" withString:@"E+127"];
    
    NSData* bytes = [replacedDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    return bytes;
}
#pragma mark - Get Field Value using REST
-(void)getFieldValue:(NSString* )token listTitle:(NSString *)listTitle field:(NSString *)fieldTitle propertyName:(NSString *)propertyName callback:(void (^)(NSMutableArray *listItems, NSError *error))callback
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/GetByTitle('%@')/Fields/GetByTitle('%@')/%@", self.Url , apiUrl, [listTitle urlencode],fieldTitle,[propertyName urlencode]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      NSMutableArray *listsItemsArray =[self parseDataArray: data];
                                      callback(listsItemsArray ,error);
                                  }];
    [task resume];
    
}
#pragma mark - Update/create List Item/File using REST
- (void)updateListItem:(NSString *)token listName:(NSString *)listName itemID:(NSString *)itemID body:(NSString *)body
                callback:(void (^)(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error))callback
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/lists/GetByTitle('%@')/Items(%@)",self.Url,[listName urlencode],itemID];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"content-type"];
    [request addValue:@"*" forHTTPHeaderField:@"IF-MATCH"];
    [request addValue:@"MERGE" forHTTPHeaderField:@"X-HTTP-Method"];
    [request addValue:[NSString stringWithFormat:@"%ld",[postData length]] forHTTPHeaderField:@"content-length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}
- (void)createListItem:(NSString *)token listName:(NSString *)listName body:(NSString *)body callback:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/lists/GetByTitle('%@')/Items",self.Url,[listName urlencode]];
    NSLog(@"requestUrl %@",requestUrl);
     NSLog(@"body %@",body);
    
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"content-type"];
    [request addValue:[NSString stringWithFormat:@"%ld",[postData length]] forHTTPHeaderField:@"content-length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}
#pragma mark - get File using REST
-(void)getFileValueByPath:(NSString *)token ServerRelativeUrl:(NSString *)filePath
      callback:(void (^)(NSData *data,
                         NSURLResponse *response,
                         NSError *error))callback

{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFileByServerRelativeUrl('%@%@",self.Url,filePath,@"')/$value"];
    
    NSLog(@"getFileValueByPath requestUrl %@",requestUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", token];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}

#pragma mark -upload file using REST

- (void)uploadImage:(NSString *)token
              image:(UIImage *)image
              libraryName:(NSString *)libraryName
              imageName:(NSString *)imageName
              callback:(void (^)(NSData *data,
                              NSURLResponse *response,
                              NSError *error))callback
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFolderByServerRelativeUrl('%@')/Files/add(url='%@',overwrite=true)",self.Url,libraryName,imageName];
    NSLog(@"requestUrl %@",requestUrl);
    NSData *postData = UIImageJPEGRepresentation(image, 1);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}
- (void)getFileItemIDByFileName:(NSString *)token libraryName:(NSString *)libraryName imageName:(NSString *)imageName
                            callback:(void (^)(NSMutableArray *listItems, NSError *error))callback
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFolderByServerRelativeUrl('%@')/Files('%@')/ListItemAllFields?$select=Id",self.Url,libraryName,imageName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error)
                                  {
                                      NSMutableArray *array = [NSMutableArray array];
                                      
                                      NSMutableArray *listsItemsArray =[self parseDataArray: data];
                                      callback(listsItemsArray,error);
                                  }];
    [task resume];
}
@end
  //
//  ListClient.m
//  office365-lists-sdk
//
//  Created by Gustavo on 7/22/14.
//  Copyright (c) 2014 Lagash. All rights reserved.
//
#import "ListClient.h"
#import "ListItem.h"
@implementation ListClient

const NSString *apiUrl = @"/_api/lists";

- (id)initWithUrl:(NSString *)url token:(NSString *)token
{
    self.token = token;
    self.Url = url;
    return self;
}

- (void)getListItems:(NSString *)name callback:(void (^)(NSMutableArray *listItems, NSError *))callback{
 
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/GetByTitle('%@')/Items", self.Url , apiUrl, [name urlencode]];
   // NSLog(@"requestUrl %@",requestUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                     // NSLog(@"response %@",response);
                                      NSMutableArray *array = [NSMutableArray array];
                                      
                                      NSMutableArray *listsItemsArray =[self parseDataArray: data];
                                      for (NSDictionary* value in listsItemsArray) {
                                          [array addObject: [[ListItem alloc] initWithDictionary:value]];
                                      }
                                      
                                      callback(array ,error);
                                  }];
    [task resume];
}
- (void)getListItemsByFilter:(NSString *)name filter:(NSString *)filter callback:(void (^)(NSMutableArray *listItems, NSError *))callback{
    
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/GetByTitle('%@')/Items?%@", self.Url , apiUrl, [name urlencode],filter];
   // NSLog(@"requestUrl %@",requestUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                    //  NSLog(@"response %@",response);
                                      NSMutableArray *array = [NSMutableArray array];
                                      
                                      NSMutableArray *listsItemsArray =[self parseDataArray: data];
                                      for (NSDictionary* value in listsItemsArray) {
                                          [array addObject: [[ListItem alloc] initWithDictionary:value]];
                                      }
                                      
                                      callback(array ,error);
                                  }];
    [task resume];
}
- (void)getListItemFileByFilter:(NSString *)name FileId:(NSString *)fileId filter:(NSString *)filter callback:(void (^)(NSMutableArray *listItems, NSError *))callback{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/GetByTitle('%@')/Items(%@)/File?%@", self.Url , apiUrl, [name urlencode],fileId,filter];
   // NSLog(@"requestUrl %@",requestUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                    //  NSLog(@"response %@",response);
                                      NSMutableArray *array = [NSMutableArray array];
                                      NSMutableArray *listsItemsArray =[self parseDataArray: data];
                                      for (NSDictionary* value in listsItemsArray) {
                                          [array addObject: [[ListItem alloc] initWithDictionary:value]];
                                      }
                                      callback(array ,error);
                                  }];
    [task resume];
}
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
    //NSLog(@"sanitizeJson:%@",dataString);
    NSString* replacedDataString = [dataString stringByReplacingOccurrencesOfString:@"E+308" withString:@"E+127"];
    
    NSData* bytes = [replacedDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    return bytes;
}
#pragma mark - Get Field Value using REST
-(void)getFieldValue:(NSString *)listTitle field:(NSString *)fieldTitle propertyName:(NSString *)propertyName callback:(void (^)(NSMutableArray *listItems, NSError *error))callback
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/GetByTitle('%@')/Fields/GetByTitle('%@')/%@", self.Url , apiUrl, [listTitle urlencode],fieldTitle,[propertyName urlencode]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
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
- (void)updateListItem:(NSString *)listName itemID:(NSString *)itemID body:(NSString *)body
                callback:(void (^)(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error))callback
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/lists/GetByTitle('%@')/Items(%@)",self.Url,[listName urlencode],itemID];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"content-type"];
    [request addValue:@"*" forHTTPHeaderField:@"IF-MATCH"];
    [request addValue:@"MERGE" forHTTPHeaderField:@"X-HTTP-Method"];
    [request addValue:[NSString stringWithFormat:@"%ld",(unsigned long)[postData length]] forHTTPHeaderField:@"content-length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}
- (void)createListItem:(NSString *)listName body:(NSString *)body callback:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/lists/GetByTitle('%@')/Items",self.Url,[listName urlencode]];
   // NSLog(@"requestUrl %@",requestUrl);
     //NSLog(@"body %@",body);
    
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"content-type"];
    [request addValue:[NSString stringWithFormat:@"%ld",(unsigned long)[postData length]] forHTTPHeaderField:@"content-length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}
#pragma mark - get File using REST
-(void)getFileValueByPath:(NSString *)filePath
      callback:(void (^)(NSData *data,
                         NSURLResponse *response,
                         NSError *error))callback

{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFileByServerRelativeUrl('%@%@",self.Url,filePath,@"')/$value"];
    
    NSLog(@"getFileValueByPath requestUrl %@",requestUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.token];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}

#pragma mark -upload file using REST

- (void)uploadImage:(UIImage *)image
              libraryName:(NSString *)libraryName
              imageName:(NSString *)imageName
              callback:(void (^)(NSData *data,
                              NSURLResponse *response,
                              NSError *error))callback
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFolderByServerRelativeUrl('%@')/Files/add(url='%@',overwrite=true)",self.Url,libraryName,imageName];
    //NSLog(@"requestUrl %@",requestUrl);
    NSData *postData = UIImageJPEGRepresentation(image, 1);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}
- (void)getFileItemIDByFileName:(NSString *)libraryName imageName:(NSString *)imageName
                            callback:(void (^)(NSMutableArray *listItems, NSError *error))callback
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFolderByServerRelativeUrl('%@')/Files('%@')/ListItemAllFields?$select=Id",self.Url,libraryName,imageName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error)
                                  {
                                      NSMutableArray *listsItemsArray =[self parseDataArray: data];
                                      callback(listsItemsArray,error);
                                  }];
    [task resume];
}
@end
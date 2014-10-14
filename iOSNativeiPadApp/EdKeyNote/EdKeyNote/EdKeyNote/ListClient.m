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

- (BOOL)uploadImageToDocumentLibrary:(NSString *)token libraryName:(NSString *)libraryName image:(UIImage *)image
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
}

- (BOOL)uploadImage:(NSString *)token image:(UIImage *)image libraryName:(NSString *)libraryName imageName:(NSString *)imageName
{
    static BOOL uploadSuccess = NO;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *siteUrl = [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFolderByServerRelativeUrl('%@')/Files/add(url='%@',overwrite=true)",siteUrl,libraryName,imageName];
    NSData *postData = UIImageJPEGRepresentation(image, 1);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * dataString = [[NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data:%@, response:%@",dataString,response);
            uploadSuccess = true;
        });
    }];
    [task resume];
    
    return uploadSuccess;
}

- (NSInteger)getItemID:(NSString *)token libraryName:(NSString *)libraryName imageName:(NSString *)imageName
{
    static NSInteger id = 0;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *siteUrl = [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFolderByServerRelativeUrl('%@')/Files('%@')/ListItemAllFields",siteUrl,libraryName,imageName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * dataString = [[NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"get image property data %@ ",dataString);
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *listsItemsArray =[self parseDataArray: data];
            
        });
    }];
    [task resume];
    
    
    return id;
}

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


- (NSString *)createFileName:(NSString *)fileExtension
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyMMddHHmmssSSSSSS"];
    
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableString *randstr = [[NSMutableString alloc]init];
    for(int i = 0 ; i < 5 ; i++)
    {
        int val= arc4random()%10;
        [randstr appendString:[NSString stringWithFormat:@"%d",val]];
    }
    NSString *string = [NSString stringWithFormat:@"%@%@%@",datestr,randstr,fileExtension];
    return string;
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
    NSLog(@"dataString:%@",dataString);
    NSString* replacedDataString = [dataString stringByReplacingOccurrencesOfString:@"E+308" withString:@"E+127"];
    
    NSData* bytes = [replacedDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    return bytes;
}
@end
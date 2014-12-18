//
//  ListClient.m
//  office365-lists-sdk
//
//  Created by Gustavo on 7/22/14.
//  Copyright (c) 2014 Lagash. All rights reserved.
//

#import "ListClient.h"
#import "ListItem.h"
#import "EKNEKNGlobalInfo.h"

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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      NSMutableArray *array = [NSMutableArray array];
                                      NSMutableArray *listsItemsArray =[self parseDataArray: data];
                                      for (NSDictionary* value in listsItemsArray) {
                                          [array addObject: [[ListItem alloc] initWithDictionary:value]];
                                      }
                                      callback(array ,error);
                                  }];
    [task resume];

}

- (void)uploadImageToRepairPhotos:(NSString *)token image:(UIImage *)image inspectionId:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId callback:(void (^)(NSError *error))callback
{
    NSString *imageName = [self createFileName:@".jpg"];
    [self uploadImage:token image:image imageName:imageName inspectionId:inspectionId incidentId:incidentId roomId:roomId callback:callback];
}

- (void)uploadImage:(NSString *)token image:(UIImage *)image imageName:(NSString *)imageName inspectionId:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId callback:(void (^)(NSError *error))callback
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFolderByServerRelativeUrl('RepairPhotos')/Files/add(url='%@',overwrite=true)",self.Url,imageName];
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
            [self getItemID:token imageName:imageName inspectionId:inspectionId incidentId:incidentId roomId:roomId callback:callback];
        });
    }];
    [task resume];
}

- (void)getItemID:(NSString *)token imageName:(NSString *)imageName inspectionId:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId callback:(void (^)(NSError *error))callback
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFolderByServerRelativeUrl('RepairPhotos')/Files('%@')/ListItemAllFields",self.Url,imageName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([EKNEKNGlobalInfo requestSuccess:response])
            {
                NSMutableArray *listsItemsArray =[self parseDataArray: data];
                NSString *id= [listsItemsArray[0] valueForKey:@"Id"];
                [self updateItemPropertiesByID:token inspectionId:inspectionId incidentId:incidentId roomId:roomId photoID:id callback:callback];
            }
            else
            {
                callback(error);
            }
        });
    }];
    [task resume];
}

- (void)updateItemPropertiesByID:(NSString *)token inspectionId:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId photoID:(NSString *)photoId callback:(void (^)(NSError *error))callback
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/lists/GetByTitle('%@')/Items(%@)",self.Url,@"Repair%20Photos",photoId];
    NSString *postString = [NSString stringWithFormat:@"{'__metadata': { 'type': 'SP.Data.RepairPhotosItem' },'sl_inspectionIDId':%@,'sl_incidentIDId':%@,'sl_roomIDId':%@}",inspectionId,incidentId,roomId];
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
            if([EKNEKNGlobalInfo requestSuccess:response])
            {
                callback(nil);
            }
            else
            {
                callback(error);
            }
            
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
    //NSLog(@"dataString:%@",dataString);
    NSString* replacedDataString = [dataString stringByReplacingOccurrencesOfString:@"E+308" withString:@"E+127"];
    
    NSData* bytes = [replacedDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    return bytes;
}

@end
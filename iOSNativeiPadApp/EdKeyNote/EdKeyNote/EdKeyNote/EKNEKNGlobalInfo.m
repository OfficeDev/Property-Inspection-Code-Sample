//
//  EKNEKNGlobalInfo.m
//  EdKeyNote
//
//  Created by canviz on 9/24/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNEKNGlobalInfo.h"

@interface EKNEKNGlobalInfo ()

@end

@implementation EKNEKNGlobalInfo

+ (void)saveData:(NSString *)key content:(NSDictionary *)value {
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    [SaveDefaults setObject:value forKey:key];
}

+ (NSDictionary *)loadData:(NSString *)key {
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dir = [SaveDefaults objectForKey:key];
    return dir;
}
+(NSDate *)converDateFromString:(NSString *)stringdate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSDate *ret =[formatter dateFromString:stringdate];
    return ret;
}
@end

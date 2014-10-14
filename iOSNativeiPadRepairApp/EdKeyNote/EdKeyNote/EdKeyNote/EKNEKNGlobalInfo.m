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

+(NSDate *)converDateFromString:(NSString *)stringdate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSDate *ret =[formatter dateFromString:stringdate];
    return ret;
}
+(NSString *)converStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM'/'dd'/'yy"];
    NSString *ret =[formatter stringFromDate:date];
    return ret;
}
@end

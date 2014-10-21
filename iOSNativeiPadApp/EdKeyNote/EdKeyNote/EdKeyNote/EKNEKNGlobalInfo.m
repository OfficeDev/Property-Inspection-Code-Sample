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
+(BOOL)isEqualTodayDate:(NSString *)tempDate
{
    NSString *tempstr =[EKNEKNGlobalInfo converStringFromDate:[EKNEKNGlobalInfo converDateFromString:tempDate]];
    NSString *currentstr = [EKNEKNGlobalInfo converStringFromDate:[NSDate date]];
    if ([tempstr isEqualToString:currentstr]) {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
+(NSString *)createFileName:(NSString *)fileExtension
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
@end

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
+(NSString *)converStringToDateString:(NSString *)stringDate
{
    NSString *result = @"";
    if(![self isBlankString:stringDate])
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM'/'dd'/'yyyy"];
        NSDate *date = [self converDateFromString:stringDate];
        result = [dateFormat stringFromDate:date];
    }
    
    return result;
}

+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+(CGSize)getSizeFromStringWithFont:(NSString *)string font:(UIFont *)font
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize size = [string sizeWithAttributes:attributes];
    return size;
}

@end

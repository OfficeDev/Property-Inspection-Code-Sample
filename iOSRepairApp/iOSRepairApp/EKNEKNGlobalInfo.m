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

+(NSString *)getString:(NSString *)string
{
    NSString *result = @"";
    if(![self isBlankString:string])
    {
        return string;
    }
    return  result;
}
+(BOOL)requestSuccess:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [httpResponse statusCode];
    if(statusCode >= 200 && statusCode <= 206)
    {
        return YES;
    }
    return NO;
}
+(NSString *)getSiteUrl{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"];
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
+(void)openUrl:(NSString *)url{
    if(url !=nil){
        NSURL *desUrl = [[NSURL alloc] initWithString:url];
        if([[UIApplication sharedApplication] canOpenURL:desUrl]){
            [[UIApplication sharedApplication] openURL:desUrl];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Open Url Fialed, please check your URL" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}
@end


//
//  NSString+NSStringExtensions.m
//  iOSRepairApp
//
//  Created by Max on 10/24/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "NSString+NSStringExtensions.h"

@implementation NSString (NSStringExtensions)

- (NSString *)urlencode {
    
    NSString* exceptions =  @"!$&'()*+,;=:@";
    NSMutableString *output = [NSMutableString string];
    
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    
    long sourceLen = strlen((const char *)source);
    
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        NSRange range = [exceptions rangeOfString:[[NSString alloc] initWithFormat:@"%c",thisChar]];
        if (thisChar == ' '){
            [output appendString:@"%20"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9') ||
                   (range.length > 0)) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end

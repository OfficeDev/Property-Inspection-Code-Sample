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
@end

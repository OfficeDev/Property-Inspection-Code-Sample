//
//  EKNEKNGlobalInfo.h
//  EdKeyNote
//
//  Created by canviz on 9/24/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKNEKNGlobalInfo : UIViewController

+(NSDate *)converDateFromString:(NSString *)stringdate;
+(NSString *)converUTCStringFromDate:(NSDate *)date;
+(NSString *)converLocalStringFromDate:(NSDate *)date;
+(NSString *)createFileName:(NSString *)fileExtension;
+(id)getObjectFromDefault:(NSString *)key;
@end

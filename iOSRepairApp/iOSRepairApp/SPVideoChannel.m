//
//  MSChannel.c
//  
//
//  Created by Tyler Lu on 9/9/15.
//
//

#include "SPVideoChannel.h"

@implementation SPVideoChannel

@synthesize Id = _id;
@synthesize Title = _title;

- (instancetype)init {
    
    if (self = [super init]) {
        _id = @"";
        _title = @"";
    }
    
    return self;
}

- (void)setId:(NSString *) id {
    _id = id;
    [self valueChanged:id forProperty:@"Id"];
}

- (void)setTitle:(NSString *) title {
    _title = title;
    [self valueChanged:title forProperty:@"Title"];
}

@end
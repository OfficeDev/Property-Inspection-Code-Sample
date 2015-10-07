//
//  MSGraphConversation.m
//  
//
//  Created by Tyler Lu on 9/11/15.
//
//

#include "MSGraphConversation.h"

@implementation MSGraphConversation

@synthesize odataType = _odataType;
@synthesize Id = _id;
@synthesize Topic = _topic;
@synthesize Preview = _preview;

- (instancetype)init {
    if (self = [super init]) {
        _odataType = @"#Microsoft.Graph.MSGraphConversation";
    }
    return self;
}

- (void)setTopic:(NSString *) topic {
    _topic = topic;
    [self valueChanged:topic forProperty:@"Topic"];
}

- (void)setId:(NSString *) id {
    _id = id;
    [self valueChanged:id forProperty:@"Id"];
}

- (void)setPreview:(NSString *) preview {
    _preview = preview;
    [self valueChanged:preview forProperty:@"Preview"];
}

@end
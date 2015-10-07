//
//  SPVideoItem.m
//  
//
//  Created by Tyler Lu on 9/9/15.
//
//

#import "SPVideoItem.h"

@implementation SPVideoItem

@synthesize odataType = _odataType;
@synthesize ID = _iD;
@synthesize Title = _title;
@synthesize FileName = _fileName;
@synthesize Description = _description;
@synthesize ThumbnailUrl = _thumbnailUrl;
@synthesize YammerObjectUrl = _yammerObjectUrl;

- (instancetype)init {
    
    if (self = [super init]) {
        _odataType = @"#SP.Publishing.VideoItem";
        _iD = @"";
        _title = @"";
        _fileName = @"";
        _description = @"";
        _thumbnailUrl = @"";
        _yammerObjectUrl = @"";
    }
    
    return self;
}

- (void)setID:(NSString *) id {
    _iD = id;
    [self valueChanged:id forProperty:@"ID"];
}

- (void)setTitle:(NSString *) title {
    _title = title;
    [self valueChanged:title forProperty:@"Title"];
}

- (void)setFileName:(NSString *) fileName {
    _fileName = fileName;
    [self valueChanged:fileName forProperty:@"FileName"];
}

- (void)setDescription:(NSString *) description {
    _description = description;
    [self valueChanged:description forProperty:@"Description"];
}


- (void)setThumbnailUrl:(NSString *) thumbnailUrl {
    _thumbnailUrl = thumbnailUrl;
    [self valueChanged:thumbnailUrl forProperty:@"ThumbnailUrl"];
}

- (void)setYammerObjectUrl:(NSString *) yammerObjectUrl {
    _yammerObjectUrl = yammerObjectUrl;
    [self valueChanged:yammerObjectUrl forProperty:@"YammerObjectUrl"];
}

@end
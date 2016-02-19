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
    [self valueChangedFor:@"ID"];
}

- (void)setTitle:(NSString *) title {
    _title = title;
    [self valueChangedFor:@"Title"];
}

- (void)setFileName:(NSString *) fileName {
    _fileName = fileName;
    [self valueChangedFor:@"FileName"];
}

- (void)setDescription:(NSString *) description {
    _description = description;
    [self valueChangedFor:@"Description"];
}


- (void)setThumbnailUrl:(NSString *) thumbnailUrl {
    _thumbnailUrl = thumbnailUrl;
    [self valueChangedFor:@"ThumbnailUrl"];
}

- (void)setYammerObjectUrl:(NSString *) yammerObjectUrl {
    _yammerObjectUrl = yammerObjectUrl;
    [self valueChangedFor:@"YammerObjectUrl"];
}

- (instancetype) initWithDictionary: (NSDictionary *) dic {
    if((self = [self init])) {
        if(dic!=nil) {
            _iD = (![dic objectForKey: @"ID"] || [ [dic objectForKey: @"ID"] isKindOfClass:[NSNull class]] )?_iD:[[dic objectForKey: @"ID"] copy];
            _title = (![dic objectForKey: @"Title"] || [ [dic objectForKey: @"Title"] isKindOfClass:[NSNull class]])?_title:[[dic objectForKey: @"Title"] copy];
            _fileName = (![dic objectForKey: @"FileName"] || [ [dic objectForKey: @"FileName"] isKindOfClass:[NSNull class]] )?_fileName:[[dic objectForKey: @"FileName"] copy];
            _description = (![dic objectForKey: @"Description"] || [ [dic objectForKey: @"Description"] isKindOfClass:[NSNull class]] )?_description:[[dic objectForKey: @"Description"] copy];
            _thumbnailUrl = (![dic objectForKey: @"ThumbnailUrl"] || [ [dic objectForKey: @"ThumbnailUrl"] isKindOfClass:[NSNull class]] )?_thumbnailUrl:[[dic objectForKey: @"ThumbnailUrl"] copy];
            
            _yammerObjectUrl = (![dic objectForKey: @"YammerObjectUrl"] || [ [dic objectForKey: @"YammerObjectUrl"] isKindOfClass:[NSNull class]] )?_yammerObjectUrl:[[dic objectForKey: @"YammerObjectUrl"] copy];
        }
        [self.updatedValues removeAllObjects];
    }
    
    return self;
}

- (NSDictionary *) toDictionary {
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];

    {id curVal = [self.ID copy];if (curVal!=nil) [dic setValue: curVal forKey: @"ID"];}
    {id curVal = [self.Title copy];if (curVal!=nil) [dic setValue: curVal forKey: @"Title"];}
    {id curVal = [self.FileName copy];if (curVal!=nil) [dic setValue: curVal forKey: @"FileName"];}
    {id curVal = [self.Description copy];if (curVal!=nil) [dic setValue: curVal forKey: @"Description"];}
    {id curVal = [self.ThumbnailUrl copy];if (curVal!=nil) [dic setValue: curVal forKey: @"ThumbnailUrl"];}
    {id curVal = [self.YammerObjectUrl copy];if (curVal!=nil) [dic setValue: curVal forKey: @"YammerObjectUrl"];}
    [dic setValue: @"#SP.Publishing.VideoItem" forKey: @"@odata.type"];
    
    return dic;
}

- (NSDictionary *) toUpdatedValuesDictionary {
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
    {id curVal = self.ID;
        if([self.updatedValues containsObject:@"ID"])
        {
            [dic setValue: curVal==nil?[NSNull null]:[curVal copy] forKey: @"ID"];
        }
    }
    {id curVal = self.Title;
        if([self.updatedValues containsObject:@"Title"])
        {
            [dic setValue: curVal==nil?[NSNull null]:[curVal copy] forKey: @"Title"];
        }
    }
    {id curVal = self.FileName;
        if([self.updatedValues containsObject:@"FileName"])
        {
            [dic setValue: curVal==nil?[NSNull null]:[curVal copy] forKey: @"FileName"];
        }
    }
    {id curVal = self.Description;
        if([self.updatedValues containsObject:@"Description"])
        {
            [dic setValue: curVal==nil?[NSNull null]:[curVal copy] forKey: @"Description"];
        }
    }
    {id curVal = self.ThumbnailUrl;
        if([self.updatedValues containsObject:@"ThumbnailUrl"])
        {
            [dic setValue: curVal==nil?[NSNull null]:[curVal copy] forKey: @"ThumbnailUrl"];
        }
    }
    {id curVal = self.YammerObjectUrl;
        if([self.updatedValues containsObject:@"YammerObjectUrl"])
        {
            [dic setValue: curVal==nil?[NSNull null]:[curVal copy] forKey: @"YammerObjectUrl"];
        }
    }
    return dic;
}


@end
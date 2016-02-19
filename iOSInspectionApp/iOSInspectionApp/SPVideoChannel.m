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
    [self valueChangedFor:@"Id"];
}

- (void)setTitle:(NSString *) title {
    _title = title;
    [self valueChangedFor:@"Title"];
  //  [self valueChanged:title forProperty:@"Title"];
}


- (instancetype) initWithDictionary: (NSDictionary *) dic {
    if((self = [self init])) {
        if(dic!=nil) {
            _id = (![dic objectForKey: @"Id"] || [ [dic objectForKey: @"Id"] isKindOfClass:[NSNull class]] )?_id:[[dic objectForKey: @"Id"] copy];
            _title = (![dic objectForKey: @"Title"] || [ [dic objectForKey: @"Title"] isKindOfClass:[NSNull class]] )?_title:[[dic objectForKey: @"Title"] copy];
        }
        [self.updatedValues removeAllObjects];
    }
    
    return self;
}

- (NSDictionary *) toDictionary {
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    

    {id curVal = [self.Id copy];if (curVal!=nil) [dic setValue: curVal forKey: @"Id"];}
    {id curVal = [self.Title copy];if (curVal!=nil) [dic setValue: curVal forKey: @"Title"];}
    [dic setValue: @"#SP.Publishing.VideoChannel" forKey: @"@odata.type"];
    
    return dic;
}

- (NSDictionary *) toUpdatedValuesDictionary {
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
   {id curVal = self.Id;
        if([self.updatedValues containsObject:@"Id"])
        {
            [dic setValue: curVal==nil?[NSNull null]:[curVal copy] forKey: @"Id"];
        }
    }
    {id curVal = self.Title;
        if([self.updatedValues containsObject:@"Title"])
        {
            [dic setValue: curVal==nil?[NSNull null]:[curVal copy] forKey: @"Title"];
        }
    }
   return dic;
}

@end
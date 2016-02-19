//
//  SPVideoItem.h
//  
//
//  Created by Tyler Lu on 9/9/15.
//
//

#import <core/core.h>


@interface SPVideoItem : MSOrcBaseEntity<MSOrcInteroperableWithDictionary>

@property (copy, nonatomic, readwrite, getter=ID, setter=setID:) NSString *ID;
@property (copy, nonatomic, readwrite, getter=Title, setter=setTitle:) NSString *Title;
@property (copy, nonatomic, readwrite, getter=FileName, setter=setFileName:) NSString *FileName;
@property (copy, nonatomic, readwrite, getter=Description, setter=setDescription:) NSString *Description;
@property (copy, nonatomic, readwrite, getter=ThumbnailUrl, setter=setThumbnailUrl:) NSString *ThumbnailUrl;
@property (copy, nonatomic, readwrite, getter=YammerObjectUrl, setter=setYammerObjectUrl:) NSString *YammerObjectUrl;

@end
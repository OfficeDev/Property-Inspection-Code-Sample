//
//  MSGraphConversation.h
//  
//
//  Created by Tyler Lu on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import "MSGraphItem.h"

/**
 * The header for type Message.
 */

@interface MSGraphConversation : MSGraphItem

@property (copy, nonatomic, readwrite, getter=Id, setter=setId:) NSString *Id;
@property (copy, nonatomic, readwrite, getter=topic, setter=setTopic:) NSString *Topic;
@property (copy, nonatomic, readwrite, getter=preview, setter=setPreview:) NSString *Preview;


@end
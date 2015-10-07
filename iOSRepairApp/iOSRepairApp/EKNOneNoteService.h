//
//  EKNOneNoteService.h
//  
//
//  Created by Tyler Lu on 9/1/15.
//
//

#import "orc.h"
#import <Foundation/Foundation.h>
#import <unified_services/unified_services.h>
#import <onenote_services/onenote_services.h>

@interface EKNOneNoteService : NSObject

-(void)getPagesWithCallBack: (MSGraphGroup *)group propertyName:(NSString*) propertyName incidentId:(int)incidentId callback:(void (^)(NSString * notBookUrl, NSArray *pages, MSOrcError *error))callback;

@end
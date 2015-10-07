//
//  IncidentListItemCell.m
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "PropertyMembersCell.h"
#import "EKNGraphService.h"
@implementation PropertyMembersCell
- (void)awakeFromNib {
    // Initialization code
}
-(void)setCellValue:(NSString *)groupId memberid:(NSString*)memberid name:(NSString *)name{
    self.personName.text = name;
    EKNGraphService *service = [[EKNGraphService alloc] init];
    
    [service getPersonImage:groupId memberid:memberid callback:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.personPicture setImage:image];
        });
    }];
}
@end

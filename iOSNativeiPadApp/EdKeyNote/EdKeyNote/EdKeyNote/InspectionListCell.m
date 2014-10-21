//
//  InspectionListCell.m
//  EdKeyNote
//
//  Created by canviz on 10/11/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "InspectionListCell.h"

@implementation InspectionListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellValue:(NSString *)dateTime owner:(NSString *)owner incident:(NSString *)incident plus:(BOOL)bplus final:(BOOL)final
{
    
    self.dateTime.text = dateTime;
    self.owner.text = owner;
    self.bfinalized = final;
    if(incident!=nil)
    {
        [self.incidentImage setImage:[UIImage imageNamed:incident]];
    }
    if(bplus)
    {
        [self.plusImage setImage:[UIImage imageNamed:@"plus"]];
    }
}
@end

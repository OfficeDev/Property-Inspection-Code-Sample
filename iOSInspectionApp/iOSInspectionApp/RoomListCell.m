//
//  RoomListCell.m
//  EdKeyNote
//
//  Created by canviz on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "RoomListCell.h"

@implementation RoomListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValue:(NSString*)roomImageName title:(NSString *)title
{
    
    self.roomLabel.text = title;
    if(roomImageName!=nil)
    {
        [self.roomImageView setImage:[UIImage imageNamed:roomImageName]];
    }
}
-(NSString *)getLabelTitle
{
    return self.roomLabel.text;
}
@end

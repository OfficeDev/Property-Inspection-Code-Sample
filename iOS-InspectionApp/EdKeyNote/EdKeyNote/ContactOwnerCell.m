//
//  ContactOwnerCell.m
//  EdKeyNote
//
//  Created by canviz on 10/11/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "ContactOwnerCell.h"

@implementation ContactOwnerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellValue:(NSString *)email
{
    self.emailLable.text = email;
}

@end

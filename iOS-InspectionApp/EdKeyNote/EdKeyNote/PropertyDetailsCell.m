//
//  EKNPropertyDetailsCellTableViewCell.m
//  EdKeyNote
//
//  Created by canviz on 10/10/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "PropertyDetailsCell.h"

@implementation PropertyDetailsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellValue:(UIImage *)image title:(NSString *)title
{
    [self.propertyImage setImage:image];
    self.propertyTitle.text = title;
    
}

@end

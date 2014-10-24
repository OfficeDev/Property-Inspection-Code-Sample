//
//  EKNPropertyDetailsImage.m
//  EdKeyNote
//
//  Created by canviz on 10/11/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "PropertyDetailsImage.h"

@implementation PropertyDetailsImage

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellValue:(UIImage *)image title:(NSString *)title
{
    self.addressTitle.text = title;
    [self.addressImage setImage:image];
}


@end

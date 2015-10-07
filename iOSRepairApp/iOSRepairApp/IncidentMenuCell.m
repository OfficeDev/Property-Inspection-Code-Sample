//
//  ContactOwnerCell.m
//  EdKeyNote
//
//  Created by canviz on 10/11/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "IncidentMenuCell.h"

@implementation IncidentMenuCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellValue:(NSString *)unSelectIconName selectIconName:(NSString *)selectIconName menuTitle:(NSString *)menuTitle
{
    //[self.menuImageView setImage:[UIImage imageNamed:iconName]];
    self.unselectMenuIcon = unSelectIconName;
    self.selectMenuIcon = selectIconName;
    self.menuLabel.text = menuTitle;
    [self setBackgroundColor:[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1]];
    [self.menuImageView setImage:[UIImage imageNamed:self.unselectMenuIcon]];
    
}
-(void)setCellSatus:(BOOL)select{
    if(select){
        [self.menuImageView setImage:[UIImage imageNamed:self.selectMenuIcon]];
        self.menuLabel.textColor = [UIColor blackColor];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [self.menuImageView setImage:[UIImage imageNamed:self.unselectMenuIcon]];
        self.menuLabel.textColor = [UIColor colorWithRed:0.00f/255.00f green:130.00f/255.00f blue:114.00f/255.00f alpha:1];
        [self setBackgroundColor:[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1]];
    }
}
@end

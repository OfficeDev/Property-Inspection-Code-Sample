//
//  ContactOwnerCell.h
//  EdKeyNote
//
//  Created by canviz on 10/11/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncidentMenuCell : UITableViewCell
@property (nonatomic) NSString *unselectMenuIcon;
@property (nonatomic) NSString *selectMenuIcon;
@property (nonatomic) NSString *menuTitle;
@property (nonatomic) NSString *menuColor;
@property (strong, nonatomic) IBOutlet UILabel *menuLabel;
@property (strong, nonatomic) IBOutlet UIImageView *menuImageView;
-(void)setCellValue:(NSString *)unSelectIconName selectIconName:(NSString *)selectIconName menuTitle:(NSString *)menuTitle;
-(void)setCellSatus:(BOOL)select;
@end

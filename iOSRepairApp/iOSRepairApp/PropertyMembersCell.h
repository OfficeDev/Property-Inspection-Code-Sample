//
//  IncidentListItemCell.h
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyMembersCell :UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *personPicture;
@property (strong, nonatomic) IBOutlet UILabel *personName;

-(void)setCellValue:(NSString *)groupId memberid:(NSString*)memberid name:(NSString *)name;

@end

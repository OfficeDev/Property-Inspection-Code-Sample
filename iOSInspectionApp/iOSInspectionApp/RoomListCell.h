//
//  RoomListCell.h
//  EdKeyNote
//
//  Created by canviz on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *roomImageView;
@property (strong, nonatomic) IBOutlet UILabel *roomLabel;
-(void)setCellValue:(NSString*)roomImageName title:(NSString *)title;
-(NSString *)getLabelTitle;
@end

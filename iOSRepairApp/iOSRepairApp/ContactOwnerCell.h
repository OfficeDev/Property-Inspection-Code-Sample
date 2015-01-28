//
//  ContactOwnerCell.h
//  EdKeyNote
//
//  Created by canviz on 10/11/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactOwnerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *emailLable;
-(void)setCellValue:(NSString *)email;
@end

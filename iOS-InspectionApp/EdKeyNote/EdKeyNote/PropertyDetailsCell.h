//
//  EKNPropertyDetailsCellTableViewCell.h
//  EdKeyNote
//
//  Created by canviz on 10/10/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyDetailsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *propertyImage;
@property (strong, nonatomic) IBOutlet UILabel *propertyTitle;
-(void)setCellValue:(UIImage *)image title:(NSString *)title;
@end

//
//  EKNPropertyDetailsImage.h
//  EdKeyNote
//
//  Created by canviz on 10/11/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyDetailsImage : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *addressImage;
@property (strong, nonatomic) IBOutlet UILabel *addressTitle;
-(void)setCellValue:(UIImage *)image title:(NSString *)title;
@end

//
//  HotelListCell.h
//  MyHotel
//
//  Created by zhou huajian on 11-6-7.
//  Copyright 2011年 itotemstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKNListItem.h"
@interface PropertyListCell : UITableViewCell {
}
@property (strong, nonatomic) IBOutlet UIImageView *hotelImage;
@property (strong, nonatomic) IBOutlet UILabel *hotelAdress;
-(void)setCellValue:(UIImage *)image address:(NSString *)address;

//-(void)getFiles:(UIImageView *)imageview path:(NSString *)path;
@end

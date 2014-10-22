//
//  InspectionListCell.h
//  EdKeyNote
//
//  Created by canviz on 10/11/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionListCell : UITableViewCell
@property (nonatomic) BOOL bfinalized;
@property (strong, nonatomic) IBOutlet UILabel *dateTime;
@property (strong, nonatomic) IBOutlet UILabel *owner;
@property (strong, nonatomic) IBOutlet UIImageView *incidentImage;
@property (strong, nonatomic) IBOutlet UIImageView *plusImage;
-(void)setCellValue:(NSString *)dateTime owner:(NSString *)owner incident:(NSString *)incident plus:(BOOL)bplus final:(BOOL)final;
-(void)changeFinalValue:(BOOL)final;
@end

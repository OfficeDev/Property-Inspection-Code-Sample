//
//  IncidentListItemCell.h
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncidentListItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *roomLbl;
@property (strong, nonatomic) IBOutlet UILabel *incidentLbl;
@property (strong, nonatomic) IBOutlet UILabel *inspectionLbl;
@property (strong, nonatomic) IBOutlet UILabel *repairDateTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *repairDateValueLbl;
@property (strong, nonatomic) IBOutlet UILabel *approvalTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *approvalValueLbl;

-(void)setCellValue:(UIImage *)image room:(NSString *)room incident:(NSString *)incident inspectionDate:(NSString *)inspectionDate repairDate:(NSString *)repairDate approved:(NSString *)approved;

@end

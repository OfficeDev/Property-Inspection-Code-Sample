//
//  IncidentListItemCell.h
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKNEKNGlobalInfo.h"
@interface PropertyFileCell :UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bkview;
@property (strong, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;

@property (strong, nonatomic) IBOutlet UILabel *lastModifyLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *clientActionImageView;
@property (strong, nonatomic) IBOutlet UILabel *actionTitle;

@property (nonatomic) NSString *webUrl;
@property(nonatomic) NSString *clientUrl;
-(void)setCellValue:(NSString *)fileName author:(NSString*)author lastmodified:(NSDate *)lastmodified filesize:(NSString *)filesize weburl:(NSString *)weburl clientUrl:(NSString *)clientUrl;
@end

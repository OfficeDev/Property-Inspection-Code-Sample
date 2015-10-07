//
//  IncidentListItemCell.h
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneNoteCell :UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *oneNoteTitleLabel;
@property(nonatomic) NSString *webUrl;
@property(nonatomic) NSString *clientUrl;
@property (strong, nonatomic) IBOutlet UIView *bkView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UIImageView *openInClient;

-(void)setCellValue:(NSString *)title webURl:(NSString *)weburl clientUrl:(NSString *)clientUrl;
@end

//
//  IncidentListItemCell.h
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationCell :UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *previewLabel;
@property(nonatomic) NSString *webUrl;

-(void)setCellValue:(NSString *)title preview:(NSString *)preview webURl:(NSString *)weburl;

@end

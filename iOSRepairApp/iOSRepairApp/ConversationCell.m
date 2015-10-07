//
//  IncidentListItemCell.m
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "ConversationCell.h"

@implementation ConversationCell
- (void)awakeFromNib {
    // Initialization code
}
-(void)setCellValue:(NSString *)title preview:(NSString *)preview webURl:(NSString *)weburl{
    self.titleLabel.text = title;
    self.previewLabel.text = preview;
    self.webUrl = weburl;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(highlighted){
        [self setBackgroundColor:[UIColor colorWithRed:0.00f/255.00f green:130.00f/255.00f blue:114.00f/255.00f alpha:1]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.previewLabel setTextColor:[UIColor whiteColor]];
    }
    else{
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.titleLabel setTextColor:[UIColor colorWithRed:0.00f/255.00f green:130.00f/255.00f blue:114.00f/255.00f alpha:1]];
        [self.previewLabel setTextColor:[UIColor colorWithRed:0.00f/255.00f green:130.00f/255.00f blue:114.00f/255.00f alpha:1]];
    }
}
@end

//
//  IncidentListItemCell.m
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "OneNoteCell.h"
#import "EKNEKNGlobalInfo.h"

@implementation OneNoteCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclickAction)];
    [self.openInClient addGestureRecognizer:singleTap];
}
-(void)onclickAction{
    //client on client
     [EKNEKNGlobalInfo openUrl:self.clientUrl];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellValue:(NSString *)title webURl:(NSString *)weburl clientUrl:(NSString *)clientUrl{
    self.oneNoteTitleLabel.text = title;
    self.webUrl = weburl;
    self.clientUrl = clientUrl;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(highlighted){
        [self.bkView setBackgroundColor:[UIColor colorWithRed:0.00f/255.00f green:130.00f/255.00f blue:114.00f/255.00f alpha:1]];
        [self.iconImage setImage:[UIImage imageNamed:@"oneNoteListSelect"]];
        [self.oneNoteTitleLabel setTextColor:[UIColor whiteColor]];
    }
    else{
        [self.bkView setBackgroundColor:[UIColor whiteColor]];
        [self.iconImage setImage:[UIImage imageNamed:@"oneNoteList"]];
        [self.oneNoteTitleLabel setTextColor:[UIColor colorWithRed:0.00f/255.00f green:130.00f/255.00f blue:114.00f/255.00f alpha:1]];
    }
}
@end

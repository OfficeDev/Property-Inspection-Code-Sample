//
//  IncidentListItemCell.m
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "PropertyFileCell.h"

@implementation PropertyFileCell

- (void)awakeFromNib {
    // Initialization code

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclickAction)];
    [self.clientActionImageView addGestureRecognizer:singleTap];
}
-(void)onclickAction{
    if(self.clientUrl == nil){
        [EKNEKNGlobalInfo openUrl:self.webUrl];
    }
    else{
        //client on client
        [EKNEKNGlobalInfo openUrl:self.clientUrl];
    }

}
-(void)setCellValue:(NSString *)fileName author:(NSString*)author lastmodified:(NSDate *)lastmodified filesize:(NSString *)filesize weburl:(NSString *)weburl clientUrl:(NSString *)clientUrl{
    
    self.fileNameLabel.text = fileName;
    self.authorLabel.text = author;
    self.lastModifyLabel.text = [NSString stringWithFormat:@"Last Modified: %@",[EKNEKNGlobalInfo converStringFromDate:lastmodified]];
    self.sizeLabel.text = [NSString stringWithFormat:@"Size: %@",[NSByteCountFormatter stringFromByteCount:[filesize longLongValue] countStyle:NSByteCountFormatterCountStyleFile]];
    
    if([fileName.lowercaseString hasSuffix:@".docx"]){
        [self.clientActionImageView setImage:[UIImage imageNamed:@"ico_word"]];
        self.actionTitle.text = @"Open in Word";
    }
    else if([fileName.lowercaseString hasSuffix:@".xlsx"]){
        [self.clientActionImageView setImage:[UIImage imageNamed:@"ico_excel"]];
        self.actionTitle.text = @"Open in Excel";
    }
    else if([fileName.lowercaseString hasSuffix:@".pptx"]){
        [self.clientActionImageView setImage:[UIImage imageNamed:@"ico_powerpoint"]];
        self.actionTitle.text = @"Open in PowerPoint";
    }
    self.webUrl = weburl;
    self.clientUrl = clientUrl;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    UIColor *greenColor = [UIColor colorWithRed:0.00f/255.00f green:130.00f/255.00f blue:114.00f/255.00f alpha:1];
    UIColor *whiteColor = [UIColor whiteColor];
    if(highlighted){
        [self.bkview setBackgroundColor:greenColor];
        [self.fileNameLabel setTextColor:whiteColor];
        [self.authorLabel setTextColor:whiteColor];
        [self.lastModifyLabel setTextColor:whiteColor];
        [self.sizeLabel setTextColor:whiteColor];
    }
    else{
        [self.bkview setBackgroundColor:whiteColor];
        [self.fileNameLabel setTextColor:greenColor];
        [self.authorLabel setTextColor:greenColor];
        [self.lastModifyLabel setTextColor:greenColor];
        [self.sizeLabel setTextColor:greenColor];
    }
}
@end

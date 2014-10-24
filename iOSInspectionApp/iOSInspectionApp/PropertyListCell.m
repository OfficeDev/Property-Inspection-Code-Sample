//
//  HotelListCell.m
//  MyHotel
//
//  Created by zhou huajian on 11-6-7.
//  Copyright 2011年 itotemstudio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PropertyListCell.h"


@implementation PropertyListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    //
    
    self.hotelAdress.textColor = [UIColor colorWithRed:81.00f/255.00f green:81.00f/255.00f blue:81.00f/255.00f alpha:1];
}

/*- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/
-(void)setCellValue:(UIImage *)image address:(NSString *)address;
{
    self.hotelAdress.text = address;
    [self.hotelImage setImage:image];
}

/*-(void)getFiles:(UIImageView *)imageview path:(NSString *)path
{
     NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *siteUrl = [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFileByServerRelativeUrl('%@%@",siteUrl,path,@"')/$value"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.token];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    
    //Create NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        //Turn off spinner
        dispatch_async(dispatch_get_main_queue(), ^{
            //Handle error
            if (error == nil) {
                NSLog(@"data length %lu",[data length]);
                UIImage* image = [[UIImage alloc] initWithData:data];
                [imageview setImage:image];
            }
        });
    }];
    [task resume];
    
}*/
@end

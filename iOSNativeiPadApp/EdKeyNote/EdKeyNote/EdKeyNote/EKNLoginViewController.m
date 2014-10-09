//
//  EKNLoginViewController.m
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNLoginViewController.h"
#import "EKNPropertyDetailsViewController.h"

@interface EKNLoginViewController ()

@end

@implementation EKNLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)propertyDetailsButtonAction
{
    EKNPropertyDetailsViewController *propertydetailsctrl = [[EKNPropertyDetailsViewController alloc] init];
    [self.navigationController pushViewController:propertydetailsctrl animated:YES];
}

- (void)loginButtonAction
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    //Check to see if the clientId setting exists
    if (nil != [standardUserDefaults objectForKey:@"clientId"])
    {
        self.clientId = [standardUserDefaults objectForKey:@"clientId"];    }
    else
    {
        NSString *errorMessage = [@"App initialization failed. Reason: " stringByAppendingString: @"clientID not set. Please update settings for the application."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
        [alert show];
        [standardUserDefaults setValue:@"e632f423-b906-4d5c-b32d-a6e635f1e685" forKey:@"clientId"];
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the authority setting exists
    if (nil != [standardUserDefaults objectForKey:@"authority"])
    {
        self.authority = [standardUserDefaults objectForKey:@"authority"];    }
    else
    {
        NSString *errorMessage = [@"App initialization failed. Reason: " stringByAppendingString: @"authority not set. Please update settings for the application."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
        [alert show];
        [standardUserDefaults setValue:@"https://login.windows-ppe.net/common" forKey:@"authority"];
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the resourceId setting exists
    if (nil != [standardUserDefaults objectForKey:@"resourceId"])
    {
        self.resourceId = [standardUserDefaults objectForKey:@"resourceId"];    }
    else
    {
        NSString *errorMessage = [@"App initialization failed. Reason: " stringByAppendingString: @"resourceId not set. Please update settings for the application."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
        [alert show];
        [standardUserDefaults setValue:@"https://techedairlift04.spoppe.com" forKey:@"resourceId"];
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the redirectUriString setting exists
    if (nil != [standardUserDefaults objectForKey:@"redirectUriString"])
    {
        self.redirectUriString = [standardUserDefaults objectForKey:@"redirectUriString"];    }
    else
    {
        NSString *errorMessage = [@"App initialization failed. Reason: " stringByAppendingString: @"redirectUriString not set. Please update settings for the application."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
        [alert show];
        [standardUserDefaults setValue:@"http://iOSiPadApp" forKey:@"redirectUriString"];
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the demoSiteCollectionUrl setting exists
        if (nil != [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"])
        {
            self.redirectUriString = [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"];    }
        else
        {
            NSString *errorMessage = [@"App initialization failed. Reason: " stringByAppendingString: @"demoSiteCollectionUrl not set. Please update settings for the application."];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
            [alert show];
            [standardUserDefaults setValue:@"https://techedairlift04.spoppe.com/sites/SuiteLevelAppDemo" forKey:@"demoSiteCollectionUrl"];
            [standardUserDefaults synchronize];
        }
    
    
    [self performLogin:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Login";
    self.navigationController.navigationBar.hidden = YES;
    UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusbar.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(130.00/255.00f) blue:(114.00/255.00f) alpha:1.0];
    [self.view addSubview:statusbar];
    
    UIImageView *header_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 1024, 71)];
    header_img.image = [UIImage imageNamed:@"navigation_background"];
    [self.view addSubview:header_img];
    
    UIImageView *setting_img = [[UIImageView alloc] initWithFrame:CGRectMake(978, 40, 31, 31)];
    setting_img.image = [UIImage imageNamed:@"setting"];
    [self.view addSubview:setting_img];
    
    UILabel *sign_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 241, 1024, 40)];
    sign_lbl.text = @"Sign in to access inspection and property information";
    sign_lbl.textColor = [UIColor blackColor];
    sign_lbl.textAlignment = NSTextAlignmentCenter;
    sign_lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    [self.view addSubview:sign_lbl];
    
    UIButton *login_bt = [[UIButton alloc] initWithFrame:CGRectMake(247, 441, 530, 110)];
    login_bt.layer.masksToBounds = YES;
    login_bt.layer.cornerRadius = 8;
    login_bt.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
    login_bt.titleLabel.textAlignment = NSTextAlignmentCenter;
    login_bt.titleLabel.textColor = [UIColor whiteColor];
    login_bt.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(130.00/255.00f) blue:(114.00/255.00f) alpha:1.0];
    [login_bt setTitle:@"Sign In" forState:UIControlStateNormal];
    
    [login_bt addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login_bt];
    
    UIButton *property_details_bt = [[UIButton alloc] initWithFrame:CGRectMake(200, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height+10, 150, 40)];
    [property_details_bt setTitle:@"Property Details" forState:UIControlStateNormal];
    [property_details_bt setBackgroundColor:[UIColor redColor]];
    [property_details_bt addTarget:self action:@selector(propertyDetailsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *footer_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 732, 1024, 36)];
    footer_lbl.backgroundColor = [UIColor colorWithRed:(81.00/255.00f) green:(81.00/255.00f) blue:(81.00/255.00f) alpha:1.0];
    [self.view addSubview:footer_lbl];
    //[self.view addSubview:property_details_bt];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) performLogin: (BOOL) clearCache{
    
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(480,440,50,50)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:spinner];
    spinner.hidesWhenStopped = YES;
    
    [spinner startAnimating];
    
    LoginClient *client = [[LoginClient alloc] initWithParameters:self.clientId
                                                                 :self.redirectUriString
                                                                 :self.resourceId
                                                                 :self.authority];
    
    [client login:clearCache completionHandler:^(NSString *t, NSError *e) {
        if(e == nil)
        {
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            self.token = t;
            EKNPropertyDetailsViewController *propertydetailsctrl = [[EKNPropertyDetailsViewController alloc] init];
            propertydetailsctrl.token = self.token;
            [self.navigationController pushViewController:propertydetailsctrl animated:YES];
        }
        else
        {
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            NSString *errorMessage = [@"Login failed. Reason: " stringByAppendingString: e.description];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
            [alert show];
        }
    }];
}


@end

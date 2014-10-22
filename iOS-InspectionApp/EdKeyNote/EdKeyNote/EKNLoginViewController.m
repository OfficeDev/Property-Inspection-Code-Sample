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
- (void)loginButtonAction
{
    //EKNRoomDetailsViewController *propertydetailsctrl = [[EKNRoomDetailsViewController alloc] init];
    //[self.navigationController pushViewController:propertydetailsctrl animated:YES];
    //return;
    [self performLogin:NO];
}

-(void)ShowAlert:(NSString *)title :(NSString *)text
{
    NSString *errorMessage = text;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
    [alert show];
}

-(void)checkParameters
{
    NSInteger settingsMissing = 0;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    //Check to see if the clientId setting exists
    if (nil != [standardUserDefaults objectForKey:@"clientId"])
    {
        self.clientId = [standardUserDefaults objectForKey:@"clientId"];
    }
    else
    {
        settingsMissing = 1;
        self.clientId = @"e632f423-b906-4d5c-b32d-a6e635f1e685";
        [standardUserDefaults setValue:self.clientId  forKey:@"clientId"];
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the authority setting exists
    if (nil != [standardUserDefaults objectForKey:@"authority"])
    {
        self.authority = [standardUserDefaults objectForKey:@"authority"];
    }
    else
    {
        settingsMissing = 1;
        self.authority =@"https://login.windows-ppe.net/common";
        [standardUserDefaults setValue:self.authority forKey:@"authority"];
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the resourceId setting exists
    if (nil != [standardUserDefaults objectForKey:@"resourceId"])
    {
        self.resourceId = [standardUserDefaults objectForKey:@"resourceId"];
    }
    else
    {
        settingsMissing = 1;
        self.resourceId = @"https://techedairlift04.spoppe.com";
        [standardUserDefaults setValue:self.resourceId forKey:@"resourceId"];
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the redirectUriString setting exists
    if (nil != [standardUserDefaults objectForKey:@"redirectUriString"])
    {
        self.redirectUriString = [standardUserDefaults objectForKey:@"redirectUriString"];
    }
    else
    {
        settingsMissing = 1;
        self.redirectUriString = @"http://iOSiPadApp" ;
        [standardUserDefaults setValue:self.redirectUriString forKey:@"redirectUriString"];
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the demoSiteCollectionUrl setting exists
    if (nil == [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"])
    {
        settingsMissing = 1;
        [standardUserDefaults setValue:@"https://techedairlift04.spoppe.com/sites/SuiteLevelAppDemo" forKey:@"demoSiteCollectionUrl"];
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the dispatcherEmail setting exists
    if (nil == [standardUserDefaults objectForKey:@"dispatcherEmail"])
    {
        settingsMissing = 1;
        [standardUserDefaults setValue:@"lisaa@techedairlift04.ccsctp.net" forKey:@"dispatcherEmail"];
        [standardUserDefaults synchronize];
    }
    
    if (settingsMissing == 0)
    {
        [_login_bt setTitle:@"Sign In" forState:UIControlStateNormal];
        [_login_bt setEnabled:YES];
        [_settings_lbl setText:@""];        
    }
    else
    {
        [_login_bt setTitle:@"Sign In Disabled" forState:UIControlStateNormal];
        [_login_bt setEnabled:NO];
        [_settings_lbl setText:@"Configure application settings then restart the App to enable Sign In."];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
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
    
    _login_bt = [[UIButton alloc] initWithFrame:CGRectMake(247, 441, 530, 110)];
    _login_bt.layer.masksToBounds = YES;
    _login_bt.layer.cornerRadius = 8;
    _login_bt.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
    _login_bt.titleLabel.textAlignment = NSTextAlignmentCenter;
    _login_bt.titleLabel.textColor = [UIColor whiteColor];
    _login_bt.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(130.00/255.00f) blue:(114.00/255.00f) alpha:1.0];
    [_login_bt setTitle:@"Sign In" forState:UIControlStateNormal];
    
    [_login_bt addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_login_bt];
    
    _settings_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 600, 1024, 40)];
    _settings_lbl.text = @"Configure application settings to enable Sign In.";
    _settings_lbl.textColor = [UIColor redColor];
    _settings_lbl.textAlignment = NSTextAlignmentCenter;
    _settings_lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    [self.view addSubview:_settings_lbl];
    
    UILabel *footer_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 732, 1024, 36)];
    footer_lbl.backgroundColor = [UIColor colorWithRed:(81.00/255.00f) green:(81.00/255.00f) blue:(81.00/255.00f) alpha:1.0];
    [self.view addSubview:footer_lbl];
    
    // Do any additional setup after loading the view.
    [self checkParameters];
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
    [spinner setColor:[UIColor blackColor]];
    [self.view addSubview:spinner];
    spinner.hidesWhenStopped = YES;
    
    [spinner startAnimating];
    
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:self.authority error:&error];
    if (!context)
    {
        //here need
        return;
    }
    
    [context acquireTokenWithResource:self.resourceId
                             clientId:self.clientId
                          redirectUri:[NSURL URLWithString:self.redirectUriString]
                      completionBlock:^(ADAuthenticationResult *result) {
                          [spinner stopAnimating];
                          [spinner removeFromSuperview];
                          
                          if (result.status != AD_SUCCEEDED)
                          {
                              NSString *errorMessage = [@"Login failed. Reason: " stringByAppendingString: result.error.errorDetails];
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
                              [alert show];
                              
                              return;
                          }
                          else
                          {
                              NSString *token = result.accessToken;
                              EKNPropertyDetailsViewController *propertydetailsctrl = [[EKNPropertyDetailsViewController alloc] init];
                              [propertydetailsctrl setDataExternal:self.propertyId loginName:@"Rob Barker" token:token];
                              
                              [self.navigationController pushViewController:propertydetailsctrl animated:YES];
                          }
                      }];
    
}
//infact we can get the user id from the tokenCacheStoreItem
- (void)getUsers:(ADTokenCacheStoreItem* )cach
{
    ///
}
@end

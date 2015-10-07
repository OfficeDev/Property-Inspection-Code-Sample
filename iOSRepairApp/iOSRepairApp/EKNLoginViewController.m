//
//  EKNLoginViewController.m
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNLoginViewController.h"
#import "EKNIncidentViewController.h"
#import "EKNGraphService.h"

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

-(id)init{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"bundle %@",[NSBundle mainBundle]);
    self.clientId = [standardUserDefaults objectForKey:@"clientId"];
    self.authority = [standardUserDefaults objectForKey:@"authority"];
    self.demoSiteServiceResourceId = [standardUserDefaults objectForKey:@"demoSiteServiceResourceId"];
    self.redirectUriString = [standardUserDefaults objectForKey:@"redirectUriString"];

    return self;
}

- (void)propertyDetailsButtonAction
{
    EKNIncidentViewController *incident = [[EKNIncidentViewController alloc] init];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.navigationController pushViewController:incident animated:YES];
                   }
                   );
}

- (void)loginButtonAction
{
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
        self.clientId = @"YOUR CLIENT ID";
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
        self.authority = @"https://login.microsoftonline.com/common";
        
        [standardUserDefaults setValue:self.authority forKey:@"authority"];
        [standardUserDefaults synchronize];
    }

    //Check to see if the demoSiteServiceResourceId setting exists
    if (nil != [standardUserDefaults objectForKey:@"demoSiteServiceResourceId"])
    {
        self.demoSiteServiceResourceId = [standardUserDefaults objectForKey:@"demoSiteServiceResourceId"];
    }
    else
    {
        settingsMissing = 1;
        self.demoSiteServiceResourceId = @"https://TENANCY.sharepoint.com";
        [standardUserDefaults setValue:self.demoSiteServiceResourceId forKey:@"demoSiteServiceResourceId"];
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
        self.redirectUriString = @"http://PropertyManagementiOSiPadApp";
        
        [standardUserDefaults setValue:self.redirectUriString forKey:@"redirectUriString"];
        [standardUserDefaults synchronize];
    }

    //Check to see if the demoSiteCollectionUrl setting exists
    if (nil == [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"])
    {
        settingsMissing = 1;
        [standardUserDefaults setValue:@"https://TENANCY.sharepoint.com/sites/SuiteLevelAppDemo" forKey:@"demoSiteCollectionUrl"];
		[standardUserDefaults synchronize];
    }

    //Check to see if the dispatcherEmail setting exists
    if (nil == [standardUserDefaults objectForKey:@"dispatcherEmail"])
    {
        settingsMissing = 1;
        [standardUserDefaults setValue:@"katiej@TENANCY.onmicrosoft.com" forKey:@"dispatcherEmail"];
		        
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the graphResourceId setting exists
    if (nil == [standardUserDefaults objectForKey:@"graphResourceId"])
    {
        settingsMissing = 1;
        [standardUserDefaults setValue:@"https://graph.microsoft.com/" forKey:@"graphResourceId"];	
        
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the graphResourceId setting exists
    if (nil == [standardUserDefaults objectForKey:@"graphResourceUrl"])
    {
        settingsMissing = 1;
		[standardUserDefaults setValue:@"https://graph.microsoft.com/beta/" forKey:@"graphResourceUrl"];		
		
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the oneNoteResourceId setting exists
    if (nil == [standardUserDefaults objectForKey:@"oneNoteResourceId"])
    {
        settingsMissing = 1;
        [standardUserDefaults setValue:@"https://onenote.com/" forKey:@"oneNoteResourceId"];
        
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the oneNoteResourceUrl setting exists
    if (nil == [standardUserDefaults objectForKey:@"oneNoteResourceUrl"])
    {
        settingsMissing = 1;
        [standardUserDefaults setValue:@"https://www.onenote.com/api/beta/" forKey:@"oneNoteResourceUrl"];
        
        [standardUserDefaults synchronize];
    }
    if (nil == [standardUserDefaults objectForKey:@"outlookResourceId"])
    {
        settingsMissing = 1;
        [standardUserDefaults setValue:@"https://outlook.office365.com/" forKey:@"outlookResourceId"];
        
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the videoPortalEndpointUri setting exists
    if (nil == [standardUserDefaults objectForKey:@"videoPortalEndpointUri"])
    {
        settingsMissing = 1;
        [standardUserDefaults setValue:@"https://TENANCY.sharepoint.com/portals/hub" forKey:@"videoPortalEndpointUri"];
        
        [standardUserDefaults synchronize];
    }
    
    //Check to see if the videoPortalIncidentsChannelName setting exists
    if (nil == [standardUserDefaults objectForKey:@"videoPortalIncidentsChannelName"])
    {
        settingsMissing = 1;
        [standardUserDefaults setValue:@"Incidents" forKey:@"videoPortalIncidentsChannelName"];
        
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
    sign_lbl.text = @"Sign in to access repair orders";
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

    UIButton *property_details_bt = [[UIButton alloc] initWithFrame:CGRectMake(200, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height+10, 150, 40)];
    [property_details_bt setTitle:@"Property Details" forState:UIControlStateNormal];
    [property_details_bt setBackgroundColor:[UIColor redColor]];
    [property_details_bt addTarget:self action:@selector(propertyDetailsButtonAction) forControlEvents:UIControlEventTouchUpInside];

    UILabel *footer_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 732, 1024, 36)];
    footer_lbl.backgroundColor = [UIColor colorWithRed:(81.00/255.00f) green:(81.00/255.00f) blue:(81.00/255.00f) alpha:1.0];
    [self.view addSubview:footer_lbl];
    [self checkParameters];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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
        return;
    }

    [context acquireTokenWithResource:self.demoSiteServiceResourceId clientId:self.clientId redirectUri:[NSURL URLWithString:self.redirectUriString] completionBlock:^(ADAuthenticationResult *result) {

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
            self.token = result.accessToken;
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:result.tokenCacheStoreItem.userInformation.userId forKey:@"LogInUser"];
            [userDefaults synchronize];
            
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
            [context acquireTokenWithResource:graphResourceId clientId:self.clientId redirectUri:[NSURL URLWithString:self.redirectUriString] completionBlock:^(ADAuthenticationResult *result) {
                
                EKNIncidentViewController *incidentViewController = [[EKNIncidentViewController alloc] init];
                incidentViewController.token = self.token;
                incidentViewController.incidentId = self.incidentId;
                dispatch_async(dispatch_get_main_queue(), ^{ [self.navigationController pushViewController:incidentViewController animated:YES];});
            }];
        }
    }];
}

-(void)showError : (NSString*)errorDetails{
    NSString *errorMessage = [@"Login failed. Reason: " stringByAppendingString: errorDetails];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
    [alert show];
}

-(void) setStatus: (NSString *) status
{
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

@end

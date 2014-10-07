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

NSString *clientId;
NSString *redirectUriString;
NSString *authority;
NSString *resourceId;

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
        clientId = [standardUserDefaults objectForKey:@"clientId"];    }
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
        authority = [standardUserDefaults objectForKey:@"authority"];    }
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
        resourceId = [standardUserDefaults objectForKey:@"resourceId"];    }
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
        redirectUriString = [standardUserDefaults objectForKey:@"redirectUriString"];    }
    else
    {
        NSString *errorMessage = [@"App initialization failed. Reason: " stringByAppendingString: @"redirectUriString not set. Please update settings for the application."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
        [alert show];
        [standardUserDefaults setValue:@"http://iOSiPadApp" forKey:@"redirectUriString"];
        [standardUserDefaults synchronize];
    }
    
    [self performLogin:NO];
    
    EKNPropertyDetailsViewController *propertydetailsctrl = [[EKNPropertyDetailsViewController alloc] init];
    propertydetailsctrl.token = self.token;
    [self.navigationController pushViewController:propertydetailsctrl animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Login";
    
    UIButton *login_bt = [[UIButton alloc] initWithFrame:CGRectMake(30, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height+10, 100, 40)];
    [login_bt setTitle:@"Login" forState:UIControlStateNormal];
    [login_bt setBackgroundColor:[UIColor redColor]];
    [login_bt addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login_bt];
    
    UIButton *property_details_bt = [[UIButton alloc] initWithFrame:CGRectMake(200, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height+10, 150, 40)];
    [property_details_bt setTitle:@"Property Details" forState:UIControlStateNormal];
    [property_details_bt setBackgroundColor:[UIColor redColor]];
    [property_details_bt addTarget:self action:@selector(propertyDetailsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:property_details_bt];
    
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
    self.authority = authority;
    self.resourceId = resourceId;
    self.clientId = clientId;
    self.redirectUriString = redirectUriString;
    
    LoginClient *client = [[LoginClient alloc] initWithParameters:self.clientId
                                                                 :self.redirectUriString
                                                                 :self.resourceId
                                                                 :self.authority];
    
    [client login:clearCache completionHandler:^(NSString *t, NSError *e) {
        if(e == nil)
        {
            self.token = t;
        }
        else
        {
            NSString *errorMessage = [@"Login failed. Reason: " stringByAppendingString: e.description];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
            [alert show];
        }
    }];
}


@end

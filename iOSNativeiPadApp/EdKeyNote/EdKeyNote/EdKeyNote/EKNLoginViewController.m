//
//  EKNLoginViewController.m
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNLoginViewController.h"
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
        [standardUserDefaults setValue:@"41492250-4c4f-4cf2-9c59-baac51ba67ca" forKey:@"clientId"];
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
        [standardUserDefaults setValue:@"https://techedairlift04-admin.spoppe.com" forKey:@"resourceId"];
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
        [standardUserDefaults setValue:@"/8220c7c1-fa64-452f-87e5-7550c4825312.axd" forKey:@"redirectUriString"];
        [standardUserDefaults synchronize];
    }
    
    [self performLogin:NO];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
    
    //self.authority = @"https://login.windows-ppe.net/common";
    //self.resourceId = @"https://techedairlift04-admin.spoppe.com";
    //self.clientId = @"41492250-4c4f-4cf2-9c59-baac51ba67ca";
    //self.redirectUriString = @"/8220c7c1-fa64-452f-87e5-7550c4825312.axd";
    //@"https://lagash.com/oauth";
    
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

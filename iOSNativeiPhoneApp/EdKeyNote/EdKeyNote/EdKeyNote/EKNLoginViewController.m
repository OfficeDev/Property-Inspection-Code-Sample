//
//  EKNLoginViewController.m
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNLoginViewController.h"
#import "EKNIncidentViewController.h"

@interface EKNLoginViewController ()

@end

static int imageCounter = 0, navHieght = 0;

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
    //[self performLogin:NO];
    
    EKNIncidentViewController *incident = [[EKNIncidentViewController alloc] init];
    [self.navigationController pushViewController:incident animated:YES];
}

- (void)takePhoto
{
    UIActionSheet *sheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet = [[UIActionSheet alloc]
                 initWithTitle:nil
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"Take Photo", @"Select Photo", nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc]
                 initWithTitle:nil
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"Select Photo", nil];
    }
    sheet.actionSheetStyle = UIActionSheetStyleDefault;
    [sheet showInView:self.view];
}

- (void)openCamera
{
    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

-(void)selectPicture
{
    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0)
    {
        //NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error accessing media"
                              message:@"Device doesn't support that media source."
                              delegate:nil
                              cancelButtonTitle:@"Drat"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return final;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //UIImage *shrunkenImage = [self shrinkImage:chosenImage toSize:chosenImage.size];
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 340 + navHieght + (imageCounter * 50), 40 , 40)];
    imgview.image = chosenImage;
    [self.view addSubview:imgview];
    imageCounter++;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//take new photo
    {
        [self openCamera];
    }else if(buttonIndex == 1)//select photo
    {
        [self selectPicture];
    }
}

- (BOOL)textFieldDoneEditing:(id)sender
{
    NSLog(@"Run text field return");
    [sender resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (view == self.view || view == self.parentViewController.view) {
        [self.nameTxt resignFirstResponder];
        [self.pwdTxt resignFirstResponder];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //set title
    self.title = @"Login";
    
    int navigationHeight = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    navHieght = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? navigationHeight : 0;
    
    //set logo
    UIImageView *logo_imgview = [[UIImageView alloc] initWithFrame:CGRectMake(100, navHieght + 20, 120, 40)];
    logo_imgview.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:logo_imgview];
    
    //set username label and text
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, navHieght + 80, 100, 32)];
    [nameLab setText:@"Username:"];
    [nameLab setTextColor:[UIColor blueColor]];
    [self.view addSubview:nameLab];
    
    self.nameTxt = [[UITextField alloc] initWithFrame:CGRectMake(120, navHieght + 80, 180, 32)];
    self.nameTxt.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTxt.placeholder = @"Enter username";
    self.nameTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTxt.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.nameTxt.returnKeyType = UIReturnKeyDone;
    self.nameTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.nameTxt];
    
    //set password label and text
    UILabel *pwdLab = [[UILabel alloc] initWithFrame:CGRectMake(20, navHieght + 140, 100, 32)];
    [pwdLab setText:@"Password:"];
    [pwdLab setTextColor:[UIColor blueColor]];
    [self.view addSubview:pwdLab];
    
    self.pwdTxt = [[UITextField alloc] initWithFrame:CGRectMake(120, navHieght + 140, 180, 32)];
    self.pwdTxt.secureTextEntry = true;
    self.pwdTxt.borderStyle = UITextBorderStyleRoundedRect;
    self.pwdTxt.placeholder = @"Enter password";
    self.pwdTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    self.pwdTxt.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.pwdTxt.returnKeyType = UIReturnKeyDone;
    self.pwdTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.pwdTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.pwdTxt];
    
    //set login button
    UIButton *login_bt = [[UIButton alloc] initWithFrame:CGRectMake(100, navHieght + 220, 120, 40)];
    [login_bt setTitle:@"Login" forState:UIControlStateNormal];
    [login_bt setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:login_bt];
    
    //set take photo button
    UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(80, navHieght + 280, 160, 40)];
    [photo setTitle:@"Take Photo" forState:UIControlStateNormal];
    [photo setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:photo];
    
    
    //bind event
    [self.nameTxt addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.pwdTxt addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [login_bt addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [photo addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    self.authority = @"https://login.windows.net/common";
    self.resourceId = @"https://lagashsystems365.sharepoint.com";//@"https://lagashsystems365-my.sharepoint.com/";
    self.clientId = @"778a099e-ed6e-49a2-9f15-92c01366ad7d";//@"a31be332-2598-42e6-97f1-d8ac87370367";
    self.redirectUriString = @"https://lagash.com/oauth";
    

    
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

//
//  EKNIncidentDetailViewController.m
//  EdKeyNote
//
//  Created by Canviz on 9/28/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNIncidentDetailViewController.h"

@interface EKNIncidentDetailViewController ()

@end

static int imageCounter = 0, navHieght = 0;

@implementation EKNIncidentDetailViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Incident Details Test";
    
    int navigationHeight = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    int navHieght = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? navigationHeight : 0;
    int tempRowCounter = 0;
    
    NSLog(@"Navigation height is %d",navHieght);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0 + (tempRowCounter * 30) + 10, 140, 30)];
    [nameLab setText:@"Property Name:"];
    [nameLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:nameLab];
    UILabel *nameValueLab = [[UILabel alloc] initWithFrame:CGRectMake(150, (tempRowCounter * 30) + 10, 120, 30)];
    [nameValueLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:nameValueLab];
    tempRowCounter++;
    
    UILabel *ownerLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 10, 140, 30)];
    [ownerLab setText:@"Property Owner:"];
    [ownerLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:ownerLab];
    UILabel *ownerValueLab = [[UILabel alloc] initWithFrame:CGRectMake(140, (tempRowCounter * 30) + 10, 160, 30)];
    [ownerValueLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:ownerValueLab];
    tempRowCounter++;
    
    UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 10, 160, 30)];
    [addressLab setText:@"Property Address:"];
    [addressLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:addressLab];
    UILabel *addressValueLab = [[UILabel alloc] initWithFrame:CGRectMake(140, (tempRowCounter * 30) + 10, 160, 30)];
    [addressValueLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:addressValueLab];
    tempRowCounter++;
    
    UILabel *inameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 20, 140, 30)];
    [inameLab setText:@"Inspector Name:"];
    [inameLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:inameLab];
    UILabel *inameValueLab = [[UILabel alloc] initWithFrame:CGRectMake(140, (tempRowCounter * 30) + 20, 160, 30)];
    [inameValueLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:inameValueLab];
    tempRowCounter++;
    
    UILabel *iemailLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 20, 140, 30)];
    [iemailLab setText:@"Inspector Email:"];
    [iemailLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:iemailLab];
    UILabel *iemailValueLab = [[UILabel alloc] initWithFrame:CGRectMake(140, (tempRowCounter * 30) + 20, 160, 30)];
    [iemailValueLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:iemailValueLab];
    tempRowCounter++;
    
    UILabel *idateLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 20, 140, 30)];
    [idateLab setText:@"Inspector Date:"];
    [idateLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:idateLab];
    UILabel *idateValueLab = [[UILabel alloc] initWithFrame:CGRectMake(140, (tempRowCounter * 30) + 20, 160, 30)];
    [idateValueLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:idateValueLab];
    tempRowCounter++;
    
    UILabel *typeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 30, 120, 30)];
    [typeLab setText:@"Incident Type:"];
    [typeLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:typeLab];
    UILabel *typeValueLab = [[UILabel alloc] initWithFrame:CGRectMake(140, (tempRowCounter * 30) + 30, 160, 30)];
    [typeValueLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:typeValueLab];
    tempRowCounter++;
    
    UILabel *roomNameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 30, 120, 30)];
    [roomNameLab setText:@"Room Name:"];
    [roomNameLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:roomNameLab];
    UILabel *roomNameValueLab = [[UILabel alloc] initWithFrame:CGRectMake(140, (tempRowCounter * 30) + 30, 160, 30)];
    [roomNameValueLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:roomNameValueLab];
    tempRowCounter++;
    
    UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 40, 280, 80)];
    [commentLab setTextColor:[UIColor blueColor]];
    commentLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    commentLab.layer.borderWidth = 1;
    [self.scrollView addSubview:commentLab];
    
    UILabel *dispatcherCommentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 130, 280, 80)];
    [dispatcherCommentLab setTextColor:[UIColor blueColor]];
    dispatcherCommentLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    dispatcherCommentLab.layer.borderWidth = 1;
    [self.scrollView addSubview:dispatcherCommentLab];
    
    UILabel *exitPhotoLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 220, 220, 30)];
    [exitPhotoLab setText:@"Inspection Photos"];
    [exitPhotoLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:exitPhotoLab];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(120, (tempRowCounter * 30) + 230, 80, 80)];
    imgView1.image = [UIImage imageNamed:@"logo.png"];
    [self.scrollView addSubview:imgView1];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(120, (tempRowCounter * 30) + 330, 80, 80)];
    imgView2.image = [UIImage imageNamed:@"logo.png"];
    [self.scrollView addSubview:imgView2];
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(120, (tempRowCounter * 30) + 430, 80, 80)];
    imgView3.image = [UIImage imageNamed:@"logo.png"];
    [self.scrollView addSubview:imgView3];

    UILabel *repairPhotoLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 530, 200, 30)];
    [repairPhotoLab setText:@"Repair Photos"];
    [repairPhotoLab setTextColor:[UIColor blueColor]];
    [self.scrollView addSubview:repairPhotoLab];
    
    UIImageView *imgView21 = [[UIImageView alloc] initWithFrame:CGRectMake(120, (tempRowCounter * 30) + 570, 80, 80)];
    imgView21.image = [UIImage imageNamed:@"logo.png"];
    [self.scrollView addSubview:imgView21];
    
    UIImageView *imgView22 = [[UIImageView alloc] initWithFrame:CGRectMake(120, (tempRowCounter * 30) + 670, 80, 80)];
    imgView22.image = [UIImage imageNamed:@"logo.png"];
    [self.scrollView addSubview:imgView22];
    
    UIImageView *imgView23 = [[UIImageView alloc] initWithFrame:CGRectMake(120, (tempRowCounter * 30) + 770, 80, 80)];
    imgView23.image = [UIImage imageNamed:@"logo.png"];
    [self.scrollView addSubview:imgView23];
    
    UILabel *repairCommentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 870, 280, 80)];
    [repairCommentLab setTextColor:[UIColor blueColor]];
    repairCommentLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    repairCommentLab.layer.borderWidth = 1;
    [self.scrollView addSubview:repairCommentLab];
    
    UIButton *takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 570, 120, 40)];
    [takePhotoButton setTitle:@"Take Photo" forState:UIControlStateNormal];
    [takePhotoButton setBackgroundColor:[UIColor blueColor]];
    [self.scrollView addSubview:takePhotoButton];

    UIButton *savePhoto = [[UIButton alloc] initWithFrame:CGRectMake(20, (tempRowCounter * 30) + 970, 100, 40)];
    [savePhoto setTitle:@"Save" forState:UIControlStateNormal];
    [savePhoto setBackgroundColor:[UIColor blueColor]];
    [self.scrollView addSubview:savePhoto];
    
    UIButton *repairCompletePhoto = [[UIButton alloc] initWithFrame:CGRectMake(140, (tempRowCounter * 30) + 970, 160, 40)];
    [repairCompletePhoto setTitle:@"Repair Complete" forState:UIControlStateNormal];
    [repairCompletePhoto setBackgroundColor:[UIColor blueColor]];
    [self.scrollView addSubview:repairCompletePhoto];
    
    [takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    self.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, 1300);
    [self.view addSubview:self.scrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

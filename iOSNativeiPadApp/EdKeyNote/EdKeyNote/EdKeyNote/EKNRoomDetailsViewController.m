//
//  EKNRoomDetailsViewController.m
//  EdKeyNote
//
//  Created by Max on 10/9/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNRoomDetailsViewController.h"

@interface EKNRoomDetailsViewController ()

@end

@implementation EKNRoomDetailsViewController

-(void)initRoomsValue:(NSDictionary *)insDic propertyId:(NSString *)pid inspetionId:(NSInteger)insId token:(NSString *)tkn
{
    self.inspectionsDic = insDic;
    self.propertyId = pid;
    self.selectInspetionIndex =insId;
    self.token = tkn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cameraIsAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    self.isShowingComment = NO;
    self.isShowingIncident = NO;
    self.selectedImageIndex = 0;
    
    UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusbar.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(130.00/255.00f) blue:(114.00/255.00f) alpha:1.0];
    [self.view addSubview:statusbar];
    
    self.view.backgroundColor=[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1];
    
    UIImageView *header_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 1024, 71)];
    header_img.image = [UIImage imageNamed:@"navigation_background"];
    [self.view addSubview:header_img];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 91, 344, 768)];
    leftView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftView];
    
    UIImageView *seperatorline = [[UIImageView alloc] initWithFrame:CGRectMake(344, 91, 5, 677)];
    seperatorline.image = [UIImage imageNamed:@"sepratorline"];
    [self.view addSubview:seperatorline];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 350, 15, 71)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"before"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [self initLeftView];
    
    [self initRightView];
    
    [self loadData];
    /*UIButton *showIncidentCommentPopupBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 180, 250, 40)];
    [showIncidentCommentPopupBtn setTitle:@"Show Incident Comment" forState:UIControlStateNormal];
    [showIncidentCommentPopupBtn setBackgroundColor:[UIColor redColor]];
    [showIncidentCommentPopupBtn addTarget:self action:@selector(showIncidentCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showIncidentCommentPopupBtn];
    
    UIButton *showCommentPopupBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 250, 250, 40)];
    [showCommentPopupBtn setTitle:@"Show Comment" forState:UIControlStateNormal];
    [showCommentPopupBtn setBackgroundColor:[UIColor redColor]];
    [showCommentPopupBtn addTarget:self action:@selector(showCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showCommentPopupBtn];
    
    [self initRightView];
    [self initIncidentCommentPopupView];
    [self initCommentPopupView];
    [self initPhotoDetailPopupView];*/
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *temp = [NSIndexPath indexPathForRow:self.selectInspetionIndex inSection:0];
    [self.inspectionLeftTableView selectRowAtIndexPath:temp animated:NO scrollPosition:UITableViewScrollPositionTop];
}
-(void)loadData{
    
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.spinner];
    self.spinner.hidesWhenStopped = YES;
    
    [self.spinner startAnimating];
    
    
    NSInteger inspectionId = [[[[self.inspectionsDic objectForKey:@"inspectionslist"]
                                objectAtIndex:self.selectInspetionIndex]
                               objectForKey:@"ID"] integerValue];
    
    OAuthentication* authentication = [OAuthentication alloc];
    [authentication setToken:self.token];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    ListClient* client = [[ListClient alloc] initWithUrl:[standardUserDefaults objectForKey:@"demoSiteCollectionUrl"] credentials: authentication];
    NSURLSessionTask* task = [client getListItemsByFilter:@"Room Inspection Photos" filter:[NSString stringWithFormat:@"$select=Id,sl_inspectionIDId,sl_roomIDId&$filter=sl_inspectionIDId%@",[[NSString stringWithFormat:@" eq '%d'",(int)inspectionId] urlencode]] callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"listItems %ld",[listItems count]);
            [self.spinner stopAnimating];
        });
        
    }];
    
    [task resume];
    
}

-(void)initLeftView{

    [self addSegementControl];
    [self addInspectionsTable];
}

-(void)addSegementControl
{
    UIImageView * bkimg =[[UIImageView alloc] initWithFrame:CGRectMake(24, 96, 316, 54)];
    [bkimg setImage:[UIImage imageNamed:@"seg"]];
    [self.view addSubview:bkimg];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(24, 96, 105, 54)];
    [left addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left];
    
    UIButton *mid = [UIButton buttonWithType:UIButtonTypeCustom];
    [mid setFrame:CGRectMake(129, 96, 105, 54)];
    [mid addTarget:self action:@selector(midButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mid];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(234, 96, 106, 54)];
    [right addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
    
    
    UIImageView * bkimg1 =[[UIImageView alloc] initWithFrame:CGRectMake(24, 405, 316, 54)];
    [bkimg1 setImage:[UIImage imageNamed:@"seg2"]];
    [self.view addSubview:bkimg1];
    
    UIButton *left1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [left1 setFrame:CGRectMake(24, 405, 105, 54)];
    [left1 addTarget:self action:@selector(roomLeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left1];
    
    UIButton *mid1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [mid1 setFrame:CGRectMake(129, 405, 105, 54)];
    [mid1 addTarget:self action:@selector(roomMidButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mid1];
    
    UIButton *right1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [right1 setFrame:CGRectMake(234, 405, 106, 54)];
    [right1 addTarget:self action:@selector(roomRightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right1];
    
}
-(void)addInspectionsTable
{
    self.inspectionLeftTableView = [[UITableView alloc] initWithFrame:CGRectMake(24, 150, 320, 235) style:UITableViewStyleGrouped];
    self.inspectionLeftTableView.backgroundColor = [UIColor whiteColor];
    self.inspectionLeftTableView.delegate = self;
    self.inspectionLeftTableView.dataSource = self;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    NSString *lbl1str = @"INSPECTIONS";
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    lbl1.text = lbl1str;
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = font;
    lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.inspectionLeftTableView.tableHeaderView = lbl1;

    [self.view addSubview:self.inspectionLeftTableView];
    
    self.inspectionMidTableView = [[UITableView alloc] initWithFrame:CGRectMake(24, 150, 320, 235) style:UITableViewStyleGrouped];
    self.inspectionMidTableView.backgroundColor = [UIColor whiteColor];
    self.inspectionMidTableView.delegate = self;
    self.inspectionMidTableView.dataSource = self;
    [self.inspectionMidTableView setScrollEnabled:NO];
    
    NSString *lbl2str = @"CONTACT OFFICE";
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    lbl2.text = lbl2str;
    lbl2.textAlignment = NSTextAlignmentLeft;
    lbl2.font = font;
    lbl2.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.inspectionMidTableView.tableHeaderView = lbl2;
    [self.view addSubview:self.inspectionMidTableView];
    self.inspectionMidTableView.hidden = YES;
    
    self.inspectionRightTableView = [[UITableView alloc] initWithFrame:CGRectMake(24, 150, 320, 235) style:UITableViewStyleGrouped];
    self.inspectionRightTableView.backgroundColor = [UIColor whiteColor];
    self.inspectionRightTableView.delegate = self;
    self.inspectionRightTableView.dataSource = self;
    [self.inspectionRightTableView setScrollEnabled:NO];
    NSString *lbl3str = @"CONTACT OWNER";
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    lbl3.text = lbl3str;
    lbl3.textAlignment = NSTextAlignmentLeft;
    lbl3.font = font;
    lbl3.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.inspectionMidTableView.tableHeaderView = lbl3;
    
    [self.view addSubview:self.inspectionRightTableView];
    self.inspectionRightTableView.hidden = YES;
    
}

-(void)leftButtonClicked
{
    if(self.inspectionLeftTableView.hidden == YES)
    {
        self.inspectionLeftTableView.hidden = NO;
        self.inspectionMidTableView.hidden = YES;
        self.inspectionRightTableView.hidden = YES;
    }
}

-(void)midButtonClicked
{
    if(self.inspectionMidTableView.hidden == YES)
    {
        self.inspectionLeftTableView.hidden = YES;
        self.inspectionMidTableView.hidden = NO;
        self.inspectionRightTableView.hidden = YES;
    }
}

-(void)rightButtonClicked
{
    if(self.inspectionRightTableView.hidden == YES)
    {
        self.inspectionLeftTableView.hidden = YES;
        self.inspectionMidTableView.hidden = YES;
        self.inspectionRightTableView.hidden = NO;
    }
}

-(void)roomLeftButtonClicked
{
    
}

-(void)roomMidButtonClicked
{
    
}

-(void)roomRightButtonClicked
{
    
}

-(void)backAction
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) showIncidentCommentAction
{
    self.isShowingComment = NO;
    self.isShowingIncident = YES;
    self.commentPopupView.hidden = YES;
    self.incidentCommentPopupView.hidden = NO;
}

-(void) showCommentAction
{
    self.isShowingComment = YES;
    self.isShowingIncident = NO;
    self.incidentCommentPopupView.hidden = YES;
    self.commentPopupView.hidden = NO;
}

-(void) hideIncidentCommentAction
{
    self.isShowingIncident = NO;
    self.incidentCommentPopupView.hidden = YES;
}

-(void) hideCommentAction
{
    self.isShowingComment = NO;
    self.commentPopupView.hidden = YES;
}

-(void)hidePhotoDetailAction
{
    self.photoDetailPopupView.hidden = YES;
}

-(void) takeCommentCameraAction
{
    //[self.commentImages addObject:[UIImage imageNamed:@"demo_room"]];
    //[self.commentCollection reloadData];
    //NSLog(@"Add photo");
    [self takePhoto];
}

-(void) takeIncidentCommentCameraAction
{
    //[self.incidentCommentImages addObject:[UIImage imageNamed:@"demo_room"]];
    //[self.incidentCommentCollection reloadData];
    //NSLog(@"Add Incident photo");
    [self takePhoto];
}

- (void)takePhoto
{
    UIActionSheet *sheet;
    if(self.cameraIsAvailable)
    {
        sheet = [[UIActionSheet alloc]
                 initWithTitle:nil
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"New Photo", @"Select Photo", nil];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && self.cameraIsAvailable)//take new photo
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self openCamera];
        }];
    }
    else if(buttonIndex == 1)//select photo library
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self selectPicture];
        }];
    }
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
                              cancelButtonTitle:@"Error"
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
    UIImage *smallImage = [self shrinkImage:chosenImage toSize:CGSizeMake(105, 79)];
    UIImage *largeImage = [self shrinkImage:chosenImage toSize:CGSizeMake(210, 158)];
    
    if(self.isShowingIncident)
    {
        [self.incidentCommentImages addObject:smallImage];
        [self.largeIncidentCommentImages addObject:largeImage];
        [self.incidentCommentCollection reloadData];
    }
    else if(self.isShowingComment)
    {
        [self.commentImages addObject:smallImage];
        [self.largeCommentImages addObject:largeImage];
        [self.commentCollection reloadData];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag == 1)//right image collection view
    {
        return self.rightViewImages.count;
    }
    else if(collectionView.tag == 2)//comment image collection view
    {
        return self.commentImages.count;
    }
    else //incident image collection view
    {
        return self.incidentCommentImages.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1)
    {
        EKNCollectionViewCell *cell = (EKNCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self.selectedImageButton removeFromSuperview];
        //UIImageView *imageView = (UIImageView *)[cell viewWithTag:9999];
        UIImage *image = self.rightViewImages[indexPath.row];
        if(image != nil)
        {
            self.selectedImageButton = [[UIButton alloc] initWithFrame:CGRectMake((image.size.width - 33) / 2, 0, 33, 15)];
            [self.selectedImageButton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            [cell addSubview:self.selectedImageButton];
            NSLog(@"Selected image width:%f",image.size.width);
            //show the large photo
            self.selectedImageIndex = indexPath.row;
            self.rightLargePhotoView.image = self.largerRightViewImages[indexPath.row];
        }
    }
    else if(collectionView.tag == 2)
    {
        self.largePhotoView.image = self.largeCommentImages[indexPath.row];
        self.photoDetailPopupView.hidden = NO;
    }
    else if(collectionView.tag == 3)
    {
        self.largePhotoView.image = self.largeIncidentCommentImages[indexPath.row];
        self.photoDetailPopupView.hidden = NO;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID= @"cvCell";
    EKNCollectionViewCell *cell = (EKNCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    self.testCount ++;
    //NSLog(@"collection view items:%i",self.testCount);
    
    if(collectionView.tag == 1)
    {
        if(self.rightViewImages.count > 0)
        {
            UIImage *image = self.rightViewImages[indexPath.row];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            imageView.image = image;
            imageView.tag = 9999;
            [cell addSubview:imageView];
            
            if(indexPath.row == self.selectedImageIndex)
            {
                self.selectedImageButton = [[UIButton alloc] initWithFrame:CGRectMake((image.size.width - 33) / 2, 0, 33, 15)];
                [self.selectedImageButton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
                [cell addSubview:self.selectedImageButton];
            }
            NSLog(@"image width:%f",image.size.width);
            //cell.imagecell.image = image;
        }
    }
    else if(collectionView.tag == 2)
    {
        if(self.commentImages.count > 0)
        {
            cell.imagecell.image = self.commentImages[indexPath.row];
        }
    }
    else if(collectionView.tag == 3)
    {
        if(self.incidentCommentImages.count > 0)
        {
            cell.imagecell.image = self.incidentCommentImages[indexPath.row];
        }
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image;
    if(collectionView.tag == 1)
    {
        image = self.rightViewImages[indexPath.row];
    }
    else if(collectionView.tag == 2)
    {
        image = self.commentImages[indexPath.row];
    }
    else
    {
        image = self.incidentCommentImages[indexPath.row];
    }
    //NSLog(@"image width:%f heigth:%f",image.size.width,image.size.height);
    CGFloat width = image.size.width;
    CGFloat heigth = image.size.height;
    if(heigth > 116)
    {
        width = width / (heigth / 116);
        heigth = 116;
    }
    return CGSizeMake(width, heigth);
}

- (void) initRightView
{
    self.rightViewImages = [NSMutableArray array];
    self.largerRightViewImages = [NSMutableArray array];
    
    self.rightTopView = [[UIView alloc] initWithFrame:CGRectMake(358, 91, 646, 46)];
    self.rightTopView.backgroundColor = [UIColor colorWithRed:(123.00/255.00f) green:(123.00/255.00f) blue:(123.00/255.00f) alpha:1.00];
    [self.view addSubview:self.rightTopView];
    
    UIFont *labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.rightDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 78, 46)];
    self.rightDateLabel.text = @"01/05/11";
    self.rightDateLabel.textAlignment = NSTextAlignmentRight;
    self.rightDateLabel.font = labelFont;
    self.rightDateLabel.textColor = [UIColor whiteColor];
    [self.rightTopView addSubview:self.rightDateLabel];
    
    UILabel *specLabel = [[UILabel alloc] initWithFrame:CGRectMake(79, 0, 36, 46)];
    specLabel.text = @"|";
    specLabel.textAlignment = NSTextAlignmentCenter;
    specLabel.font = labelFont;
    specLabel.textColor = [UIColor whiteColor];
    [self.rightTopView addSubview:specLabel];
    
    self.rightAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(116, 0, 320, 46)];
    self.rightAuthorLabel.text = @"Carl Spackler";
    self.rightAuthorLabel.textAlignment = NSTextAlignmentLeft;
    self.rightAuthorLabel.font = labelFont;
    self.rightAuthorLabel.textColor = [UIColor whiteColor];
    [self.rightTopView addSubview:self.rightAuthorLabel];
    
    self.rightLargePhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(358, 91+46, 646, 465)];
    self.rightLargePhotoView.image = [UIImage imageNamed:@"demo_rightroom6"];
    [self.view addSubview:self.rightLargePhotoView];
    
    UIView *collectionBg = [[UIView alloc] initWithFrame:CGRectMake(358, 526+91, 646, 136)];
    collectionBg.backgroundColor = [UIColor colorWithRed:(225.00/255.00f) green:(225.00/255.00f) blue:(225.00/255.00f) alpha:1.00];
    [self.view addSubview:collectionBg];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //[flowLayout setItemSize:CGSizeMake(140, 79)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(358+5, 91+536, 636, 116) collectionViewLayout:flowLayout];
    rightCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    rightCollectionView.delegate = self;
    rightCollectionView.dataSource = self;
    rightCollectionView.allowsMultipleSelection = YES;
    rightCollectionView.allowsSelection = YES;
    rightCollectionView.showsHorizontalScrollIndicator = NO;
    rightCollectionView.backgroundColor = [UIColor colorWithRed:(225.00/255.00f) green:(225.00/255.00f) blue:(225.00/255.00f) alpha:0.00];
    rightCollectionView.tag = 1;
    
    [self.view addSubview:rightCollectionView];
    self.rightImageCollection = rightCollectionView;
    [self.rightImageCollection registerClass:[EKNCollectionViewCell class] forCellWithReuseIdentifier:@"cvCell"];
    self.rightImageCollection.delegate = self;
    self.rightImageCollection.dataSource =self;
    
    [self.rightViewImages addObject:[UIImage imageNamed:@"demo_rightroom1"]];
    [self.rightViewImages addObject:[UIImage imageNamed:@"demo_room2"]];
    [self.rightViewImages addObject:[UIImage imageNamed:@"demo_rightroom3"]];
    [self.rightViewImages addObject:[UIImage imageNamed:@"demo_rightroom4"]];
    [self.rightViewImages addObject:[UIImage imageNamed:@"demo_rightroom5"]];
    [self.rightViewImages addObject:[UIImage imageNamed:@"demo_rightroom1"]];
    [self.rightViewImages addObject:[UIImage imageNamed:@"demo_room2"]];
    
    [self.largerRightViewImages addObject:[UIImage imageNamed:@"demo_rightroom6"]];
    [self.largerRightViewImages addObject:[UIImage imageNamed:@"demo_room1"]];
    [self.largerRightViewImages addObject:[UIImage imageNamed:@"demo_rightroom6"]];
    [self.largerRightViewImages addObject:[UIImage imageNamed:@"demo_room1"]];
    [self.largerRightViewImages addObject:[UIImage imageNamed:@"demo_rightroom6"]];
    [self.largerRightViewImages addObject:[UIImage imageNamed:@"demo_room1"]];
    [self.largerRightViewImages addObject:[UIImage imageNamed:@"demo_rightroom6"]];
    
    [self.rightImageCollection reloadData];
}

- (void) initPhotoDetailPopupView
{
    self.photoDetailPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    self.photoDetailPopupView.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(0.00/255.00f) blue:(0.00/255.00f) alpha:0.8];
    self.largePhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(407, 305, 210, 158)];
    [self.photoDetailPopupView addSubview:self.largePhotoView];
    UIButton *closePhotoDetail = [[UIButton alloc] initWithFrame:CGRectMake(617, 255, 100, 50)];
    [closePhotoDetail setTitle:@"Close" forState:UIControlStateNormal];
    closePhotoDetail.backgroundColor = [UIColor colorWithRed:(100.00/255.00f) green:(153.00/255.00f) blue:(209.00/255.00f) alpha:1.0];
    closePhotoDetail.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    closePhotoDetail.titleLabel.textColor = [UIColor whiteColor];
    closePhotoDetail.layer.masksToBounds = YES;
    closePhotoDetail.layer.cornerRadius = 5;
    [closePhotoDetail addTarget:self action:@selector(hidePhotoDetailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.photoDetailPopupView addSubview:closePhotoDetail];
    self.photoDetailPopupView.hidden = YES;
    [self.view addSubview:self.photoDetailPopupView];
}

- (void) initIncidentCommentPopupView
{
    self.incidentCommentImages = [NSMutableArray array];
    self.largeIncidentCommentImages = [NSMutableArray array];
    
    self.incidentCommentPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 389)];
    self.incidentCommentPopupView.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(0.00/255.00f) blue:(0.00/255.00f) alpha:0.35];;
    
    self.incidentCommentCamera = [[UIButton alloc] initWithFrame:CGRectMake(32, 30, 64, 52)];
    [self.incidentCommentCamera setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [self.incidentCommentCamera addTarget:self action:@selector(takeIncidentCommentCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.incidentCommentPopupView addSubview:self.incidentCommentCamera];
    
    UIView *imgBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(106, 30, 886, 99)];
    imgBackgoundView.backgroundColor = [UIColor whiteColor];
    imgBackgoundView.layer.masksToBounds = YES;
    imgBackgoundView.layer.cornerRadius = 5;
    [self.incidentCommentPopupView addSubview:imgBackgoundView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(140, 79)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *incidentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(136, 30, 826, 99) collectionViewLayout:flowLayout];
    incidentCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    incidentCollectionView.delegate = self;
    incidentCollectionView.dataSource = self;
    incidentCollectionView.allowsMultipleSelection = YES;
    incidentCollectionView.allowsSelection = YES;
    incidentCollectionView.showsHorizontalScrollIndicator = NO;
    incidentCollectionView.backgroundColor = [UIColor whiteColor];
    incidentCollectionView.tag = 3;
    
    [self.incidentCommentPopupView addSubview:incidentCollectionView];
    self.incidentCommentCollection = incidentCollectionView;
    [self.incidentCommentCollection registerClass:[EKNCollectionViewCell class] forCellWithReuseIdentifier:@"cvCell"];
    self.incidentCommentCollection.delegate = self;
    self.incidentCommentCollection.dataSource =self;
    
    UIView *commentBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(32, 149, 960, 160)];
    commentBackgoundView.backgroundColor = [UIColor whiteColor];
    commentBackgoundView.layer.masksToBounds = YES;
    commentBackgoundView.layer.cornerRadius = 5;
    [self.incidentCommentPopupView addSubview:commentBackgoundView];
    
    UITextView *incidentCommentView = [[UITextView alloc] initWithFrame:CGRectMake(52, 169, 920, 120)];
    [self.incidentCommentPopupView addSubview:incidentCommentView];
    
    UIView *iincidentTypeBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(32, 329, 376, 32)];
    iincidentTypeBackgoundView.backgroundColor = [UIColor whiteColor];
    iincidentTypeBackgoundView.layer.masksToBounds = YES;
    iincidentTypeBackgoundView.layer.cornerRadius = 5;
    [self.incidentCommentPopupView addSubview:iincidentTypeBackgoundView];
    
    UILabel *incidentTypeLbl = [[UILabel alloc] initWithFrame:CGRectMake(47, 329, 361, 32)];
    incidentTypeLbl.textColor = [UIColor blackColor];
    incidentTypeLbl.text = @"Incident Type";
    incidentTypeLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.incidentCommentPopupView addSubview:incidentTypeLbl];
    
    UIImageView *dropdownImg = [[UIImageView alloc] initWithFrame:CGRectMake(378, 338, 17, 14)];
    dropdownImg.image = [UIImage imageNamed:@"dropdown_arrow"];
    [self.incidentCommentPopupView addSubview:dropdownImg];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(738, 319, 112, 50)];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor colorWithRed:(100.00/255.00f) green:(153.00/255.00f) blue:(209.00/255.00f) alpha:1.0];
    cancel.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    cancel.titleLabel.textColor = [UIColor whiteColor];
    cancel.layer.masksToBounds = YES;
    cancel.layer.cornerRadius = 5;
    [cancel addTarget:self action:@selector(hideIncidentCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.incidentCommentPopupView addSubview:cancel];
    
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(880, 319, 112, 50)];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    done.backgroundColor = [UIColor colorWithRed:(100.00/255.00f) green:(153.00/255.00f) blue:(209.00/255.00f) alpha:1.0];
    done.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    done.titleLabel.textColor = [UIColor whiteColor];
    done.layer.masksToBounds = YES;
    done.layer.cornerRadius = 5;
    //[done addTarget:self action:@selector(hideIncidentCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.incidentCommentPopupView addSubview:done];
    
    self.incidentCommentPopupView.hidden = YES;
    [self.view addSubview:self.incidentCommentPopupView];
}

- (void) initCommentPopupView
{
    self.commentImages = [NSMutableArray array];
    self.largeCommentImages = [NSMutableArray array];
    
    self.commentPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 389)];
    self.commentPopupView.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(0.00/255.00f) blue:(0.00/255.00f) alpha:0.35];;
    
    self.commentCamera = [[UIButton alloc] initWithFrame:CGRectMake(32, 30, 64, 52)];
    [self.commentCamera setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [self.commentCamera addTarget:self action:@selector(takeCommentCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentPopupView addSubview:self.commentCamera];
    
    UIView *imgBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(106, 30, 886, 99)];
    imgBackgoundView.backgroundColor = [UIColor whiteColor];
    imgBackgoundView.layer.masksToBounds = YES;
    imgBackgoundView.layer.cornerRadius = 5;
    [self.commentPopupView addSubview:imgBackgoundView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(140, 79)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *commentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(136, 30, 826, 99) collectionViewLayout:flowLayout];
    commentCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    commentCollectionView.delegate = self;
    commentCollectionView.dataSource = self;
    commentCollectionView.allowsMultipleSelection = YES;
    commentCollectionView.allowsSelection = YES;
    commentCollectionView.showsHorizontalScrollIndicator = NO;
    commentCollectionView.backgroundColor = [UIColor whiteColor];
    commentCollectionView.tag = 2;
    
    [self.commentPopupView addSubview:commentCollectionView];
    self.commentCollection = commentCollectionView;
    
    [self.commentCollection registerClass:[EKNCollectionViewCell class] forCellWithReuseIdentifier:@"cvCell"];
    
    self.commentCollection.delegate = self;
    self.commentCollection.dataSource =self;
    
    UIView *commentBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(106, 149, 886, 160)];
    commentBackgoundView.backgroundColor = [UIColor whiteColor];
    commentBackgoundView.layer.masksToBounds = YES;
    commentBackgoundView.layer.cornerRadius = 5;
    [self.commentPopupView addSubview:commentBackgoundView];
    
    UITextView *commentView = [[UITextView alloc] initWithFrame:CGRectMake(121, 169, 856, 120)];
    [self.commentPopupView addSubview:commentView];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(738, 319, 112, 50)];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor colorWithRed:(100.00/255.00f) green:(153.00/255.00f) blue:(209.00/255.00f) alpha:1.0];
    cancel.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    cancel.titleLabel.textColor = [UIColor whiteColor];
    cancel.layer.masksToBounds = YES;
    cancel.layer.cornerRadius = 5;
    [cancel addTarget:self action:@selector(hideCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentPopupView addSubview:cancel];
    
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(880, 319, 112, 50)];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    done.backgroundColor = [UIColor colorWithRed:(100.00/255.00f) green:(153.00/255.00f) blue:(209.00/255.00f) alpha:1.0];
    done.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    done.titleLabel.textColor = [UIColor whiteColor];
    done.layer.masksToBounds = YES;
    done.layer.cornerRadius = 5;
    //[done addTarget:self action:@selector(hideCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentPopupView addSubview:done];
    
    self.commentPopupView.hidden = YES;
    [self.view addSubview:self.commentPopupView];
}

/* table view delegete */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.inspectionLeftTableView)
    {
        return [[self.inspectionsDic objectForKey:@"inspectionslist"] count];
    }
    else if(tableView == self.inspectionMidTableView ||
            tableView == self.inspectionRightTableView )
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.inspectionLeftTableView)
    {
        return 30;
    }
    else if(tableView == self.inspectionMidTableView ||
            tableView == self.inspectionRightTableView )
    {
        return 50;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.inspectionMidTableView ||
            tableView == self.inspectionRightTableView )
    {
        NSString *identifier = @"ContactOwnerCell";
        ContactOwnerCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ContactOwnerCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        if(tableView == self.inspectionMidTableView )
        {
            [cell setCellValue:[self.inspectionsDic objectForKey:@"contactemail"]];
        }
        else
        {
            [cell setCellValue:[self.inspectionsDic objectForKey:@"contactowner"]];
        }
        return cell;
    }
    else if(tableView == self.inspectionLeftTableView)
    {
        NSString *identifier = @"InspectionListCell";
        InspectionListCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"InspectionListCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
        NSMutableArray *inspectionList = [self.inspectionsDic objectForKey:@"inspectionslist"];
        NSDictionary *inspecdic =[inspectionList objectAtIndex:indexPath.row];
        if(inspecdic!=nil)
        {
            [cell setCellValue:[inspecdic objectForKey:@"sl_datetime"]
                         owner:[inspecdic objectForKey:@"sl_accountname"]
                      incident:[inspecdic objectForKey:@"icon"]
                          plus:[[inspecdic objectForKey:@"bowner"] isEqualToString:@"YES"]];
        }
        
        return cell;
    }
    return nil;
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


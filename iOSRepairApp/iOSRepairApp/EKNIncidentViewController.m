//
//  EKNIncidentViewController.m
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNIncidentViewController.h"
#import "BaseController.h"
#import "EKNGraph.h"

@interface EKNIncidentViewController ()

@end

@implementation EKNIncidentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor=[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1];
    
    UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusbar.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(130.00/255.00f) blue:(114.00/255.00f) alpha:1.0];
    [self.view addSubview:statusbar];
    
    UIImageView *header_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 1024, 71)];
    header_img.image = [UIImage imageNamed:@"navigation_background"];
    [self.view addSubview:header_img];
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 91, 344, 768)];
    [leftview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:leftview];
    
    UIImageView *seperatorline = [[UIImageView alloc] initWithFrame:CGRectMake(344, 91, 5, 677)];
    seperatorline.image = [UIImage imageNamed:@"sepratorline"];
    [self.view addSubview:seperatorline];
    
    [self addPropertyDetailTable];
    [self addRightTable];
    [self addIncidentDetailView];
    
   
    if(self.incidentId == nil)
    {
        [self getIncidentFirstId];
    }
    else
    {
        [self loadPropertyIdByIncidentId];
    }
    
}

-(void)initData
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    self.siteUrl = [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"];
    self.client = [self getClient];
    self.cameraIsAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    self.incidentPhotoListDic = [[NSMutableDictionary alloc] init];
    self.roomInspectionPhotoDic = [[NSMutableDictionary alloc] init];
    self.repairPhotoDic = [[NSMutableDictionary alloc] init];
    self.inspectionDetailDic = [[NSMutableDictionary alloc] init];
    
    self.detailViewIsShowing = NO;
}
-(void)addSpinner{
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0,1024,768)];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.spinner setBackgroundColor:[UIColor colorWithRed:0.00f/255.00f green:0.00f/255.00f blue:0.00f/255.00f alpha:0.6]];
    [self.view addSubview:self.spinner];
    self.spinner.hidesWhenStopped = YES;
}
-(void)addPropertyDetailTable{
    
    self.propertyDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(25, 100, 315, 349) style:UITableViewStyleGrouped];
    self.propertyDetailTableView.backgroundColor = [UIColor whiteColor];
    self.propertyDetailTableView.delegate = self;
    self.propertyDetailTableView.dataSource = self;
    [self.propertyDetailTableView setScrollEnabled:NO];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    NSString *lbl1str = @"PROPERTY DETAILS";
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 40)];
    lbl1.text = lbl1str;
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = font;
    lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.propertyDetailTableView.tableHeaderView = lbl1;
    [self.view addSubview:self.propertyDetailTableView];
    
    self.contactOwnerTableView = [[UITableView alloc] initWithFrame:CGRectMake(24, 480, 315, 82) style:UITableViewStyleGrouped];
    self.contactOwnerTableView.backgroundColor = [UIColor whiteColor];
    self.contactOwnerTableView.delegate = self;
    self.contactOwnerTableView.dataSource = self;
    [self.contactOwnerTableView setScrollEnabled:NO];
    
    NSString *lbl2str = @"CONTACT OWNER";
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 40)];
    lbl2.text = lbl2str;
    lbl2.textAlignment = NSTextAlignmentLeft;
    lbl2.font = font;
    lbl2.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.contactOwnerTableView.tableHeaderView = lbl2;
    [self.view addSubview:self.contactOwnerTableView];
    
    self.contactOfficeTableView = [[UITableView alloc] initWithFrame:CGRectMake(24, 582, 315, 82) style:UITableViewStyleGrouped];
    self.contactOfficeTableView.backgroundColor = [UIColor whiteColor];
    self.contactOfficeTableView.delegate = self;
    self.contactOfficeTableView.dataSource = self;
    [self.contactOfficeTableView setScrollEnabled:NO];
    
    NSString *lbl3str = @"CONTACT OFFICE";
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 40)];
    lbl3.text = lbl3str;
    lbl3.textAlignment = NSTextAlignmentLeft;
    lbl3.font = font;
    lbl3.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.contactOfficeTableView.tableHeaderView = lbl3;
    [self.view addSubview:self.contactOfficeTableView];
}


-(void)addRightTable{
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(380, 100, 620, 657) style:UITableViewStyleGrouped];
    self.rightTableView.backgroundColor = [UIColor clearColor];
    [self.rightTableView setSeparatorColor:[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1]];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    [self.rightTableView.layer setCornerRadius:10.0];
    [self.rightTableView.layer setMasksToBounds:YES];
    [self.view addSubview:self.rightTableView];
}

-(void)addIncidentDetailView
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton  setFrame:CGRectMake(0, 350, 15, 71)];
    [self.backButton  setBackgroundImage:[UIImage imageNamed:@"before"] forState:UIControlStateNormal];
    [self.backButton  addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.hidden = YES;
    [self.view addSubview:self.backButton];
    
    self.detailLeftView = [[UIView alloc] initWithFrame:CGRectMake(24, 768, 315, 288)];
    self.detailLeftView.backgroundColor = [UIColor whiteColor];
    self.detailLeftView.hidden = YES;
    [self.view addSubview:self.detailLeftView];
    
    self.detailInspectionDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 315, 166) style:UITableViewStyleGrouped];
    self.detailInspectionDetailTableView.backgroundColor = [UIColor whiteColor];
    self.detailInspectionDetailTableView.delegate = self;
    self.detailInspectionDetailTableView.dataSource = self;
    [self.detailInspectionDetailTableView setScrollEnabled:NO];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    NSString *lbl3str = @"INSPECTION DETAILS";
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 40)];
    lbl3.text = lbl3str;
    lbl3.textAlignment = NSTextAlignmentLeft;
    lbl3.font = font;
    lbl3.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.detailInspectionDetailTableView.tableHeaderView = lbl3;
    [self.detailLeftView addSubview:self.detailInspectionDetailTableView];
    
    self.finalizeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 196, 315, 33)];
    [self.finalizeBtn setBackgroundImage:[UIImage imageNamed:@"finalize_repair"] forState:UIControlStateNormal];
    [self.finalizeBtn addTarget:self action:@selector(updateRepairCompleted) forControlEvents:UIControlEventTouchUpInside];
    [self.detailLeftView addSubview:self.finalizeBtn];
    
    self.detailRightView = [[UIView alloc] initWithFrame:CGRectMake(1024, 91, 675, 677)];
    self.detailRightView.backgroundColor = [UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1];
    self.detailRightView.hidden = YES;
    [self.view addSubview:self.detailRightView];
    
    UIView *rightTopView = [[UIView alloc] initWithFrame:CGRectMake(31, 15, 620, 50)];
    rightTopView.backgroundColor = [UIColor colorWithRed:134.00f/255.00f green:134.00f/255.00f blue:134.00f/255.00f alpha:1];
    [self.detailRightView addSubview:rightTopView];
    
    NSString *lbl4Str = @"Room: ";
    CGSize size1 = [EKNEKNGlobalInfo getSizeFromStringWithFont:lbl4Str font:font];
    self.roomTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size1.width, 50)];
    self.roomTitleLbl.text = lbl4Str;
    self.roomTitleLbl.textAlignment = NSTextAlignmentLeft;
    self.roomTitleLbl.font = font;
    self.roomTitleLbl.textColor = [UIColor whiteColor];
    [rightTopView addSubview:self.roomTitleLbl];
    
    self.separatorLbl = [[UILabel alloc] initWithFrame:CGRectMake(10 + size1.width, 5, 40, 40)];
    self.separatorLbl.text = @"|";
    self.separatorLbl.textAlignment = NSTextAlignmentCenter;
    self.separatorLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    self.separatorLbl.textColor = [UIColor whiteColor];
    [rightTopView addSubview:self.separatorLbl];
    
    NSString *lbl6Str = @"Type: ";
    CGSize size2 = [EKNEKNGlobalInfo getSizeFromStringWithFont:lbl6Str font:font];
    self.incidentTypeLbl = [[UILabel alloc] initWithFrame:CGRectMake((10 + size1.width + 40), 0, size2.width, 50)];
    self.incidentTypeLbl.text = lbl6Str;
    self.incidentTypeLbl.textAlignment = NSTextAlignmentLeft;
    self.incidentTypeLbl.font = font;
    self.incidentTypeLbl.textColor = [UIColor whiteColor];
    [rightTopView addSubview:self.incidentTypeLbl];
    
    UIImageView *rightTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, 90, 620, 64)];
    rightTopImageView.image = [UIImage imageNamed:@"incident_detailtab"];
    [self.detailRightView addSubview:rightTopImageView];
    
    //add tab button
    UIButton *tabBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    tabBtn1.frame = CGRectMake(31, 90, 206, 64);
    tabBtn1.tag = 1;
    [tabBtn1 addTarget:self action:@selector(rightTabSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailRightView addSubview:tabBtn1];
    
    UIButton *tabBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    tabBtn2.frame = CGRectMake(237, 90, 207, 64);
    tabBtn2.tag = 2;
    [tabBtn2 addTarget:self action:@selector(rightTabSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailRightView addSubview:tabBtn2];
    
    UIButton *tabBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    tabBtn3.frame = CGRectMake(444, 90, 207, 64);
    tabBtn3.tag = 3;
    [tabBtn3 addTarget:self action:@selector(rightTabSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailRightView addSubview:tabBtn3];
    
    self.detailRightDispatcher = [[UIView alloc] initWithFrame:CGRectMake(31, 170, 644, 507)];
    [self.detailRightView addSubview:self.detailRightDispatcher];
    
    UILabel *lbl7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 620, 30)];
    lbl7.text = @"DISPATCHER COMMENTS";
    lbl7.textAlignment = NSTextAlignmentLeft;
    lbl7.font = [UIFont fontWithName:@"Helvetica" size:30];
    lbl7.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    [self.detailRightDispatcher addSubview:lbl7];
    
    UIView *rightCommentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 620, 400)];
    rightCommentBgView.backgroundColor = [UIColor whiteColor];
    rightCommentBgView.layer.masksToBounds = YES;
    rightCommentBgView.layer.cornerRadius = 10;
    [self.detailRightDispatcher addSubview:rightCommentBgView];
    
    
    self.tabDispatcherComments = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 600, 380)];
    self.tabDispatcherComments.textAlignment = NSTextAlignmentLeft;
    self.tabDispatcherComments.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.tabDispatcherComments.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.tabDispatcherComments.editable = NO;
    [rightCommentBgView addSubview:self.tabDispatcherComments];
    
    self.detailRightInspector = [[UIView alloc] initWithFrame:CGRectMake(675, 170, 644, 507)];
    self.detailRightInspector.hidden = YES;
    [self.detailRightView addSubview:self.detailRightInspector];
    UILabel *lbl9 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 620, 30)];
    lbl9.text = @"INSPECTOR COMMENTS & PHOTOS";
    lbl9.textAlignment = NSTextAlignmentLeft;
    lbl9.font = [UIFont fontWithName:@"Helvetica" size:30];
    lbl9.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    [self.detailRightInspector addSubview:lbl9];
    
    UIView *collectionBg = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 620, 136)];
    collectionBg.backgroundColor = [UIColor whiteColor];
    collectionBg.layer.masksToBounds = YES;
    collectionBg.layer.cornerRadius = 10;
    [self.detailRightInspector addSubview:collectionBg];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.inspectorCommentCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 10, 590, 116) collectionViewLayout:flowLayout];
    self.inspectorCommentCollection.translatesAutoresizingMaskIntoConstraints = NO;
    self.inspectorCommentCollection.delegate = self;
    self.inspectorCommentCollection.dataSource = self;
    self.inspectorCommentCollection.allowsMultipleSelection = YES;
    self.inspectorCommentCollection.allowsSelection = YES;
    self.inspectorCommentCollection.showsHorizontalScrollIndicator = NO;
    self.inspectorCommentCollection.backgroundColor = [UIColor whiteColor];
    [collectionBg addSubview:self.inspectorCommentCollection];
    
    [self.inspectorCommentCollection registerClass:[EKNCollectionViewCell class] forCellWithReuseIdentifier:@"cvCell"];
    self.inspectorCommentCollection.delegate = self;
    self.inspectorCommentCollection.dataSource =self;
    
    UIView *inspectorCommentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 186, 620, 281)];
    inspectorCommentBgView.backgroundColor = [UIColor whiteColor];
    inspectorCommentBgView.layer.masksToBounds = YES;
    inspectorCommentBgView.layer.cornerRadius = 10;
    [self.detailRightInspector addSubview:inspectorCommentBgView];
    
    self.tabInsptorComments = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 600, 261)];
    self.tabInsptorComments.textAlignment = NSTextAlignmentLeft;
    self.tabInsptorComments.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.tabInsptorComments.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.tabInsptorComments.editable = NO;
    [inspectorCommentBgView addSubview:self.tabInsptorComments];
    
    self.detailRightAdd = [[UIView alloc] initWithFrame:CGRectMake(675, 170, 644, 507)];
    self.detailRightAdd.hidden = YES;
    [self.detailRightView addSubview:self.detailRightAdd];
    UILabel *lbl10 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 620, 30)];
    lbl10.text = @"ADD REPAIR COMMENTS & PHOTOS";
    lbl10.textAlignment = NSTextAlignmentLeft;
    lbl10.font = [UIFont fontWithName:@"Helvetica" size:30];
    lbl10.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    [self.detailRightAdd addSubview:lbl10];
    
    UIButton *repairCamera = [[UIButton alloc] initWithFrame:CGRectMake(15, 75, 58, 47)];
    [repairCamera setBackgroundImage:[UIImage imageNamed:@"camera_gray"] forState:UIControlStateNormal];
    [repairCamera addTarget:self action:@selector(takeCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.detailRightAdd addSubview:repairCamera];
    
    UIView *repariCollectionBg = [[UIView alloc] initWithFrame:CGRectMake(100, 40, 520, 136)];
    repariCollectionBg.backgroundColor = [UIColor whiteColor];
    repariCollectionBg.layer.masksToBounds = YES;
    repariCollectionBg.layer.cornerRadius = 10;
    [self.detailRightAdd addSubview:repariCollectionBg];
    
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout2 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.commentCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 10, 490, 116) collectionViewLayout:flowLayout2];
    self.commentCollection.translatesAutoresizingMaskIntoConstraints = NO;
    self.commentCollection.delegate = self;
    self.commentCollection.dataSource = self;
    self.commentCollection.allowsMultipleSelection = YES;
    self.commentCollection.allowsSelection = YES;
    self.commentCollection.showsHorizontalScrollIndicator = NO;
    self.commentCollection.backgroundColor = [UIColor whiteColor];
    [repariCollectionBg addSubview:self.commentCollection];
    
    [self.commentCollection registerClass:[EKNCollectionViewCell class] forCellWithReuseIdentifier:@"cvCell"];
    self.commentCollection.delegate = self;
    self.commentCollection.dataSource =self;
    
    UIView *repariCommentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 186, 620, 241)];
    repariCommentBgView.backgroundColor = [UIColor whiteColor];
    repariCommentBgView.layer.masksToBounds = YES;
    repariCommentBgView.layer.cornerRadius = 10;
    [self.detailRightAdd addSubview:repariCommentBgView];
    
    self.tabComments = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 600, 261)];
    self.tabComments.textAlignment = NSTextAlignmentLeft;
    self.tabComments.contentSize = CGSizeMake(600, 261);
    self.tabComments.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.tabComments.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    [repariCommentBgView addSubview:self.tabComments];
    
    self.repairCommentDoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(508, 437, 112, 50)];
    self.repairCommentDoneBtn.backgroundColor = [UIColor colorWithRed:100.00f/255.00f green:153.00f/255.00f blue:209.00f/255.00f alpha:1];;
    [self.repairCommentDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
    self.repairCommentDoneBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.repairCommentDoneBtn.titleLabel.textColor = [UIColor whiteColor];
    self.repairCommentDoneBtn.layer.masksToBounds = YES;
    self.repairCommentDoneBtn.layer.cornerRadius = 5;
    [self.repairCommentDoneBtn addTarget:self action:@selector(updateRepairComment) forControlEvents:UIControlEventTouchUpInside];
    [self.detailRightAdd addSubview:self.repairCommentDoneBtn];
    
    self.largePhotoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    self.largePhotoView.backgroundColor = [UIColor colorWithRed:0.00f/255.00f green:0.00f/255.00f blue:0.00f/255.00f alpha:0.5];
    self.largePhotoView.hidden = YES;
    [self.view addSubview:self.largePhotoView];
    
    self.largeImageView = [[UIImageView alloc] init];
    [self.largePhotoView addSubview:self.largeImageView];
    
    self.largeImageCloseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 31)];
    [self.largeImageCloseBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.largeImageCloseBtn addTarget:self action:@selector(hideLargePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.largePhotoView addSubview:self.largeImageCloseBtn];
}

-(void)setRoomTitleAndIncidentType:(NSString *)title type:(NSString *)type
{
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    NSString *lblStr = [@"Room: " stringByAppendingString:[EKNEKNGlobalInfo getString:title]];
    CGSize size1 = [EKNEKNGlobalInfo getSizeFromStringWithFont:lblStr font:font];
    self.roomTitleLbl.frame = CGRectMake(10, 0, size1.width, 50);
    self.roomTitleLbl.text = lblStr;
    
    self.separatorLbl.frame = CGRectMake(10 + size1.width, 5, 40, 40);
    
    NSString *lbl1Str = [@"Type: " stringByAppendingString:[EKNEKNGlobalInfo getString:type]];
    CGSize size2 = [EKNEKNGlobalInfo getSizeFromStringWithFont:lbl1Str font:font];
    self.incidentTypeLbl.frame = CGRectMake((10 + size1.width + 40), 0, size2.width, 50);
    self.incidentTypeLbl.text = lbl1Str;
}

-(void)rightTabSelected:(UIButton *)button
{
    if(button.tag == 1)
    {
        if(self.detailRightDispatcher.hidden == YES)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.detailRightInspector.hidden = YES;
                self.detailRightAdd.hidden = YES;
                self.detailRightDispatcher.hidden = NO;
                self.detailRightDispatcher.frame = CGRectMake(31, 170, 644, 507);
            } completion:^(BOOL finished) {
                self.detailRightInspector.frame = CGRectMake(675, 170, 644, 507);
                self.detailRightAdd.frame = CGRectMake(675, 170, 644, 507);
            }];
        }
    }
    else if(button.tag == 2)
    {
        if(self.detailRightInspector.hidden == YES)
        {
            [self.inspectorCommentCollection reloadData];
            if([self.roomInspectionPhotoDic objectForKey:self.selectIncidentId] == nil)
            {
                [self showLoading];
                [self getInspectorPhoto:self.selectInspectionId incidentId:self.selectIncidentId roomId:self.selectRoomId];
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.detailRightDispatcher.hidden = YES;
                self.detailRightAdd.hidden = YES;
                self.detailRightInspector.hidden = NO;
                self.detailRightInspector.frame = CGRectMake(31, 170, 644, 507);
            } completion:^(BOOL finished) {
                self.detailRightDispatcher.frame = CGRectMake(675, 170, 644, 507);
                self.detailRightAdd.frame = CGRectMake(675, 170, 644, 507);
            }];
        }
    }
    else if(button.tag == 3)
    {
        if(self.detailRightAdd.hidden == YES)
        {
            [self.commentCollection reloadData];
            if([self.repairPhotoDic objectForKey:self.selectIncidentId] == nil)
            {
                [self showLoading];
                [self getRepairPhoto:self.selectInspectionId incidentId:self.selectIncidentId roomId:self.selectRoomId];
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.detailRightDispatcher.hidden = YES;
                self.detailRightInspector.hidden = YES;
                self.detailRightAdd.hidden = NO;
                self.detailRightAdd.frame = CGRectMake(31, 170, 644, 507);
            } completion:^(BOOL finished) {
                self.detailRightDispatcher.frame = CGRectMake(675, 170, 644, 507);
                self.detailRightInspector.frame = CGRectMake(675, 170, 644, 507);
            }];
        }
    }
}

-(void)setRightTableSelectIndex:(NSIndexPath*)indexpath
{
    EKNListItem *incidentItem = [self.incidentListArray objectAtIndex:indexpath.row];
    NSString *incidentType = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"sl_type"]];
    NSDictionary *roomData = (NSDictionary *)[incidentItem getData:@"sl_roomID"];
    NSString *roomTitle = [EKNEKNGlobalInfo getString:(NSString *)[roomData objectForKey:@"Title"]];
    NSString *incidentID = (NSString *)[incidentItem getData:@"ID"];
    NSString *inspectionID = (NSString *)[incidentItem getData:@"sl_inspectionIDId"];
    NSString *roomID = (NSString *)[incidentItem getData:@"sl_roomIDId"];
    NSString *taskId = (NSString *)[incidentItem getData:@"sl_taskId"];
    if(taskId == nil || (NSNull *)taskId == [NSNull null])
    {
        taskId = [EKNEKNGlobalInfo getString:taskId];
    }
    else
    {
        taskId = [NSString stringWithFormat:@"%@",taskId];
    }
    NSString *completedDate = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"sl_repairCompleted"]];
    NSString *status = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"sl_status"]];
    
    //set select index
    self.selectedIndex = indexpath.row;
    self.selectedIndexPath = indexpath;
    
    //set the selected IDs
    self.selectIncidentId = incidentID;
    self.selectInspectionId = inspectionID;
    self.selectRoomId = roomID;
    self.selectTaskId = taskId;
    NSLog(@"incidentID:%@,inspectionID:%@,roomID:%@,taskID:%@",self.selectIncidentId,self.selectInspectionId,self.selectRoomId,self.selectTaskId);
    
    //set finalize repair button
    self.finalizeBtn.hidden = ![EKNEKNGlobalInfo isBlankString:completedDate];
    
    //set the inspection table
    [self.inspectionDetailDic setObject:@"" forKey:@"name"];
    [self.inspectionDetailDic setObject:@"" forKey:@"email"];
    [self.inspectionDetailDic setObject:@"" forKey:@"date"];
    [self.detailInspectionDetailTableView reloadData];
    [self getInspectionDataByID:inspectionID];
    
    //set room title and incident type
    [self setRoomTitleAndIncidentType:roomTitle type:incidentType];
    
    //check if use can edit repair comments
    self.canEditComments = !([status isEqualToString:@"Repair Pending Approval"] || [status isEqualToString:@"Repair Approved"]);
    self.repairCommentDoneBtn.hidden = !self.canEditComments;
    self.tabComments.editable = self.canEditComments;
    
    //set comments [sl_inspectorIncidentComments,sl_dispatcherComments,sl_repairComments]
    self.tabDispatcherComments.text = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"sl_dispatcherComments"]];
    self.tabInsptorComments.text = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"sl_inspectorIncidentComments"]];
    self.tabComments.text = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"sl_repairComments"]];
    
    //set the tab view to default
    self.detailRightDispatcher.frame = CGRectMake(31, 170, 644, 507);
    self.detailRightInspector.frame = CGRectMake(675, 170, 644, 507);
    self.detailRightAdd.frame = CGRectMake(675, 170, 644, 507);
    self.detailRightInspector.hidden = YES;
    self.detailRightAdd.hidden = YES;
    self.detailRightDispatcher.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.detailViewIsShowing = YES;
        self.detailLeftView.frame = CGRectMake(24, 480, 315, 288);
        self.detailLeftView.hidden = NO;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.detailRightView.frame = CGRectMake(349, 91, 675, 677);
            self.detailRightView.hidden = NO;
        } completion:^(BOOL finished) {
            self.backButton.hidden = NO;
        }];
    }];
}

-(void)backAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backButton.hidden = YES;
        self.detailLeftView.frame = CGRectMake(24, 768, 315, 288);
    } completion:^(BOOL finished) {
        self.detailLeftView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.detailRightView.frame = CGRectMake(1024, 91, 675, 677);
        } completion:^(BOOL finished) {
            self.detailRightView.hidden = YES;
            self.detailViewIsShowing = NO;
        }];
    }];
}

-(void)showLoading
{
    [self.spinner startAnimating];
}

-(void)hideLoading
{
    if(self.spinner != nil)
    {
        [self.spinner stopAnimating];
    }
}

-(void)showSuccessMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)showErrorMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)showHintAlertView:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


-(void)showLargePhoto:(UIImage *)image
{
    CGFloat width = image.size.width;
    CGFloat height =image.size.height;
    if(width > 1009)
    {
        width = 1009;
        height = height / (width / 1009);
    }
    if(height > 753)
    {
        height = 753;
        width = width / (height / 753);
    }
    
    CGFloat x = (1024 - width) / 2;
    CGFloat y = (768 - height) / 2;
    self.largeImageView.frame = CGRectMake(x, y, width, height);
    self.largeImageView.image = image;
    
    self.largeImageCloseBtn.frame = CGRectMake(x + width - 15, y - 15, 30, 31);
    self.largePhotoView.hidden = NO;
}

-(void)hideLargePhoto
{
    self.largePhotoView.hidden = YES;
}

-(void)showSendEmailViewController:(NSString *)address
{
    UIDevice *device =[UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPad Simulator"]) {
        [self showHintAlertView:@"Hint" message:@"Simulator does not support Mail View"];
        return;
    }
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    NSArray *to = [NSArray arrayWithObjects:address, nil];
    
    NSString *body =@"Edkey Note Demo";
    [mc setToRecipients:to];
    [mc setMessageBody:body isHTML:NO];
    [self presentViewController:mc animated:YES completion:NULL];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)getIncidentFirstId{
    [self showLoading];
    NSString *filter = @"$select=ID&$orderby=ID asc&$top=1";
    NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self.client getListItemsByFilter:@"Incidents" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(listItems != nil && [listItems count] >0)
            {
                EKNListItem *item = listItems[0];
                self.incidentId = (NSString *)[item getData:@"ID"];
                [self loadPropertyIdByIncidentId];
            }
            else
            {
                [self hideLoading];
                [self showErrorMessage:@"Can't find Incidents list item."];
            }
        });
    }];
}

-(void)loadPropertyIdByIncidentId{
    [self showLoading];
    NSString *filter = [NSString stringWithFormat:@"$select=ID,sl_propertyIDId,sl_propertyID/ID&$expand=sl_propertyID&$filter=ID eq %@ and sl_propertyIDId gt 0 and sl_inspectionIDId gt 0 and sl_roomIDId gt 0",self.incidentId];
    NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self.client getListItemsByFilter:@"Incidents" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(listItems != nil && [listItems count] == 1)
            {
                EKNListItem *item = listItems[0];
                NSString *propertyId = (NSString *)[item getData:@"sl_propertyIDId"];
                self.selectPropertyId = propertyId;
                
                [self loadData];
            }
            else
            {
                [self hideLoading];
                [self showErrorMessage:[NSString stringWithFormat:@"The incident with ID %@ not found.",self.incidentId]];
            }
        });
    }];
}

-(void)loadData{
    NSString *filter = [NSString stringWithFormat:@"$select=ID,Title,sl_inspectorIncidentComments,sl_dispatcherComments,sl_repairComments,sl_status,sl_type,sl_date,sl_repairCompleted,sl_inspectionIDId,sl_roomIDId,sl_taskId,sl_inspectionID/ID,sl_inspectionID/sl_datetime,sl_inspectionID/sl_finalized,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_emailaddress,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode,sl_roomID/ID,sl_roomID/Title&$expand=sl_inspectionID,sl_propertyID,sl_roomID&$filter=sl_propertyIDId eq %@ and sl_inspectionIDId gt 0 and sl_roomIDId gt 0&$orderby=sl_date desc",self.selectPropertyId];
    NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self.client getListItemsByFilter:@"Incidents" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            self.incidentListArray = listItems;
            
            if(listItems != nil && [listItems count] > 0)
            {
                EKNListItem *item = listItems[0];
                NSDictionary *property = (NSDictionary *)[item getData:@"sl_propertyID"];
                self.propertyDetailDic = property;
                //   [self sendEmailAfterRepair];
                [self.propertyDetailTableView reloadData];
                [self.contactOwnerTableView reloadData];
                [self.contactOfficeTableView reloadData];
                [self.rightTableView reloadData];
                
                [self getPropertyPhoto];
                [self getIncidentListPhoto];
            }
        });
    }];
}

- (void)updateRepairComment
{
    [self showLoading];
    NSString *repairComments = [EKNEKNGlobalInfo getString:self.tabComments.text];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/lists/GetByTitle('%@')/Items(%@)",self.siteUrl,@"Incidents",self.selectIncidentId];
    NSString *postString = [NSString stringWithFormat:@"{'__metadata': { 'type': 'SP.Data.IncidentsListItem' },'sl_repairComments':'%@'}",repairComments];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"content-type"];
    [request addValue:@"*" forHTTPHeaderField:@"IF-MATCH"];
    [request addValue:@"MERGE" forHTTPHeaderField:@"X-HTTP-Method"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            if([EKNEKNGlobalInfo requestSuccess:response])
            {
                EKNListItem *item = [self.incidentListArray objectAtIndex:self.selectedIndex];
                NSMutableDictionary *dic = (NSMutableDictionary *)[item valueForKey:@"_jsonData"];
                [dic setValue:repairComments forKey:@"sl_repairComments"];
                [self showSuccessMessage:@"Update repair comments successfully."];
            }
            else
            {
                [self showErrorMessage:@"Update repair comments failed."];
            }
        });
    }];
    [task resume];
}

- (void)updateRepairCompleted
{
    [self showLoading];
    NSDate *currentDate = [NSDate date];
    NSString *repairCompleted = [EKNEKNGlobalInfo converStringFromDate:currentDate];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/lists/GetByTitle('%@')/Items(%@)",self.siteUrl,@"Incidents",self.selectIncidentId];
    NSString *postString = [NSString stringWithFormat:@"{'__metadata': { 'type': 'SP.Data.IncidentsListItem' },'sl_repairCompleted':'%@','sl_status':'Repair Pending Approval'}",repairCompleted];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"content-type"];
    [request addValue:@"*" forHTTPHeaderField:@"IF-MATCH"];
    [request addValue:@"MERGE" forHTTPHeaderField:@"X-HTTP-Method"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([EKNEKNGlobalInfo requestSuccess:response])
            {
                EKNListItem *item = [self.incidentListArray objectAtIndex:self.selectedIndex];
                NSMutableDictionary *dic = (NSMutableDictionary *)[item valueForKey:@"_jsonData"];
                [dic setValue:@"Repair Pending Approval" forKey:@"sl_status"];
                [dic setValue:repairCompleted forKey:@"sl_repairCompleted"];
                if([EKNEKNGlobalInfo isBlankString:self.selectTaskId])
                {
                    self.finalizeBtn.hidden = YES;
                    self.canEditComments = NO;
                    self.repairCommentDoneBtn.hidden = YES;
                    self.tabComments.editable = NO;
                    [self hideLoading];
                    [self updateRightTableCell:self.selectedIndexPath];
                    [self showSuccessMessage:@"Finalize repair successfully."];
                    [self sendEmailAfterRepair];
                }
                else
                {
                    [self updateIncidentWorkflowTask];
                }
            }
            else
            {
                [self hideLoading];
                [self showErrorMessage:@"Finalize repair failed."];
            }
        });
    }];
    [task resume];
}
//after create an new incident item, we will send a email using exchage
-(void)sendEmailAfterRepair
{
    NSString *to = [EKNEKNGlobalInfo getString:[self.propertyDetailDic objectForKey:@"sl_emailaddress"]];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cc = [standardUserDefaults objectForKey:@"dispatcherEmail"];
    
    NSString *incidentId = self.selectIncidentId;
    NSString *propertyId = self.selectPropertyId;
    NSString *propertyName = [EKNEKNGlobalInfo getString:[self.propertyDetailDic objectForKey:@"Title"]];
    NSString *propertyAddress = [EKNEKNGlobalInfo getString:[self.propertyDetailDic objectForKey:@"sl_address1"]];
    NSMutableDictionary *emailDataDic = [[NSMutableDictionary alloc] init];
    NSString *currentDate = [EKNEKNGlobalInfo converStringFromDate:[NSDate date]];
    NSMutableString *body =[[NSMutableString alloc] initWithString:@"\r\nThe incident found during a recent inspection on your property has been repaired.\r\n"];
    [body appendFormat:@"\r\n\r\nProperty Name: %@\r\nProperty Address: %@\r\n\r\nRepair Date: %@\r\n\r\n",propertyName,propertyAddress,currentDate];
    
    [body appendFormat:@"\r\nIncident ID: %@", incidentId];
    [body appendFormat:@"\r\nProperty ID: %@", propertyId];
    
    
    [emailDataDic setObject:[NSString stringWithFormat:@"Repair Report - %@ - %@",propertyName,currentDate] forKey:@"subject"];
    [emailDataDic setObject:to forKey:@"to"];
    [emailDataDic setObject:cc forKey:@"cc"];
    [emailDataDic setObject:body forKey:@"body"];
    EKNGraph *graph = [[EKNGraph alloc] init];
    [graph sendMail:emailDataDic callback:^(int returnValue, NSError *error)
     {
         // NSLog(@" send email error %@,%d",error,returnValue);
         if (error ==nil) {
             //
             NSLog(@"Send email success.");
         }
         else
         {
             //
             NSLog(@"Send email failed.");
         }
     }];
}
- (void)updateIncidentWorkflowTask
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/lists/GetByTitle('%@')/Items(%@)",self.siteUrl,@"Incident%20Workflow%20Tasks",self.selectTaskId];
    NSString *postString = @"{'__metadata': { 'type': 'SP.Data.Incident_x0020_Workflow_x0020_TasksListItem' },'PercentComplete':1,'Status':'Completed'}";
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [request addValue:@"application/json;odata=verbose" forHTTPHeaderField:@"content-type"];
    [request addValue:@"*" forHTTPHeaderField:@"IF-MATCH"];
    [request addValue:@"MERGE" forHTTPHeaderField:@"X-HTTP-Method"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            if([EKNEKNGlobalInfo requestSuccess:response])
            {
                self.finalizeBtn.hidden = YES;
                self.canEditComments = NO;
                self.repairCommentDoneBtn.hidden = YES;
                self.tabComments.editable = NO;
                [self updateRightTableCell:self.selectedIndexPath];
                [self showSuccessMessage:@"Finalize repair successfully."];
                [self sendEmailAfterRepair];
            }
            else
            {
                [self showErrorMessage:@"Finalize repair failed."];
            }
        });
    }];
    [task resume];
}

-(void)getInspectionDataByID:(NSString *)inspectionID
{
    [self showLoading];
    
    NSString *filter = [NSString stringWithFormat:@"$select=Id,sl_datetime,sl_inspector,sl_emailaddress&$filter=Id eq %@&$orderby=sl_datetime desc&$top=1",inspectionID];
    NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self.client getListItemsByFilter:@"Inspections" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(listItems != nil && [listItems count] > 0)
            {
                EKNListItem *item = listItems[0];
                //NSDictionary *inspector = (NSDictionary *)[item getData:@"sl_inspector"];
                [self.inspectionDetailDic setObject:[item getData:@"sl_inspector"] forKey:@"name"];
                [self.inspectionDetailDic setObject:[item getData:@"sl_emailaddress"] forKey:@"email"];
                [self.inspectionDetailDic setObject:[item getData:@"sl_datetime"] forKey:@"date"];
                [self.detailInspectionDetailTableView reloadData];
            }
            [self hideLoading];
        });
    }];
}

-(void)getPropertyPhoto
{
    NSString *filter = [NSString stringWithFormat:@"$select=ID,Title&$filter=sl_propertyIDId eq %@&$orderby=Modified desc&$top=1",self.selectPropertyId];
    NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self.client getListItemsByFilter:@"Property Photos" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(listItems != nil && [listItems count] == 1)
            {
                NSString *propertyPhotoFileID = (NSString *)[listItems[0] getData:@"ID"];
                [self.propertyDetailDic setValue:propertyPhotoFileID forKey:@"photoID"];
                [self getPropertyPhotoServerRelativeUrl];
            }
        });
    }];
}

-(void)getPropertyPhotoServerRelativeUrl
{
    [self.client getListItemFileByFilter:@"Property Photos"
                                  FileId:(NSString *)[self.propertyDetailDic objectForKey:@"photoID"]
                                  filter:@"$select=ServerRelativeUrl"
                                callback:^(NSMutableArray *listItems, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if(listItems != nil && [listItems count] > 0)
             {
                 [self.propertyDetailDic setValue:[listItems[0] getData:@"ServerRelativeUrl"] forKey:@"photoServerRelativeUrl"];
                 [self getPhoto];
             }
         });
         
     }];
}

-(void)getPhoto
{
    NSString *path =(NSString *)[self.propertyDetailDic objectForKey:@"photoServerRelativeUrl"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFileByServerRelativeUrl('%@%@",self.siteUrl,path,@"')/$value"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.token];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([EKNEKNGlobalInfo requestSuccess:response]) {
                UIImage *image =[[UIImage alloc] initWithData:data];
                if(image != nil)
                {
                    [self.propertyDetailDic setValue:image forKey:@"photo"];
                    [self.propertyDetailTableView reloadData];
                }
            }
            else
            {
                if([self.propertyDetailDic objectForKey:@"trytimes"]!=nil)
                {
                    NSInteger times =[[self.propertyDetailDic objectForKey:@"trytimes"] integerValue];
                    if(times>=3)
                    {
                        
                    }
                    else
                    {
                        times=times+1;
                        [self.propertyDetailDic setValue:[NSString stringWithFormat:@"%ld",(long)times] forKey:@"trytimes"];
                        [self getPhoto];
                    }
                }
                else
                {
                    [self.propertyDetailDic setValue:@"1" forKey:@"trytimes"];
                    [self getPhoto];
                }
            }
        });
    }];
    [task resume];
}

-(void)getIncidentListPhoto
{
    for (EKNListItem* item in self.incidentListArray) {
        NSString *incidentID = (NSString *)[item getData:@"ID"];
        NSString *inspectionID =(NSString *)[item getData:@"sl_inspectionIDId"];
        NSString *roomID = (NSString *)[item getData:@"sl_roomIDId"];
        NSString *filter = [NSString stringWithFormat:@"$select=ID,Title&$filter=sl_inspectionIDId eq %@ and sl_incidentIDId eq %@ and sl_roomIDId eq %@&$orderby=Modified desc&$top=1",inspectionID,incidentID,roomID];
        
        NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self.client getListItemsByFilter:@"Room Inspection Photos" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(listItems != nil && [listItems count] == 1)
                {
                    NSString *photoID = (NSString *)[listItems[0] getData:@"ID"];
                    [self getRoomInspectionPhotoServerRelativeUrl:photoID incidentID:incidentID];
                }
            });
        }];
    }
}

-(void)getRoomInspectionPhotoServerRelativeUrl:(NSString *)photoID incidentID:(NSString *)incidentID
{
    [self.client getListItemFileByFilter:@"Room Inspection Photos"
                                  FileId:photoID
                                  filter:@"$select=ServerRelativeUrl"
                                callback:^(NSMutableArray *listItems, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if(listItems != nil && [listItems count] > 0)
             {
                 NSString *serverRelativeUrl = (NSString *)[listItems[0] getData:@"ServerRelativeUrl"];
                 [self getRoomInspectionPhoto:serverRelativeUrl incidentID:incidentID];
             }
         });
         
     }];
}

-(void)getRoomInspectionPhoto:(NSString *)serverRelativeUrl incidentID:(NSString *)incidentID
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFileByServerRelativeUrl('%@%@",self.siteUrl,serverRelativeUrl,@"')/$value"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.token];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([EKNEKNGlobalInfo requestSuccess:response]) {
                if([self.incidentPhotoListDic objectForKey:incidentID] == nil)
                {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [self.incidentPhotoListDic setObject:dic forKey:incidentID];
                }
                UIImage *image =[[UIImage alloc] initWithData:data];
                if(image != nil)
                {
                    [[self.incidentPhotoListDic objectForKey:incidentID] setObject:image forKey:@"photo"];
                    [self.rightTableView reloadData];
                }
            }
            else
            {
                if([self.incidentPhotoListDic objectForKey:incidentID] == nil)
                {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [self.incidentPhotoListDic setObject:dic forKey:incidentID];
                }
                if([[self.incidentPhotoListDic objectForKey:incidentID] objectForKey:@"trytimes"]!=nil)
                {
                    NSInteger times =(NSInteger)[[self.incidentPhotoListDic objectForKey:incidentID] objectForKey:@"trytimes"];
                    if(times < 3)
                    {
                        times=times+1;
                        [[self.incidentPhotoListDic objectForKey:incidentID] setObject:[NSString stringWithFormat:@"%ld",(long)times] forKey:@"trytimes"];
                        [self getRoomInspectionPhoto:serverRelativeUrl incidentID:incidentID];
                    }
                }
                else
                {
                    [[self.incidentPhotoListDic objectForKey:incidentID] setObject:@"1" forKey:@"trytimes"];
                    [self getRoomInspectionPhoto:serverRelativeUrl incidentID:incidentID];
                }
            }
        });
    }];
    [task resume];
}

//get selected inspection photos
-(void)getInspectorPhoto:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId
{
    NSString *filter = [NSString stringWithFormat:@"$select=ID,Title&$filter=sl_inspectionIDId eq %@ and sl_incidentIDId eq %@ and sl_roomIDId eq %@&$orderby=Modified desc",inspectionId,incidentId,roomId];
    NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self.client getListItemsByFilter:@"Room Inspection Photos" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            if(listItems != nil && [listItems count] > 0)
            {
                for (EKNListItem *item in listItems) {
                    NSString *photoID = (NSString *)[item getData:@"ID"];
                    [self getInspectorPhotoServerRelativeUrl:inspectionId incidentId:incidentId roomId:roomId photoId:photoID];
                }
            }
        });
    }];
}

-(void)getInspectorPhotoServerRelativeUrl:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId photoId:(NSString *)photoId
{
    [self.client getListItemFileByFilter:@"Room Inspection Photos"
                                  FileId:photoId
                                  filter:@"$select=ServerRelativeUrl"
                                callback:^(NSMutableArray *listItems, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if(listItems != nil && [listItems count] > 0)
             {
                 NSString *serverRelativeUrl = (NSString *)[listItems[0] getData:@"ServerRelativeUrl"];
                 [self getInspectorPhotoByServerRelativeUrl:serverRelativeUrl inspectionId:inspectionId incidentId:incidentId roomId:roomId photoId:photoId tryTimes:0];
             }
         });
         
     }];
}

-(void)getInspectorPhotoByServerRelativeUrl:(NSString *)serverRelativeUrl inspectionId:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId photoId:(NSString *)photoId tryTimes:(NSInteger)tryTimes
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFileByServerRelativeUrl('%@%@",self.siteUrl,serverRelativeUrl,@"')/$value"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.token];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([EKNEKNGlobalInfo requestSuccess:response]) {
                UIImage *image =[[UIImage alloc] initWithData:data];
                if(image != nil)
                {
                    if([self.roomInspectionPhotoDic objectForKey:incidentId] != nil && [[self.roomInspectionPhotoDic objectForKey:incidentId] objectForKey:@"photos"] != nil)
                    {
                        [[[self.roomInspectionPhotoDic objectForKey:incidentId] objectForKey:@"photos"] addObject:image];
                    }
                    else
                    {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        NSMutableArray *photos = [[NSMutableArray alloc] init];
                        [photos addObject:image];
                        [dic setObject:photos forKey:@"photos"];
                        [self.roomInspectionPhotoDic setObject:dic forKey:incidentId];
                    }
                    [self.inspectorCommentCollection reloadData];
                }
            }
            else
            {
                if(tryTimes < 3)
                {
                    NSInteger times = tryTimes + 1;
                    [self getInspectorPhotoByServerRelativeUrl:serverRelativeUrl inspectionId:inspectionId incidentId:incidentId roomId:roomId photoId:photoId tryTimes:times];
                }
            }
        });
    }];
    [task resume];
}

//get selected repair photos
-(void)getRepairPhoto:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId
{
    NSString *filter = [NSString stringWithFormat:@"$select=ID,Title&$filter=sl_inspectionIDId eq %@ and sl_incidentIDId eq %@ and sl_roomIDId eq %@&$orderby=Modified desc",inspectionId,incidentId,roomId];
    NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self.client getListItemsByFilter:@"Repair Photos" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            if(listItems != nil && [listItems count] > 0)
            {
                for (EKNListItem *item in listItems) {
                    NSString *photoID = (NSString *)[item getData:@"ID"];
                    [self getRepairServerRelativeUrl:inspectionId incidentId:incidentId roomId:roomId photoId:photoID];
                }
            }
        });
    }];
}

-(void)getRepairServerRelativeUrl:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId photoId:(NSString *)photoId
{
    [self.client getListItemFileByFilter:@"Repair Photos"
                                  FileId:photoId
                                  filter:@"$select=ServerRelativeUrl"
                                callback:^(NSMutableArray *listItems, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if(listItems != nil && [listItems count] > 0)
             {
                 NSString *serverRelativeUrl = (NSString *)[listItems[0] getData:@"ServerRelativeUrl"];
                 [self getRepairPhotoByServerRelativeUrl:serverRelativeUrl inspectionId:inspectionId incidentId:incidentId roomId:roomId photoId:photoId tryTimes:0];
             }
         });
         
     }];
}

-(void)getRepairPhotoByServerRelativeUrl:(NSString *)serverRelativeUrl inspectionId:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId photoId:(NSString *)photoId tryTimes:(NSInteger)tryTimes
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFileByServerRelativeUrl('%@%@",self.siteUrl,serverRelativeUrl,@"')/$value"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.token];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([EKNEKNGlobalInfo requestSuccess:response]) {
                UIImage *image =[[UIImage alloc] initWithData:data];
                if(image != nil)
                {
                    if([self.repairPhotoDic objectForKey:incidentId] != nil && [[self.repairPhotoDic objectForKey:incidentId] objectForKey:@"photos"] != nil)
                    {
                        [[[self.repairPhotoDic objectForKey:incidentId] objectForKey:@"photos"] addObject:image];
                    }
                    else
                    {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        NSMutableArray *photos = [[NSMutableArray alloc] init];
                        [photos addObject:image];
                        [dic setObject:photos forKey:@"photos"];
                        [self.repairPhotoDic setObject:dic forKey:incidentId];
                    }
                    [self.commentCollection reloadData];
                }
            }
            else
            {
                if(tryTimes < 3)
                {
                    NSInteger times = tryTimes + 1;
                    [self getRepairPhotoByServerRelativeUrl:serverRelativeUrl inspectionId:inspectionId incidentId:incidentId roomId:roomId photoId:photoId tryTimes:times];
                }
            }
        });
    }];
    [task resume];
}

-(void)didUpdateRightTableCell:(NSIndexPath *)indexpath image:(UIImage*)image
{
    [self.rightTableView beginUpdates];
    [self.rightTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [self.rightTableView endUpdates];
}

-(EKNListClient*)getClient{
    return [[EKNListClient alloc] initWithUrl:self.siteUrl
                                        token: self.token];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.rightTableView)
    {
        if(self.incidentListArray != nil)
        {
            return [self.incidentListArray count];
        }
        else
        {
            return 0;
        }
    }
    else if(tableView == self.propertyDetailTableView)
    {
        if(self.propertyDetailDic != nil)
        {
            return 3;
        }
        else
        {
            return 0;
        }
    }
    else if(tableView == self.contactOwnerTableView ||
            tableView == self.contactOfficeTableView )
    {
        if(self.propertyDetailDic != nil)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else if(tableView == self.detailInspectionDetailTableView)
    {
        if(self.inspectionDetailDic != nil)
        {
            return [self.inspectionDetailDic count];
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.rightTableView)
    {
        return 160;
    }
    else if(tableView == self.propertyDetailTableView)
    {
        if(indexPath.row == 2)
        {
            return 225;
        }
        else
        {
            return 42;
        }
    }
    else if(tableView == self.contactOwnerTableView ||
            tableView == self.contactOfficeTableView ||
            tableView == self.detailInspectionDetailTableView)
    {
        return 42;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.rightTableView)
    {
        return 60;
    }
    else if(tableView == self.contactOfficeTableView ||
            tableView == self.contactOwnerTableView ||
            tableView == self.detailInspectionDetailTableView)
    {
        return 0;
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.rightTableView)
    {
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:24];
        NSString *lbl1str = @"INCIDENTS";
        UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 620, 60)];
        lbl1.text = lbl1str;
        lbl1.textAlignment = NSTextAlignmentLeft;
        lbl1.font = font;
        lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
        return lbl1;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.rightTableView)
    {
        NSString *identifier = @"IncidentListItemCell";
        IncidentListItemCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"IncidentListItemCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [self setRightTableCell:cell cellForRowAtIndexPath:indexPath];
        return cell;
    }
    else if(tableView == self.contactOwnerTableView ||
            tableView == self.contactOfficeTableView )
    {
        NSString *identifier = @"ContactOwnerCell";
        ContactOwnerCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ContactOwnerCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        if(tableView == self.contactOfficeTableView )
        {
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [cell setCellValue: [standardUserDefaults objectForKey:@"dispatcherEmail"]];
        }
        else
        {
            NSString *contactOwner = [EKNEKNGlobalInfo getString:[self.propertyDetailDic objectForKey:@"sl_emailaddress"]];
            if(contactOwner != nil)
            {
                [cell setCellValue:contactOwner];
            }
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(tableView == self.propertyDetailTableView ||
            tableView == self.detailInspectionDetailTableView)
    {
        if(tableView == self.propertyDetailTableView)
        {
            
            if(indexPath.row==2)
            {
                NSString *identifier = @"PropertyDetailsImage";
                PropertyDetailsImage *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    [tableView registerNib:[UINib nibWithNibName:@"PropertyDetailsImage" bundle:nil] forCellReuseIdentifier:identifier];
                    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                }
                NSString *address = [EKNEKNGlobalInfo getString:[self.propertyDetailDic objectForKey:@"sl_address1"]];
                UIImage *image =(UIImage *)[self.propertyDetailDic objectForKey:@"photo"];
                [cell setCellValue:image title:address];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else
            {
                NSString *identifier = @"PropertyDetailsCell";
                PropertyDetailsCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    [tableView registerNib:[UINib nibWithNibName:@"PropertyDetailsCell" bundle:nil] forCellReuseIdentifier:identifier];
                    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                }
                if (indexPath.row == 0) {
                    NSString *title = [EKNEKNGlobalInfo getString:[self.propertyDetailDic objectForKey:@"Title"]];
                    [cell setCellValue:[UIImage imageNamed:@"home"] title:title];
                }
                else
                {
                    NSString *title = [EKNEKNGlobalInfo getString:[self.propertyDetailDic objectForKey:@"sl_owner"]];
                    [cell setCellValue:[UIImage imageNamed:@"man"] title:title];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
        else
        {
            NSString *identifier = @"InspectionDetailsCell";
            PropertyDetailsCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"PropertyDetailsCell" bundle:nil] forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            if (indexPath.row == 0) {
                NSString *name = [EKNEKNGlobalInfo getString:[self.inspectionDetailDic objectForKey:@"name"]];
                [cell setCellValue:[UIImage imageNamed:@"man"] title:name];
            }
            else if(indexPath.row == 1)
            {
                NSString *email = [EKNEKNGlobalInfo getString:[self.inspectionDetailDic objectForKey:@"email"]];
                [cell setCellValue:[UIImage imageNamed:@"email"] title:email textColor:[UIColor colorWithRed:76.00f/255.00f green:161.00f/255.00f blue:255.00f/255.00f alpha:1.0]];
            }
            else
            {
                NSString *date = [self.inspectionDetailDic objectForKey:@"date"];
                NSString *dateStr = [EKNEKNGlobalInfo converStringToDateString:date];
                [cell setCellValue:[UIImage imageNamed:@"calendar"] title:dateStr];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.rightTableView)
    {
        [self setRightTableSelectIndex:indexPath];
    }
    else if(tableView == self.contactOwnerTableView ||
            tableView == self.contactOfficeTableView)
    {
        ContactOwnerCell *cell =(ContactOwnerCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString *address = cell.emailLable.text;
        [self showSendEmailViewController:address];
    }
    else if(tableView == self.detailInspectionDetailTableView)
    {
        if(indexPath.row == 1)
        {
            PropertyDetailsCell *cell = (PropertyDetailsCell *)[tableView cellForRowAtIndexPath:indexPath];
            NSString *address = cell.propertyTitle.text;
            [self showSendEmailViewController:address];
        }
    }
}

-(void)setRightTableCell:(IncidentListItemCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EKNListItem *incidentItem = nil;
    incidentItem = [self.incidentListArray objectAtIndex:indexPath.row];
    
    NSString *incidentID = (NSString *)[incidentItem getData:@"ID"];
    NSDictionary *propertyData = (NSDictionary *)[incidentItem getData:@"sl_propertyID"];
    NSDictionary *inspectionData = (NSDictionary *)[incidentItem getData:@"sl_inspectionID"];
    NSDictionary *roomData = (NSDictionary *)[incidentItem getData:@"sl_roomID"];
    
    if(propertyData != nil && inspectionData != nil && roomData != nil)
    {
        NSString *room = [EKNEKNGlobalInfo getString:(NSString *)[roomData objectForKey:@"Title"]];
        NSString *incident = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"Title"]];
        NSString *inspectionDate = [EKNEKNGlobalInfo converStringToDateString:(NSString *)[inspectionData objectForKey:@"sl_datetime"]];
        NSString *repairDate = [EKNEKNGlobalInfo converStringToDateString:(NSString *)[inspectionData objectForKey:@"sl_finalized"]];
        NSString *approved = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"sl_status"]];
        BOOL repariDateHidden = [EKNEKNGlobalInfo isBlankString:repairDate];
        BOOL approvedHidden = [EKNEKNGlobalInfo isBlankString:approved];
        UIImage *image = nil;
        NSMutableDictionary *dic = [self.incidentPhotoListDic objectForKey:incidentID];
        if(dic != nil)
        {
            image =(UIImage *)[dic objectForKey:@"photo"];
        }
        [cell setCellValue:image room:room incident:incident inspectionDate:inspectionDate repairDate:repairDate repairHidden:repariDateHidden approved:approved approvedHidden:approvedHidden];
    }
}

-(void)updateRightTableCell:(NSIndexPath *)indexpath
{
    [self.rightTableView beginUpdates];
    [self.rightTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [self.rightTableView endUpdates];
}

//collection view
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.inspectorCommentCollection)//inspector collection view
    {
        if([self.roomInspectionPhotoDic objectForKey:self.selectIncidentId] != nil && [[self.roomInspectionPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"] != nil)
        {
            return [[[self.roomInspectionPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"] count];
        }
        else
        {
            return 0;
        }
    }
    else if(collectionView == self.commentCollection)//comment image collection view
    {
        if([self.repairPhotoDic objectForKey:self.selectIncidentId] != nil && [[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"] != nil)
        {
            return [[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"] count];
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image;
    if(collectionView == self.inspectorCommentCollection)
    {
        NSMutableArray *imageArray = (NSMutableArray *)[[self.roomInspectionPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"];
        image = imageArray[indexPath.row];
    }
    else
    {
        NSMutableArray *imageArray = (NSMutableArray *)[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"];
        image = imageArray[indexPath.row];
    }
    [self showLargePhoto:image];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID= @"cvCell";
    EKNCollectionViewCell *cell = (EKNCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    if(collectionView == self.inspectorCommentCollection)
    {
        NSMutableArray *imageArray = (NSMutableArray *)[[self.roomInspectionPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"];
        UIImage *image = imageArray[indexPath.row];
        CGFloat width = image.size.width;
        CGFloat heigth = image.size.height;
        if(heigth > 116)
        {
            width = width / (heigth / 116);
            heigth = 116;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, heigth)];
        imageView.image = image;
        [cell addSubview:imageView];
    }
    else
    {
        NSMutableArray *imageArray = (NSMutableArray *)[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"];
        UIImage *image = imageArray[indexPath.row];
        CGFloat width = image.size.width;
        CGFloat heigth = image.size.height;
        if(heigth > 116)
        {
            width = width / (heigth / 116);
            heigth = 116;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, heigth)];
        imageView.image = image;
        [cell addSubview:imageView];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image;
    if(collectionView == self.inspectorCommentCollection)
    {
        NSMutableArray *imageArray = (NSMutableArray *)[[self.roomInspectionPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"];
        image = imageArray[indexPath.row];
    }
    else
    {
        NSMutableArray *imageArray = (NSMutableArray *)[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"];
        image = imageArray[indexPath.row];
    }
    CGFloat width = image.size.width;
    CGFloat heigth = image.size.height;
    if(heigth > 116)
    {
        width = width / (heigth / 116);
        heigth = 116;
    }
    return CGSizeMake(width, heigth);
}



//picker view
-(void) takeCameraAction
{
    if(self.canEditComments)
    {
        [self takePhoto];
    }
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
                 otherButtonTitles: @"Select Photo", @"New Photo",nil];
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
    if(buttonIndex == 1 && self.cameraIsAvailable)//take new photo
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self openCamera];
        }];
    }
    else if(buttonIndex == 0)//select photo library
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
    CGFloat width = chosenImage.size.width;
    CGFloat heigth = chosenImage.size.height;
    if(heigth > 116)
    {
        width = width / (heigth / 116);
        heigth = 116;
    }
    UIImage *thumb = [self shrinkImage:chosenImage toSize:CGSizeMake(width, heigth)];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self showLoading];
    [self.client uploadImageToRepairPhotos:self.token image:thumb inspectionId:self.selectInspectionId incidentId:self.selectIncidentId roomId:self.selectRoomId callback:^(NSError *error) {
        [self hideLoading];
        if(error != nil)
        {
            [self showErrorMessage:@"Upload image failed."];
        }
        else
        {
            if([self.repairPhotoDic objectForKey:self.selectIncidentId] != nil && [[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"] != nil)
            {
                [[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"] addObject:thumb];
            }
            else
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                NSMutableArray *photos = [[NSMutableArray alloc] init];
                [photos addObject:thumb];
                [dic setObject:photos forKey:@"photos"];
                [self.repairPhotoDic setObject:dic forKey:self.selectIncidentId];
            }
            [self.commentCollection reloadData];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end

//
//  EKNPropertyDetailsViewController.m
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//
#import "EKNPropertyDetailsViewController.h"
#import "EKNExchange.h"


@interface EKNPropertyDetailsViewController ()

@end

@implementation EKNPropertyDetailsViewController

-(void)setDataExternal:(NSString *)pid loginName:(NSString *)loginName token:(NSString *)token emailtoken:(NSString *)exchangetoken
{
    if (pid!=nil) {
        self.selectRightPropertyItemId = pid;//for test
    }
    else
    {
        self.selectRightPropertyItemId = @"1";//for test
    }
    
    self.loginName = loginName;//for test
    self.token = token;
    self.exchangetoken = exchangetoken;
    [self addSubViews];
}
-(void)initData
{
    self.selectLetInspectionIndexPath = nil;
    self.selectLetRoomIndexPath = nil;
    self.selectRightPropertyTableIndexPath = nil;
    
    self.listClient = [self getClient];
    self.commentViewImages = [[NSMutableArray alloc] init];
    
    self.commentItemId = nil;
    self.incidentTypeArray = nil;;
    self.mailController = nil;
    
    self.propertyDic = [[NSMutableDictionary alloc] init];
}

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
}
-(void)addSubViews
{
    [self initData];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor=[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1];
    
    UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusbar.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(130.00/255.00f) blue:(114.00/255.00f) alpha:1.0];
    [self.view addSubview:statusbar];
    
    UIImageView *header_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 1024, 71)];
    header_img.image = [UIImage imageNamed:@"navigation_background"];
    [self.view addSubview:header_img];
    
    [self addLetView];
    UIImageView *seperatorline = [[UIImageView alloc] initWithFrame:CGRectMake(344, 91, 5, 677)];
    seperatorline.image = [UIImage imageNamed:@"sepratorline"];
    [self.view addSubview:seperatorline];
    
    [self addRightView];
    [self addCommentPopupView];
    [self addSpinner];
    [self loadPropertyData];
}
#pragma mark - Left view
-(void)addLetView
{
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 91, 344, 677)];
    leftview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftview];
    [self addLeftPropertyDetailTable];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag=LeftBackButtonViewTag;
    [backBtn setFrame:CGRectMake(0, 350, 15, 71)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"before"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.hidden = YES;
    [self.view addSubview:backBtn];
    [self addLeftSlideView];
}
-(void)addLeftSlideView
{
    UIView *slideView = [[UIView alloc] initWithFrame:CGRectMake(24, 405, 320, 657)];
    slideView.tag = LefSliderViewTag;
    slideView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:slideView];
    
    [self addLeftSegementControl:slideView];
    [self addLeftInspectionsTable:slideView];
    [self addLeftRoomTable:slideView];
    [self addLeftFinalizeBtn:slideView];
}
-(void)addLeftSegementControl:(UIView *)slideView
{
    //1st sge
    UIImageView * bkimg =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 316, 54)];
    [bkimg setImage:[UIImage imageNamed:@"seg"]];
    [bkimg setUserInteractionEnabled:YES];
    [slideView addSubview:bkimg];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.tag = LefPropertySegLeftBtnTag;
    [left setFrame:CGRectMake(0, 0, 105, 54)];
    [left addTarget:self action:@selector(leftSegButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bkimg addSubview:left];
    
    UIButton *mid = [UIButton buttonWithType:UIButtonTypeCustom];
    mid.tag = LefPropertySegMidBtnTag;
    [mid setFrame:CGRectMake(105, 0, 105, 54)];
    [mid addTarget:self action:@selector(midSegButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bkimg addSubview:mid];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.tag = LefPropertySegRightBtnTag;
    [right setFrame:CGRectMake(210, 0, 106, 54)];
    [right addTarget:self action:@selector(rightSegButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bkimg addSubview:right];
    
    //2nd seg
    UIImageView * bkimg1 =[[UIImageView alloc] initWithFrame:CGRectMake(0, 310, 316, 54)];
    [bkimg1 setImage:[UIImage imageNamed:@"seg2"]];
    [bkimg1 setUserInteractionEnabled:YES];
    bkimg1.tag = LeftRoomSegViewTag;
    bkimg1.hidden= YES;
    [slideView addSubview:bkimg1];
    
    UIButton *left1 = [UIButton buttonWithType:UIButtonTypeCustom];
    left1.tag = LefRoomSegLeftBtnTag;
    [left1 setFrame:CGRectMake(0, 0, 105, 54)];
    [left1 addTarget:self action:@selector(leftSegButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bkimg1 addSubview:left1];
    
    UIButton *mid1 = [UIButton buttonWithType:UIButtonTypeCustom];
    mid1.tag = LefRoomSegMidBtnTag;
    [mid1 setFrame:CGRectMake(105,0, 105, 54)];
    [mid1 addTarget:self action:@selector(midSegButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bkimg1 addSubview:mid1];
    
    UIButton *right1 = [UIButton buttonWithType:UIButtonTypeCustom];
    right1.tag = LefRoomSegRightBtnTag;
    [right1 setFrame:CGRectMake(210, 0, 106, 54)];
    [right1 addTarget:self action:@selector(rightSegButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bkimg1 addSubview:right1];

}
-(void)addLeftInspectionsTable:(UIView *)slideView
{
    UITableView *inspectionLeftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, 320, 235) style:UITableViewStyleGrouped];
    inspectionLeftTableView.tag = LeftInspectionLeftTableViewTag;
    inspectionLeftTableView.backgroundColor = [UIColor whiteColor];
    inspectionLeftTableView.delegate = self;
    inspectionLeftTableView.dataSource = self;
    [inspectionLeftTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    NSString *lbl1str = @"INSPECTIONS";
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    lbl1.text = lbl1str;
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = font;
    lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    inspectionLeftTableView.tableHeaderView = lbl1;
    [inspectionLeftTableView registerNib:[UINib nibWithNibName:@"InspectionListCell" bundle:nil] forCellReuseIdentifier:@"InspectionListCell"];
    [slideView addSubview:inspectionLeftTableView];
    
    UITableView *inspectionMidTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, 320, 235) style:UITableViewStyleGrouped];
    inspectionMidTableView.tag = LeftInspectionMidTableViewTag;
    inspectionMidTableView.backgroundColor = [UIColor whiteColor];
    inspectionMidTableView.delegate = self;
    inspectionMidTableView.dataSource = self;
    [inspectionMidTableView setScrollEnabled:NO];
    
    NSString *lbl2str = @"CONTACT OFFICE";
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    lbl2.text = lbl2str;
    lbl2.textAlignment = NSTextAlignmentLeft;
    lbl2.font = font;
    lbl2.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    inspectionMidTableView.tableHeaderView = lbl2;
    [inspectionMidTableView registerNib:[UINib nibWithNibName:@"ContactOwnerCell" bundle:nil] forCellReuseIdentifier:@"ContactOwnerCell"];
    [slideView addSubview:inspectionMidTableView];
    inspectionMidTableView.hidden = YES;
    
    UITableView *inspectionRightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, 320, 235) style:UITableViewStyleGrouped];
    inspectionRightTableView.tag = LeftInspectionRightTableViewTag;
    inspectionRightTableView.backgroundColor = [UIColor whiteColor];
    inspectionRightTableView.delegate = self;
    inspectionRightTableView.dataSource = self;
    [inspectionRightTableView setScrollEnabled:NO];
    
    NSString *lbl3str = @"CONTACT OWNER";
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    lbl3.text = lbl3str;
    lbl3.textAlignment = NSTextAlignmentLeft;
    lbl3.font = font;
    lbl3.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    inspectionRightTableView.tableHeaderView = lbl3;
    [inspectionRightTableView registerNib:[UINib nibWithNibName:@"ContactOwnerCell" bundle:nil] forCellReuseIdentifier:@"ContactOwnerCell"];
    [slideView addSubview:inspectionRightTableView];
    inspectionRightTableView.hidden = YES;
}
-(void)addLeftRoomTable:(UIView *)slideView
{
    UITableView *roomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 365, 320, 175) style:UITableViewStyleGrouped];
    roomTableView.tag = LeftRoomTableViewTag;
    roomTableView.backgroundColor = [UIColor whiteColor];
    roomTableView.delegate = self;
    roomTableView.dataSource = self;
    [roomTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    NSString *lbl1str = @"ROOMS";
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    lbl1.text = lbl1str;
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = font;
    lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    roomTableView.tableHeaderView = lbl1;
    [roomTableView registerNib:[UINib nibWithNibName:@"RoomListCell" bundle:nil] forCellReuseIdentifier:@"RoomListCell"];
    [slideView addSubview:roomTableView];
}
-(void)addLeftFinalizeBtn:(UIView *)slideView
{
    UIButton *finalizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    finalizeBtn.tag = LeftFinalizeBtnTag;
    [finalizeBtn setFrame:CGRectMake(0, 550, 316, 33)];
    [finalizeBtn setBackgroundImage:[UIImage imageNamed:@"finalize"] forState:UIControlStateNormal];
    [finalizeBtn addTarget:self action:@selector(finalizeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    finalizeBtn.hidden =  YES;
    [slideView addSubview:finalizeBtn];
    
}
-(void)addLeftPropertyDetailTable{
    
    UITableView *propertyDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(25, 100, 315, 300) style:UITableViewStyleGrouped];
    propertyDetailTableView.tag = LeftPropertyDetailTableViewTag;
    
    propertyDetailTableView.backgroundColor = [UIColor whiteColor];
    propertyDetailTableView.delegate = self;
    propertyDetailTableView.dataSource = self;
    [propertyDetailTableView setScrollEnabled:NO];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    NSString *lbl1str = @"PROPERTY DETAILS";
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 25)];
    lbl1.text = lbl1str;
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = font;
    lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    propertyDetailTableView.tableHeaderView = lbl1;

    [self.view addSubview:propertyDetailTableView];
}

#pragma mark - Right View
-(void)addRightView
{
    [self addRightPropertyTable];
    [self addRightSlideView];
}
-(void)addRightPropertyTable{
    UITableView *rightPropertyTableView = [[UITableView alloc] initWithFrame:CGRectMake(380, 100, 620, 635) style:UITableViewStyleGrouped];
    rightPropertyTableView.tag = RightPropertyDetailTableViewTag;
    
    rightPropertyTableView.backgroundColor = [UIColor clearColor];
    [rightPropertyTableView setSeparatorColor:[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1]];
    rightPropertyTableView.delegate = self;
    rightPropertyTableView.dataSource = self;
    [rightPropertyTableView.layer setCornerRadius:10.0];
    [rightPropertyTableView.layer setMasksToBounds:YES];
    [rightPropertyTableView registerNib:[UINib nibWithNibName:@"PropertyListCell" bundle:nil] forCellReuseIdentifier:@"PropertyListCell"];
    [self.view addSubview:rightPropertyTableView];
}
-(void)addRightSlideView
{
    
    UIView *rightSlideView = [[UIView alloc] initWithFrame:CGRectMake(1024, 91, 669, 677)];
    rightSlideView.backgroundColor = [UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1];
    rightSlideView.tag = RightSliderViewTag;
    [self.view addSubview:rightSlideView];
    
    UIFont *labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    UILabel *rightRoomDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 646, 46)];
    [rightRoomDateLabel setBackgroundColor:[UIColor colorWithRed:(123.00/255.00f) green:(123.00/255.00f) blue:(123.00/255.00f) alpha:1.00]];
    rightRoomDateLabel.tag = RightRoomImageDateLblTag;
    rightRoomDateLabel.textAlignment = NSTextAlignmentLeft;
    rightRoomDateLabel.font = labelFont;
    rightRoomDateLabel.textColor = [UIColor whiteColor];
    [rightSlideView addSubview:rightRoomDateLabel];
    
    
    UIImageView *rightLargePhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 46, 646, 465)];
    rightLargePhotoView.tag = RightRoomImageLargeImageTag;
    [rightSlideView addSubview:rightLargePhotoView];
    
    UIView *collectionBg = [[UIView alloc] initWithFrame:CGRectMake(0, 526, 646, 136)];
    collectionBg.backgroundColor = [UIColor colorWithRed:(225.00/255.00f) green:(225.00/255.00f) blue:(225.00/255.00f) alpha:1.00];
    [rightSlideView addSubview:collectionBg];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 536, 636, 116) collectionViewLayout:flowLayout];
    rightCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    rightCollectionView.delegate = self;
    rightCollectionView.dataSource = self;
    rightCollectionView.allowsMultipleSelection = YES;
    rightCollectionView.allowsSelection = YES;
    rightCollectionView.showsHorizontalScrollIndicator = NO;
    rightCollectionView.backgroundColor = [UIColor colorWithRed:(225.00/255.00f) green:(225.00/255.00f) blue:(225.00/255.00f) alpha:0.00];
    rightCollectionView.tag = RightRoomCollectionViewTag;
    
    [rightCollectionView registerClass:[EKNCollectionViewCell class] forCellWithReuseIdentifier:@"EKNCollectionViewCell"];
    [rightSlideView addSubview:rightCollectionView];
}
-(void)setRightLargeImage:(UIImage *)image
{
    UIImageView *largeIamgeView = (UIImageView *)[self.view viewWithTag:RightRoomImageLargeImageTag];
    [largeIamgeView setImage:image];
}
#pragma mark - spiner/comment pop up
-(void)addSpinner
{
    self.propertyViewSpinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    self.propertyViewSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.propertyViewSpinner setColor:[UIColor blackColor]];
    [self.view addSubview:self.propertyViewSpinner];
    self.propertyViewSpinner.hidesWhenStopped = YES;
    
    self.commentViewSpinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,550+91,50,50)];
    self.commentViewSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.commentViewSpinner.color = [UIColor blackColor];
    [self.view addSubview:self.commentViewSpinner];
    self.commentViewSpinner.hidesWhenStopped = YES;
    
    
}
- (void) addCommentPopupView
{
    UIView *commentPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 389)];
    commentPopupView.tag = CommentPopViewTag;
    commentPopupView.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(0.00/255.00f) blue:(0.00/255.00f) alpha:0.5];;
    
    UIButton *commentCamera = [[UIButton alloc] initWithFrame:CGRectMake(32, 30, 64, 52)];
    commentCamera.tag = CommentCameraBtnTag;
    [commentCamera setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [commentCamera addTarget:self action:@selector(cameraButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [commentPopupView addSubview:commentCamera];
    
    UIView *imgBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(106, 30, 886, 99)];
    imgBackgoundView.backgroundColor = [UIColor whiteColor];
    imgBackgoundView.layer.masksToBounds = YES;
    imgBackgoundView.layer.cornerRadius = 5;
    [commentPopupView addSubview:imgBackgoundView];
    
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
    commentCollectionView.tag = CommentCollectionViewTag;
    [commentCollectionView registerClass:[CommentCollectionViewCell class] forCellWithReuseIdentifier:@"CommentCollectionViewCell"];
    [commentPopupView addSubview:commentCollectionView];
    
    
    UIView *commentBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(106, 149, 886, 160)];
    commentBackgoundView.tag =CommentTextBackgroundViewTag;
    commentBackgoundView.backgroundColor = [UIColor whiteColor
                                            ];
    commentBackgoundView.layer.masksToBounds = YES;
    commentBackgoundView.layer.cornerRadius = 5;
    [commentPopupView addSubview:commentBackgoundView];
    
    UITextView *commentView = [[UITextView alloc] initWithFrame:CGRectMake(121, 169, 856, 120)];
    commentView.tag = CommentTextViewTag;
    commentView.delegate = self;
    [commentPopupView addSubview:commentView];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(738, 319, 112, 50)];
    cancel.tag = CommentCancelBtnTag;
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor colorWithRed:(100.00/255.00f) green:(153.00/255.00f) blue:(209.00/255.00f) alpha:1.0];
    cancel.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    cancel.titleLabel.textColor = [UIColor whiteColor];
    cancel.layer.masksToBounds = YES;
    cancel.layer.cornerRadius = 5;
    [cancel addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [commentPopupView addSubview:cancel];
    
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(880, 319, 112, 50)];
    done.tag = CommentDoneBtnTag;
    [done setTitle:@"Done" forState:UIControlStateNormal];
    done.backgroundColor = [UIColor colorWithRed:(100.00/255.00f) green:(153.00/255.00f) blue:(209.00/255.00f) alpha:1.0];
    done.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    done.titleLabel.textColor = [UIColor whiteColor];
    done.layer.masksToBounds = YES;
    done.layer.cornerRadius = 5;
    [done addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [commentPopupView addSubview:done];
    

    
    
    UIButton *dpBtn = [[UIButton alloc] initWithFrame:CGRectMake(32, 329, 376, 32)];
    dpBtn.tag = CommentDpBtnTag;
    
    dpBtn.layer.masksToBounds = YES;
    dpBtn.layer.cornerRadius = 8;
    [dpBtn setTitle:@"" forState:UIControlStateNormal];
    [dpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    dpBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    dpBtn.backgroundColor = [UIColor whiteColor];
    dpBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [dpBtn addTarget:self action:@selector(incidentTypeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *dropdownImg = [[UIImageView alloc] initWithFrame:CGRectMake(378-32, 338-329, 17, 14)];
    dropdownImg.image = [UIImage imageNamed:@"dropdown_arrow"];
    [dpBtn addSubview:dropdownImg];
    [commentPopupView addSubview:dpBtn];
    
    UIPickerView *idPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(32, 329-120-32-10, 376,120)];
    idPicker.tag = CommentPickerViewTag;
    idPicker.layer.cornerRadius = 8;
    idPicker.dataSource = self;
    idPicker.delegate = self;
    idPicker.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(0.00/255.00f) blue:(0.00/255.00f) alpha:0.8];
    idPicker.showsSelectionIndicator = YES;
    idPicker.hidden = YES;
    [commentPopupView addSubview:idPicker];
    
    commentPopupView.hidden = YES;
    [self.view addSubview:commentPopupView];
    

    
}

#pragma mark - UIAlertView/UIActionSheet/UIImagePicker/MFMailComposeViewController/MS Office exchange
//after create an new incident item, we will send a email using exchage
-(void)sendExchangeEmail:(NSString *)type comment:(NSString *)comment
{
    NSDictionary * tempdic = [self getSelectPropertyDic];
    if(tempdic!=nil)
    {
        NSString *to = [tempdic objectForKey:@"contactemail"];
        if (to!=nil) {
            NSMutableDictionary *emailDataDic = [[NSMutableDictionary alloc] init];
            
            NSString *currentDate = [EKNEKNGlobalInfo converStringFromDate:[NSDate date]];
            UITableView *propertyDetailTable = (UITableView *)[self.view viewWithTag:LeftPropertyDetailTableViewTag];
            NSString *propertyName= [((PropertyDetailsCell *)[propertyDetailTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) getLabelTitle];
            NSString *propertyAddress = [((PropertyDetailsCell *)[propertyDetailTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]) getLabelTitle];
            
            UITableView *roomTableView = (UITableView *)[self.view viewWithTag:LeftRoomTableViewTag];
            
            NSString *roomTitle= [((RoomListCell *)[roomTableView cellForRowAtIndexPath:self.selectLetRoomIndexPath]) getLabelTitle];
            
            NSMutableString *body =[[NSMutableString alloc] initWithString:@"\r\nDuring a recent inspection on your property an incident was reported. We are working to repair this incident and will email you when the incident is repaired.\r\n"];
            [body appendFormat:@"\r\n\r\nProperty Name: %@\r\nProperty Address:%@\r\n\r\nInspection Date:<%@>\r\n\r\n",propertyName,propertyAddress,currentDate];
            
            if (type==nil) {
                type=@"";
            }
            [body appendFormat:@"Incident Type:%@>r\n\r\nRoom:%@",type,roomTitle];
            if (comment==nil) {
                comment=@"";
            }
            [body appendFormat:@"\r\n\r\nDescription:\r\n\r\n%@",comment];
            [emailDataDic setObject:to forKey:@"to"];
            [emailDataDic setObject:[EKNEKNGlobalInfo getObjectFromDefault:@"dispatcherEmail"] forKey:@"cc"];
            [emailDataDic setObject:[NSString stringWithFormat:@"Inspection Report - <%@> - <%@>",propertyName,currentDate] forKey:@"subject"];
            [emailDataDic setObject:body forKey:@"body"];
            [emailDataDic setObject:self.exchangetoken forKey:@"exchangetoken"];
            
            
            EKNExchange *ex = [[EKNExchange alloc] init];
            [ex sendMailUsingExchange:emailDataDic callback:^(int returnValue, NSError *error)
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
    }
}
-(void)showSendEmailViewController:(NSString *)address
{
    UIDevice *device =[UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPad Simulator"]) {
        [self showHintAlertView:@"Hint" message:@"Simulator does not support Mail View"];
        return;
    }
    
    if(self.mailController == nil)
    {
        self.mailController = [[MFMailComposeViewController alloc] init];
        self.mailController.mailComposeDelegate = self;
    }
    NSArray *to = [NSArray arrayWithObjects:address, nil];
    
    NSString *body =@"Edkey Note Demo";
    [self.mailController setToRecipients:to];
    [self.mailController setMessageBody:body isHTML:NO];
    [self presentViewController:self.mailController animated:YES completion:NULL];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)showHintAlertView:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0 )//take new photo
    {
        BOOL cameraIsAvailable=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (cameraIsAvailable) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self openCamera];
            }];
        }
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *smallImage = [self shrinkImage:chosenImage toSize:CGSizeMake(120, 79)];
    [self.commentViewImages addObject:smallImage];
    [((UICollectionView *)[self.view viewWithTag:CommentCollectionViewTag]) reloadData];
    
   /* [self startCommentViewSpiner:CGRectMake(106+443,30+40,50,50)];
    BOOL bCommentViewShow = [self getCommentViewWhetherShow];
    BOOL beSend = NO;
    
    NSString *insid =[self getSelectLeftInspectionItemId];
    if(insid!=nil)
    {
        NSString *roomId = [self getSelectLeftRoomItemId];
        if (roomId!=nil) {
            if (bCommentViewShow) {
                beSend = YES;
                [self uploadRoomImageFileFromPopupView:smallImage inspectionId:insid roomId:roomId incidentId:nil];
            }
            else
            {
                if (self.commentItemId == nil) {
                    NSString *propertyId = self.selectRightPropertyItemId;
                    if (propertyId!=nil) {
                      beSend = YES;
                        
                      [self createIncidentItem:nil type:nil ispectionId:insid propertyId:propertyId roomId:roomId callback:
                       ^(NSString *success)
                       {
                               if(![success isEqualToString:@"YES"])
                               {
                                   [self showHintAlertView:@"ERROR" message:@"Create the incident item failed."];
                                   [self stopCommentViewSpiner];
                               }
                               else
                               {
                                    [self uploadRoomImageFileFromPopupView:smallImage inspectionId:insid roomId:roomId incidentId:self.commentItemId ];
                                   
                               }
                       }];
                    }

                }
            }
        }
    }
    if(!beSend)
    {
        [self showHintAlertView:@"ERROR" message:@"Check inspection id/ "];
        [self stopCommentViewSpiner];
    }*/
    
     [picker dismissViewControllerAnimated:YES completion:NULL];
   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return final;
}
#pragma mark - textview delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}
#pragma mark - get action
-(ListClient*)getClient{
    NSString *url =[EKNEKNGlobalInfo getObjectFromDefault:@"demoSiteCollectionUrl"];
    
    return [[ListClient alloc] initWithUrl:url
                               token: self.token];
}

-(NSInteger)getRightCollectionViewItemsCount
{
    NSString *roomId = [self getSelectLeftRoomItemId];
    if (roomId!=nil) {
        NSDictionary *roomsDic =[self.roomsOfInspectionDic objectForKey:[self getSelectLeftInspectionItemId]];
        if (roomsDic!=nil) {
            NSArray *imageArray = [roomsDic objectForKey:roomId];
            if (imageArray!=nil) {
                return [imageArray count];
            }
        }
    }

    return 0;
}
-(NSString *)getInspectionItemIcon:(NSString *)insidkey
{
    NSMutableDictionary *pic =[self.incidentOfInspectionDic objectForKey:self.selectRightPropertyItemId];
    if (pic!=nil) {
        NSMutableDictionary *insdic = [pic objectForKey:insidkey];
        if (insdic!=nil) {
            NSString *status = [insdic objectForKey:@"icon"];
            return status;
        }
    }
    return nil;
}
-(NSString *)getRoomItemIcon:(NSString *)roomid
{
    NSMutableDictionary *pic =[self.incidentOfInspectionDic objectForKey:self.selectRightPropertyItemId];
    if (pic!=nil) {
        NSMutableDictionary *insdic = [pic objectForKey:[self getSelectLeftInspectionItemId]];
        if (insdic!=nil) {
            NSString *roomicon =[insdic objectForKey:[NSString stringWithFormat:@"room%@",roomid]];
            return roomicon;
        }
    }
    return nil;
}
/*-(BOOL)getUseThisPropertyIdInList:(NSString *)pid;
{
    NSMutableArray *toparray = [self.rightPropertyListDic objectForKeyedSubscript:@"top"];
    if (toparray!=nil && [toparray count]>0) {
        ListItem *inspectionItem = [toparray objectAtIndex:0];
        NSDictionary * pp = (NSDictionary *)[inspectionItem getData:@"sl_propertyID"];
        NSString *tempId = [NSString stringWithFormat:@"%@",[pp objectForKey:@"Id"]];
        if ([tempId isEqualToString:pid]) {
            return YES;
        }
    }
    
    NSMutableArray *bottomarray = [self.rightPropertyListDic objectForKeyedSubscript:@"bottom"];
    if (bottomarray!= nil) {
        for (ListItem *templist in bottomarray) {
            NSDictionary * pp = (NSDictionary *)[templist getData:@"sl_propertyID"];
            NSString *tempId = [NSString stringWithFormat:@"%@",[pp objectForKey:@"Id"]];
            if ([tempId isEqualToString:pid]) {
                return YES;
            }
        }
    }
    return NO;
    
}*/

-(NSString *)getSelectLeftInspectionItemId
{
    UITableView *inspectionTable = (UITableView *)[self.view viewWithTag:LeftInspectionLeftTableViewTag];
    InspectionListCell *cell = (InspectionListCell *)[inspectionTable cellForRowAtIndexPath:self.selectLetInspectionIndexPath];
    if (cell!=nil) {
        NSString* insId =[NSString stringWithFormat:@"%@",[cell getItemId]];
        //NSLog(@"getSelectLeftInspectionItemId %@",insId);
        return insId;
    }
    else
    {
        /*if(self.selectRightPropertyTableIndexPath!=nil)
        {
            NSDictionary *tempdic  = [self getSelectPropertyDic];
            if(tempdic!=nil)
            {
                NSArray * inspectionlist = [tempdic objectForKey:@"inspectionslist"];
                if(inspectionlist!=nil)
                {
                    if(self.selectLetInspectionIndexPath!=nil)
                    {
                        NSDictionary *inspecdic =[inspectionlist objectAtIndex:self.selectLetInspectionIndexPath.row];
                        NSString *insId = [inspecdic objectForKey:@"ID"];
                        NSLog(@"getSelectLeftInspectionItemId %@",insId);
                        return insId;
                    }
                }
            }
        }*/
        
        NSLog(@"getSelectLeftInspectionItemId nil");
        return nil;
    }

}
-(NSString *)getSelectLeftRoomItemId
{
    if (self.selectLetRoomIndexPath!=nil) {
        NSDictionary *prodic =[self getSelectPropertyDic];
        if (prodic!=nil) {
            NSArray *roomsArray = [prodic objectForKey:@"RoomsArray"];
            NSInteger roomIdex =self.selectLetRoomIndexPath.row;
            if([roomsArray count]>=roomIdex+1)
            {
                NSDictionary *roomdic = [roomsArray objectAtIndex:roomIdex];
                NSString *roomId =[NSString stringWithFormat:@"%@",(NSString *)[roomdic objectForKey:@"Id"]];
                // NSLog(@"getSelectLeftRoomItemId %@",roomId);
                return roomId;
            }
        }

    }
   NSLog(@"roomId nil");
    return nil;
}
-(BOOL)getCommentViewWhetherShow
{
    if([self.view viewWithTag:CommentTextBackgroundViewTag].frame.origin.x == 106)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(NSMutableDictionary *)getSelectPropertyDic
{
    return [self.propertyDic objectForKey:self.selectRightPropertyItemId];
}
-(NSDictionary *)getProperyListItemDicByIndexPath:(NSIndexPath *)indexPath
{
    ListItem *inspectionItem = nil;
    if(indexPath.section == 0)
    {
        NSArray *toparray=[self.rightPropertyListDic objectForKey:@"top"];
        if(toparray!=nil && [toparray count]>0)
        {
            inspectionItem = [toparray objectAtIndex:0];
        }

    }
    else
    {
        NSArray *bottomarray=[self.rightPropertyListDic objectForKey:@"bottom"];
        if (bottomarray!=nil && [bottomarray count]>indexPath.row) {
            inspectionItem = [bottomarray objectAtIndex:indexPath.row];
        }
    }
    
    NSDictionary *pro =nil;
    if(inspectionItem!=nil)
    {
       pro = (NSDictionary *)[inspectionItem getData:@"sl_propertyID"];
    }
    return pro;
}
-(void)getInspectionListAccordingPropertyId:(NSString*)pid
{
    if([self.propertyDic objectForKey:pid] !=nil && ![[self.propertyDic objectForKey:pid] objectForKey:@"inspectionslist"])
    {
        NSMutableArray *inspectionslistTemp = [[NSMutableArray alloc] init];
        
        for (ListItem* tempitem in self.inspectionsListArray) {
            NSString *inspectionId = [NSString stringWithFormat:@"%@",[tempitem getData:@"ID"]];
            
            NSDictionary * pdic = (NSDictionary *)[tempitem getData:@"sl_propertyID"];
            NSDictionary *insdic =(NSDictionary *)[tempitem getData:@"sl_inspector"];
            
            if(pdic!=nil)
            {
                if([[pdic objectForKey:@"ID"] intValue] == [pid intValue])
                {
                    
                    NSMutableDictionary * inspectionItem= [[NSMutableDictionary alloc] init];
                    
                    [inspectionItem setObject:inspectionId forKey:@"ID"];
                    [inspectionItem setObject:[insdic objectForKey:@"Title"] forKey:@"sl_accountname"];
                    
                    
                    if ([[insdic objectForKey:@"Title"] isEqualToString:self.loginName ])
                    {
                        [inspectionItem setObject:@"YES" forKey:@"bowner"];
                    }
                    
                    NSString *final = (NSString *)[tempitem getData:@"sl_finalized"];
                    if (final == (NSString *)[NSNull null]) {
                        [inspectionItem setObject:@"YES" forKey:@"sl_finalized"];
                    }
                    
                    NSDate *inspectiondatetime = [EKNEKNGlobalInfo converDateFromString:(NSString *)[tempitem getData:@"sl_datetime"]];
                    NSString *convertDateStr =[EKNEKNGlobalInfo converStringFromDate:inspectiondatetime];
                    [inspectionItem setObject:convertDateStr forKey:@"sl_datetime"];
                    
                    if([inspectiondatetime compare:[NSDate date]] == NSOrderedDescending
                       ||[convertDateStr isEqualToString:[EKNEKNGlobalInfo converStringFromDate:[NSDate date]]])
                    {
                        //upcoming
                        [inspectionItem setObject:@"black" forKey:@"icon"];
                    }
                    else
                    {
                        NSString *icon = [self getInspectionItemIcon:inspectionId];
                        if(icon!=nil)
                        {
                            [inspectionItem setObject:@"red" forKey:@"icon"];
                        }
                        else
                        {
                            [inspectionItem setObject:@"green" forKey:@"icon"];
                        }
                        
                    }
                    
                    [inspectionslistTemp addObject:inspectionItem];
                }
            }
        }
        [[self.propertyDic objectForKey:pid] setObject:inspectionslistTemp forKey:@"inspectionslist"];
    }
}
-(NSString *)getCreateListItemId:(NSString *)location
{
    NSString *subId =nil;
    NSRange range = [location rangeOfString:@"/Items("];
    if (range.length>0) {
        NSString *substr = [location substringFromIndex:(range.location+range.length)];
        NSRange itemIdRange = [substr rangeOfString:@")"];
        if (itemIdRange.length>0) {
            subId = [substr substringToIndex:itemIdRange.location];
        }
    }
    return  subId;
}
#pragma mark - set action
-(void)disableViewAfterCommentPopUp
{
    [self.view viewWithTag:LeftRoomTableViewTag].userInteractionEnabled = NO;
    [self.view viewWithTag:RightRoomCollectionViewTag].userInteractionEnabled = NO;
    [self.view viewWithTag:LeftRoomSegViewTag].userInteractionEnabled = NO;
}
-(void)enableViewAfterCommentDismiss
{
    [self.view viewWithTag:LeftRoomTableViewTag].userInteractionEnabled = YES;
    [self.view viewWithTag:RightRoomCollectionViewTag].userInteractionEnabled = YES;
    [self.view viewWithTag:LeftRoomSegViewTag].userInteractionEnabled = YES;
}
-(void)setIncidentCommmentViewShow:(NSString *)type
{
    [self.view viewWithTag:CommentTextBackgroundViewTag].frame =CGRectMake(32, 149, 960, 160);
    [self.view viewWithTag:CommentTextViewTag].frame =CGRectMake(52, 169, 920, 120);
    [self.view viewWithTag:CommentPopViewTag].hidden = NO;
    [self.view viewWithTag:CommentDpBtnTag].hidden = NO;
    [self.view viewWithTag:CommentPickerViewTag].hidden = YES;
    
        
    if(type!=nil && type != (NSString *)[NSNull null])
    {
       [(UIButton *)[self.view viewWithTag:CommentDpBtnTag] setTitle:type forState:UIControlStateNormal];
        
        NSInteger index = [self.incidentTypeArray indexOfObject:type];
        [(UIPickerView *)[self.view viewWithTag:CommentPickerViewTag] selectRow:index inComponent:0 animated:NO];
    }
    else
    {
         [(UIButton *)[self.view viewWithTag:CommentDpBtnTag] setTitle:@"" forState:UIControlStateNormal];
       // [(UIPickerView *)[self.view viewWithTag:CommentPickerViewTag] selectRow:0 inComponent:0 animated:NO];
    }

}
-(void)setCommmentViewShow
{
    [self.view viewWithTag:CommentTextBackgroundViewTag].frame =CGRectMake(106, 149, 886, 160);
    [self.view viewWithTag:CommentTextViewTag].frame =CGRectMake(121, 169, 856, 120);
    [self.view viewWithTag:CommentPopViewTag].hidden = NO;
    [self.view viewWithTag:CommentDpBtnTag].hidden = YES;
    [self.view viewWithTag:CommentPickerViewTag].hidden = YES;
}
-(void)startPropertyViewSpiner:(CGRect)rect
{
    [self.propertyViewSpinner stopAnimating];
    self.propertyViewSpinner.frame = rect;
    [self.propertyViewSpinner startAnimating];
}
-(void)stopPropertyViewSpiner
{
    [self.propertyViewSpinner stopAnimating];
}

-(void)startCommentViewSpiner:(CGRect)rect
{
    [self.commentViewSpinner stopAnimating];
    self.commentViewSpinner.frame = rect;
    [self.commentViewSpinner startAnimating];
    //NSLog(@"commentViewSpinner start");
}
-(void)stopCommentViewSpiner
{
    [self.commentViewSpinner stopAnimating];
   // NSLog(@"commentViewSpinner stop");
}
#pragma mark - button action
-(void)backButtonClicked
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view viewWithTag:LefSliderViewTag].frame = CGRectMake(24, 405,  320, 657);
        [self.view viewWithTag:LeftRoomSegViewTag].hidden = YES;
        [self.view viewWithTag:LeftBackButtonViewTag].hidden = YES;
        self.selectRightCollectionIndexPath = nil;
        self.selectLetRoomIndexPath = nil;
        
        [self stopCommentViewSpiner];
        [self stopPropertyViewSpiner];
    }
                     completion:^(BOOL finished){
                         if(finished)
                         {
                             [UIView animateWithDuration:0.3 animations:
                              ^{
                                  [self.view viewWithTag:RightSliderViewTag].frame=CGRectMake(1024, 91, 669, 677);
                              }
                                              completion:^(BOOL finished){
                                              }];
                         }
                     }];
    
}
-(void)leftSegButtonClicked:(id)sender
{
    if(((UIButton *)sender).tag == LefPropertySegLeftBtnTag)
    {
        UITableView * inspectionLeftTableView = (UITableView *)[self.view viewWithTag:LeftInspectionLeftTableViewTag];
        UITableView * inspectionMidTableView = (UITableView *)[self.view viewWithTag:LeftInspectionMidTableViewTag];
        UITableView * inspectionRightTableView = (UITableView *)[self.view viewWithTag:LeftInspectionRightTableViewTag];
        if(inspectionLeftTableView.hidden == YES)
        {
            inspectionLeftTableView.hidden =NO;
            inspectionMidTableView.hidden = YES;
            inspectionRightTableView.hidden = YES;
        }
    }
    else
    {
        //room
    }

}

-(void)midSegButtonClicked:(id)sender
{
    if(((UIButton *)sender).tag == LefPropertySegMidBtnTag)
    {
        UITableView * inspectionLeftTableView = (UITableView *)[self.view viewWithTag:LeftInspectionLeftTableViewTag];
        UITableView * inspectionMidTableView = (UITableView *)[self.view viewWithTag:LeftInspectionMidTableViewTag];
        UITableView * inspectionRightTableView = (UITableView *)[self.view viewWithTag:LeftInspectionRightTableViewTag];
        if(inspectionMidTableView.hidden == YES)
        {
            inspectionLeftTableView.hidden =YES;
            inspectionMidTableView.hidden = NO;
            inspectionRightTableView.hidden = YES;
        }
    }
    else
    {
        if(self.selectLetRoomIndexPath==nil)
        {
            return;
        }
        [self.commentViewImages removeAllObjects];
        [((UICollectionView *)[self.view viewWithTag:CommentCollectionViewTag]) reloadData];
        [self disableViewAfterCommentPopUp];
        
        [self startCommentViewSpiner:CGRectMake(129+50,330+91,50,50)];
        
        NSString *insIdstr = [self getSelectLeftInspectionItemId];
        if (insIdstr!=nil) {
            NSString *roomIdstr = [self getSelectLeftRoomItemId];
            NSMutableString *filterStr = [[NSMutableString alloc] initWithFormat:@"$select=Title,ID&$filter=sl_inspectionIDId%%20eq%%20%@%%20and%%20sl_roomIDId%%20eq%%20%@&$top=1",insIdstr,roomIdstr];
            
        [self.listClient getListItemsByFilter:@"Inspection Comments" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if (error==nil) {
                                                  NSString *text = nil;
                                                  if([listItems count]>0)
                                                  {
                                                      
                                                      self.commentItemId =[NSString stringWithFormat:@"%@",(NSString *)[[listItems objectAtIndex:0] getData:@"Id"]];
                                                      text = (NSString *)[[listItems objectAtIndex:0] getData:@"Title"];
                                                      if(text!=nil && text != (NSString *)[NSNull null])
                                                      {
                                                          ((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text = text;
                                                      }
                                                     
                                                  }
                                                  else
                                                  {
                                                      //can't find, we need creat a new item
                                                      self.commentItemId = nil;
                                                      ((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text = @"";
                                                  }
                                                  
                                                  [self setCommmentViewShow];
                                              }
                                              else
                                              {
                                                  //query failed
                                                  [self showHintAlertView:@"ERROR" message:@"Query inspection comments list failed."];
                                                  [self enableViewAfterCommentDismiss];
                                              }
                                              [self stopCommentViewSpiner];
                                              
                                          });
                                      }];
        }
        
    }

}

-(void)rightSegButtonClicked:(id)sender
{
    if(((UIButton *)sender).tag == LefPropertySegRightBtnTag)
    {
        UITableView * inspectionLeftTableView = (UITableView *)[self.view viewWithTag:LeftInspectionLeftTableViewTag];
        UITableView * inspectionMidTableView = (UITableView *)[self.view viewWithTag:LeftInspectionMidTableViewTag];
        UITableView * inspectionRightTableView = (UITableView *)[self.view viewWithTag:LeftInspectionRightTableViewTag];
        if(inspectionRightTableView.hidden == YES)
        {
            inspectionLeftTableView.hidden =YES;
            inspectionMidTableView.hidden = YES;
            inspectionRightTableView.hidden = NO;
        }
    }
    else
    {
        if(self.selectLetRoomIndexPath==nil)
        {
            return;
        }
        
        //incent comment view
        [self.commentViewImages removeAllObjects];
        [((UICollectionView *)[self.view viewWithTag:CommentCollectionViewTag]) reloadData];
        [self disableViewAfterCommentPopUp];
        [self startCommentViewSpiner:CGRectMake(129+50,330+91,50,50)];
        
        if(self.incidentTypeArray == nil)
        {
            [self.listClient getFieldValue:@"Incidents" field:@"Type" propertyName:@"Choices" callback:^(NSMutableArray *listItems, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     BOOL bsuccess = false;
                     if(error== nil)
                     {
                         if(listItems!=nil && [listItems count]>0)
                         {
                             NSDictionary *choiceDict = [[listItems objectAtIndex:0] objectForKey:@"Choices"];
                             if (choiceDict!=nil) {
                                 bsuccess = true;
                                 self.incidentTypeArray = [choiceDict objectForKey:@"results"];
                                 [(UIPickerView *)[self.view viewWithTag:CommentPickerViewTag] reloadComponent:0];
                                 [self getIncidentComment];
                             }
                         }
                     }
                     if (!bsuccess) {
                         [self showHintAlertView:@"ERROR" message:@"Querty Incident type field fail."];
                         [self stopCommentViewSpiner];
                         [self enableViewAfterCommentDismiss];
                         
                     }

                 });
             }];
        }
        else
        {
            [self getIncidentComment];
        }
    }
}

-(void)finalizeButtonClicked:(id)sender
{
    //here finalize
    //cloris need add finalize action;
    if(![self.commentViewSpinner isAnimating])
    {
        [self startCommentViewSpiner:CGRectMake(135,550+91,50,50)];
        NSString *insid = [self getSelectLeftInspectionItemId];
        NSString *body = [NSString stringWithFormat:@"{'__metadata': { 'type': 'SP.Data.InspectionsListItem' }, 'sl_finalized':'%@'}",[NSDate date]];
    
        [self.listClient updateListItem:@"Inspections" itemID:insid body:body callback: ^(
                                                                                                         NSData *data,
                                                                                                         NSURLResponse *response, NSError *error)
         {
              dispatch_async(dispatch_get_main_queue(), ^{
                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                  
                  if(error!=nil
                     ||[httpResponse statusCode] == 400)
                  {
                      [self showHintAlertView:@"ERROR" message:@"Create the item failed."];
                      [self stopCommentViewSpiner];
                  }
                  else
                  {
                      //success.
                      if (self.selectLetInspectionIndexPath!=nil) {
                          NSMutableArray *inspectionList = [[self getSelectPropertyDic] objectForKey:@"inspectionslist"];
                          NSMutableDictionary *insDic = [inspectionList objectAtIndex:self.selectLetInspectionIndexPath.row];
                          [insDic removeObjectForKey:@"sl_finalized"];
                          
                          InspectionListCell *cell = (InspectionListCell *)[(UITableView *)[self.view viewWithTag:LeftInspectionLeftTableViewTag] cellForRowAtIndexPath:self.selectLetInspectionIndexPath];
                          [cell changeFinalValue:NO];
                          
                           [self.view viewWithTag:LeftFinalizeBtnTag].hidden = YES;
                      }
                      [self showHintAlertView:@"" message:@"Finalize Successfully."];
                      [self stopCommentViewSpiner];
                  }
                  
              });
         
         }];
    }
    
}
-(void)cameraButtonClicked
{
    if([self.commentViewSpinner isAnimating])
        return;
    //here we click the commerabutton
    BOOL cameraIsAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    UIActionSheet *sheet;;
    if (cameraIsAvailable) {
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
-(void)cancelButtonClicked
{
    [self.view viewWithTag:CommentPopViewTag].hidden = YES;
    [self enableViewAfterCommentDismiss];
    [(UITextView *)[self.view viewWithTag:CommentTextViewTag] resignFirstResponder];
}
-(void)doneButtonClicked
{
    //here, first we create the incident item, then upload images that are taken by camera.
    if ([self getCommentViewWhetherShow]) {
        [self commentViewDone];
    }
    else
    {
        [self incidentCommentViewDone];
    }

}
-(void)incidentTypeButtonClicked
{
    UIPickerView * pickerview =(UIPickerView *)[self.view viewWithTag:CommentPickerViewTag];
    if(pickerview.hidden)
    {
        pickerview.hidden = NO;
    }
    else
    {
        pickerview.hidden = YES;
    }
}
#pragma mark - read/update/create sharepoint list item using REST
-(void)loadPropertyData{
    [self startPropertyViewSpiner:CGRectMake(380+250,140+300,50,50)];
    
   [self.listClient getListItemsByFilter:@"Inspections" filter:@"$select=ID,sl_datetime,sl_finalized,sl_inspector/ID,sl_inspector/Title,sl_inspector/sl_accountname,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_emailaddress&$expand=sl_inspector,sl_propertyID&$orderby=sl_datetime%20desc" callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(nil!=listItems && [listItems count]>0)
            {
                NSMutableArray *upcomingList = [[NSMutableArray alloc] init];
                NSMutableArray *currentList = [[NSMutableArray alloc] init];
                self.inspectionsListArray =listItems;
                
                for(ListItem* tempitem in listItems)
                {
                    /*NSDictionary * pdic = (NSDictionary *)[tempitem getData:@"sl_propertyID"];
                     EKNPropertyData* pdata = nil;
                     EKNInspectorData *indata = nil;
                     if(pdic!=nil)
                     {
                     pdata = [[EKNPropertyData alloc] init];
                     [pdata initParameter:(NSString *)[pdic objectForKey:@"ID"]
                     Title:(NSString *)[pdic objectForKey:@"Title"]
                     Owner:(NSString *)[pdic objectForKey:@"sl_owner"]
                     Adress1:(NSString *)[pdic objectForKey:@"sl_address1"]
                     Adress2:(NSString *)[pdic objectForKey:@"sl_address2"]
                     City:(NSString *)[pdic objectForKey:@"sl_city"]
                     State:(NSString *)[pdic objectForKey:@"sl_state"]
                     PostalCode:(NSString *)[pdic objectForKey:@"sl_postalCode"]];
                     }
                     NSDictionary * indic = (NSDictionary *)[tempitem getData:@"sl_inspector"];
                     if(indic!=nil)
                     {
                     indata = [[EKNInspectorData alloc] init];
                     [indata initParameter:(NSString *)[indic objectForKey:@"ID"]
                     InspectorTitle:(NSString *)[indic objectForKey:@"Title"]
                     InspectorAccountName:(NSString *)[indic objectForKey:@"sl_accountname"]
                     InspectorEmailAdress:(NSString *)[indic objectForKey:@"sl_emailaddress"]];
                     }
                     EKNInspectionData * inspectionItem = [[EKNInspectionData alloc] init];
                     [inspectionItem initParameter:(NSString *)[tempitem getData:@"ID"]
                     InspectionTitle:(NSString *)[tempitem getData:@"Title"]
                     InspectionDateTime:(NSString *)[tempitem getData:@"sl_datetime"]
                     InspectorData:indata
                     PropertyData:pdata];*/
                    BOOL bAdded = NO;
                    NSDictionary * pdic = (NSDictionary *)[tempitem getData:@"sl_propertyID"];
                    NSString *pid=[NSString stringWithFormat:@"%@",[pdic objectForKey:@"ID"]];
                    NSString *tempdatetime =(NSString *)[tempitem getData:@"sl_datetime"];
                    
                    if(pdic!=nil)
                    {
                        if([pid intValue] == [self.selectRightPropertyItemId intValue]
                          /* && [EKNEKNGlobalInfo isEqualTodayDate:tempdatetime]*/)
                        {
                            BOOL bexist =NO;
                            for (ListItem * tt in currentList) {
                                NSDictionary * pp = (NSDictionary *)[tt getData:@"sl_propertyID"];
                                if ([pp objectForKey:@"Id"] == [pdic objectForKey:@"Id"]) {
                                    bexist = YES;
                                    break;
                                }
                            }
                            if (!bexist) {
                                bAdded = YES;
                                [currentList addObject:tempitem];
                            }
                        }
                        //here we need to add the upcoming list even it has exsit in current section
                        {
                            NSDate *inspectiondatetime = [EKNEKNGlobalInfo converDateFromString:tempdatetime];
                            if([inspectiondatetime compare:[NSDate date]] == NSOrderedDescending)
                            {
                                BOOL bexist =NO;
                                for (ListItem * tt in upcomingList) {
                                    NSDictionary * pp = (NSDictionary *)[tt getData:@"sl_propertyID"];
                                    if ([pp objectForKey:@"Id"] == [pdic objectForKey:@"Id"]) {
                                        bexist = YES;
                                        break;
                                    }
                                }
                                if (!bexist) {
                                    bAdded = YES;
                                    [upcomingList addObject:tempitem];
                                }
                            }
                        }
                        if(bAdded && [self.propertyDic objectForKey:[NSString stringWithFormat:@"%@",pid]]==nil)
                        {
                            NSMutableDictionary *propertyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSMutableArray alloc] init],@"RoomsArray", nil];
                            [self.propertyDic setObject:propertyDic forKey:[NSString stringWithFormat:@"%@",pid]];
                        }
                    }
                }
                //get the right pannel data
                self.rightPropertyListDic = [[NSMutableDictionary alloc] init];
                [self.rightPropertyListDic setObject:currentList forKey:@"top"];
                [self.rightPropertyListDic setObject:upcomingList forKey:@"bottom"];
                
                [self getRoomsList];
            }
            else
            {
                [self showHintAlertView:@"ERROR" message:@"Read Inspection list item failed."];
                [self stopPropertyViewSpiner];
            }
        });
    }];
}

-(void)getRoomsList
{
    [self.listClient getListItemsByFilter:@"Rooms" filter:@"$select=sl_propertyIDId,Id,Title" callback:^(NSMutableArray * listItems, NSError *error)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (error==nil) {
                                                             for (ListItem *listitem in listItems) {
                                                                 NSString *pidStr = [NSString stringWithFormat:@"%@",[listitem getData:@"sl_propertyIDId"]];
                                                                 if (pidStr != (NSString *)[NSNull null]&& [self.propertyDic objectForKey:pidStr]!=nil) {
                                                                     NSMutableDictionary *roomDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[listitem getData:@"Id"]],@"Id",[listitem getData:@"Title"],@"Title", nil];
                                                                     
                                                                     [[[self.propertyDic objectForKey:pidStr] objectForKey:@"RoomsArray"]addObject:roomDic];
                                                                 }

                                                             }
                                                             //get property resource list:
                                                             [self getPropertyResourceList];
                                                             
                                                         }
                                                     });
                                                 }];
}
-(void)getPropertyResourceList
{
    __block int loopindex = 0;
    NSArray *loopitems =[self.propertyDic allKeys];
    for (NSString *pid in loopitems)
    {
       [self.listClient getListItemsByFilter:@"Property Photos" filter:[NSString stringWithFormat:@"$select=sl_propertyIDId,Id&$filter=sl_propertyIDId%%20eq%%20%@&$top=1",pid] callback:^(NSMutableArray * listItems, NSError *error)
                                                     {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             //self.propertyResourceListArray =listItems;
                                                             if(error==nil)
                                                             {
                                                                 loopindex++;
                                                                 
                                                                 if(listItems!=nil && [listItems count]>0)
                                                                 {
                                                                     ListItem *tempitem = [listItems objectAtIndex:0];
                                                                     NSString *propertyId =[NSString stringWithFormat:@"%@",[tempitem getData:@"sl_propertyIDId"]];
                                                                     NSString *propertyImageId =[NSString stringWithFormat:@"%@",[tempitem getData:@"ID"]];
                                                                     
                                                                     if ([self.propertyDic objectForKey:propertyId]!=nil) {
                                                                         [[self.propertyDic objectForKey:propertyId] setObject:propertyImageId forKey:@"imageID"];
                                                                     }
                                                                 }
                                                                 
                                                                 if(loopindex == [loopitems count])
                                                                 {
                                                                     [self getPropertyResourceFile];
                                                                     
                                                                 }
                                                                // NSLog(@"getPropertyResourceList loopindex %d",loopindex);
                                                                 
                                                             }
                                                             

                                                             


                                                             
                                                         });
                                                     }];
    }
}

-(void)getPropertyResourceFile
{
    __block int loopindex = 0;
    NSArray *loopitems =[self.propertyDic allKeys];
    
    for (NSString *pid in loopitems)
    {
       [self.listClient getListItemFileByFilter:@"Property Photos"
                                                        FileId:(NSString *)[[self.propertyDic objectForKey:pid] objectForKey:@"imageID"]
                                                        filter:@"$select=ServerRelativeUrl"
                                                        callback:^(NSMutableArray *listItems, NSError *error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            loopindex++;
                                                         
                            if([listItems count]>0)
                            {
                                NSMutableDictionary *propertyData =[self.propertyDic objectForKey:pid];
                                
                                [propertyData setObject:[[listItems objectAtIndex:0] getData:@"ServerRelativeUrl"] forKey:@"ServerRelativeUrl"];
                            }
                            
                            if(loopindex == [loopitems count])
                            {
                                    //get Incidents list
                                    [self getIncidentsListArray];
                                                        
                            }
                           // NSLog(@"loopindex %d",loopindex);
                        });
                                                     
                    }];
    }
}
-(void)getIncidentsListArray
{
    self.incidentOfInspectionDic = [[NSMutableDictionary alloc] init];
    //self.incidentOfRoomsDic = [[NSMutableDictionary alloc] init];
    [self.listClient getListItemsByFilter:@"Incidents" filter:@"$select=sl_propertyIDId,sl_inspectionIDId,sl_roomIDId,Id"  callback:^(NSMutableArray *        listItems, NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (ListItem* tempitem in listItems) {
                    if ([tempitem getData:@"sl_propertyIDId"] == [NSNull null]
                        ||[tempitem getData:@"sl_inspectionIDId"] ==[NSNull null]) {
                        continue;
                    }
                    NSString *pid = [NSString stringWithFormat:@"%@",[tempitem getData:@"sl_propertyIDId"]];
                    NSString *insid =[NSString stringWithFormat:@"%@",[tempitem getData:@"sl_inspectionIDId"]];
                    
                    if ([self.propertyDic objectForKey:pid]!=nil) {
                        NSMutableDictionary *prodic = [self.incidentOfInspectionDic objectForKey:pid];
                        if(prodic == nil)
                        {
                            prodic  =[[NSMutableDictionary alloc] init];
                            [self.incidentOfInspectionDic setObject:prodic forKey:pid];
                        }
                        NSMutableDictionary *insdic =[prodic objectForKey:insid];
                        if (insdic ==nil) {
                            insdic  =[[NSMutableDictionary alloc] init];
                            [prodic setObject:insdic forKey:insid];
                        }
                        NSString *inspectionStatus = [insdic objectForKey:@"icon"];
                        if(inspectionStatus == nil)
                        {
                            [insdic setObject:@"red" forKey:@"icon"];
                        }
                       
                        
                        if ([tempitem getData:@"sl_roomIDId"] == [NSNull null]) {
                            continue;
                        }
                        
                         NSString *roomId =[NSString stringWithFormat:@"room%@",[tempitem getData:@"sl_roomIDId"]];
                        
                         NSString *roomFlag = [insdic objectForKey:roomId];
                         if (roomFlag==nil) {
                            [insdic setObject:@"YES" forKey:roomId];
                        }
                        
                    }
                }
                [self InitRightPropertyTable];
                //get All property images
                [self getAllPropertyImageFiles];
                
                [self stopPropertyViewSpiner];
            });
        }];
}

-(void)getAllPropertyImageFiles
{
    NSArray *prokeys = [self.propertyDic allKeys];
    for (NSString *key in prokeys) {
        [self getPropertyImageFile:key];
    }
}

-(void)getPropertyImageFile:(NSString *)key
{
    NSMutableDictionary *prodict = [self.propertyDic objectForKey:key];
    NSString *path =[prodict objectForKey:@"ServerRelativeUrl"];
    
    [self.listClient getFileValueByPath:path callback:^(NSData *data,NSURLResponse *response,NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"cloris get image erro is %@",error);
             if (error == nil) {
                 NSLog(@"data length %lu",(unsigned long)[data length]);
                 UIImage *image =[[UIImage alloc] initWithData:data];
                 [[self.propertyDic objectForKey:key] setObject:image
                                                         forKey:@"image"];
                 [self updateRightPropertyTableCellImage:key image:image];
             }
             else
             {
                 //retry one
                 if([[self.propertyDic objectForKey:key] objectForKey:@"trytimes"]!=nil)
                 {
                     NSInteger times =[[[self.propertyDic objectForKey:key] objectForKey:@"trytimes"] integerValue];
                     if(times>=3)
                     {
                         
                     }
                     else
                     {
                         times=times+1;
                         [[self.propertyDic objectForKey:key] setObject:[NSString stringWithFormat:@"%ld",(long)times] forKey:@"trytimes"];
                         [self getPropertyImageFile:key];
                     }
                 }
                 else
                 {
                     [[self.propertyDic objectForKey:key] setObject:@"1" forKey:@"trytimes"];
                     [self getPropertyImageFile:key];
                 }
             }
         });
     }];
}

//Room
-(void)getRoomInspectionPhotosList{
    [self startPropertyViewSpiner:CGRectMake(135,460,50,50)];
   // ((UIButton *)[self.view viewWithTag:LeftBackButtonViewTag]).enabled = NO;
    
    ListClient* client = self.listClient;
    self.roomsOfInspectionDic = [[NSMutableDictionary alloc] init];
    [client getListItemsByFilter:@"Room Inspection Photos" filter:@"$select=Id,sl_inspectionIDId,sl_roomIDId"
                                                     callback:^(NSMutableArray *listItems, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (ListItem *temp in listItems) {
                    if([temp getData:@"sl_inspectionIDId"] == [NSNull null] || [temp getData:@"sl_roomIDId"] == [NSNull null] )
                    {
                        continue;
                    }
                    
                    NSString *insId =[NSString stringWithFormat:@"%@",[temp getData:@"sl_inspectionIDId"]];
                    NSString *roomId =[NSString stringWithFormat:@"%@",[temp getData:@"sl_roomIDId"]];

                    NSMutableDictionary *roomsDic= [self.roomsOfInspectionDic objectForKey:insId];
                    if(roomsDic ==nil)
                    {
                        roomsDic = [[NSMutableDictionary alloc] init];
                        [self.roomsOfInspectionDic setObject:roomsDic forKey:insId];
                    }
                    
                    NSMutableArray * imageArray = [roomsDic objectForKey:roomId];
                    if (imageArray==nil) {
                        imageArray= [[NSMutableArray alloc] init];
                        [roomsDic setObject:imageArray forKey:roomId];
                    }
                    
                    NSString *fileId = [NSString stringWithFormat:@"%@",[temp getData:@"Id"]];
                    if(fileId!=nil)
                    {
                        NSMutableDictionary *imagesDic = [[NSMutableDictionary alloc] init];
                        [imagesDic setObject:fileId forKey:@"Id"];
                        [imageArray addObject:imagesDic];
                    }
                }
                

                [self stopPropertyViewSpiner];
                [(UITableView *)[self.view viewWithTag:LeftRoomTableViewTag] reloadData];
                [self didSelectLeftRoomTableItem:[NSIndexPath indexPathForRow:0 inSection:0] refresh:YES];
                //((UIButton *)[self.view viewWithTag:LeftBackButtonViewTag]).enabled = YES;
            });
            
        }];
}
-(void)getRoomImageFileREST:(NSString *)path
                 propertyId:(NSInteger)proId
               inspectionId:(NSInteger)insid
                  roomId:(NSInteger)roomId
                 imageIndex:(NSInteger)imageIndex
{
    [self.listClient getFileValueByPath:path callback:^(NSData *data,NSURLResponse *response,NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"cloris get room image erro %@",error);
             if (error == nil) {
                 NSLog(@"data length %lu",(unsigned long)[data length]);
                 UIImage *image =[[UIImage alloc] initWithData:data];
                 NSMutableArray *imageArray = [[self.roomsOfInspectionDic objectForKey:[NSString stringWithFormat:@"%ld",(long)insid]] objectForKey:[NSString stringWithFormat:@"%ld",(long)roomId]];
                 
                 if([imageArray count]>= imageIndex+1)
                 {
                     NSMutableDictionary *imagDic = [imageArray objectAtIndex:imageIndex];
                     [imagDic setObject:image forKey:@"image"];
                     
                     NSString *currentInsId =[self getSelectLeftInspectionItemId];
                     if (proId == [self.selectRightPropertyItemId intValue]
                         && currentInsId!=nil && insid == [currentInsId intValue]
                         &&self.selectLetRoomIndexPath!=nil && roomId == [[self getSelectLeftRoomItemId] intValue]) {
                         //NSLog(@"update the collection view");
                         //update collection cell
                         UICollectionView *clviw =(UICollectionView *)[self.view viewWithTag:RightRoomCollectionViewTag];
                         EKNCollectionViewCell *cell = (EKNCollectionViewCell *)[clviw cellForItemAtIndexPath:[NSIndexPath indexPathForRow:imageIndex inSection:0]];
                         if (cell.selected) {
                             [self setRightLargeImage:image];
                         }
                         [clviw reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:imageIndex inSection:0], nil]];
                         
                     }
                 }
                 
             }
             else
             {
                 //retry one
                 NSMutableDictionary *imagDic = [[[self.roomsOfInspectionDic objectForKey:[NSString stringWithFormat:@"%ld",(long)(long)insid]] objectForKey:[NSString stringWithFormat:@"%ld",(long)roomId]] objectAtIndex:imageIndex];
                 
                 if([imagDic objectForKey:@"trytimes"]!=nil)
                 {
                     NSInteger times =[[imagDic objectForKey:@"trytimes"] integerValue];
                     if(times>=3)
                     {
                         
                         [self stopPropertyViewSpiner];
                     }
                     else
                     {
                         times=times+1;
                         [imagDic setObject:[NSString stringWithFormat:@"%ld",(long)times] forKey:@"trytimes"];
                         [self getRoomImageFileREST:path propertyId:proId inspectionId:insid roomId:roomId imageIndex:imageIndex];
                     }
                 }
                 else
                 {
                     [imagDic setObject:@"1" forKey:@"trytimes"];
                     [self getRoomImageFileREST:path propertyId:proId inspectionId:insid roomId:roomId imageIndex:imageIndex];
                 }
             }
         });
     }];
}
-(void)getIncidentComment
{
    NSString *propertyId = self.selectRightPropertyItemId;
    NSString *insIdstr = [self getSelectLeftInspectionItemId];
    NSString *roomIdstr = [self getSelectLeftRoomItemId];
    if (propertyId!=nil && insIdstr!=nil&&roomIdstr!=nil) {
        NSMutableString *filterStr = [[NSMutableString alloc] initWithFormat:@"$select=sl_inspectorIncidentComments,ID,sl_type&$filter=sl_propertyIDId%%20eq%%20%@%%20and%%20sl_inspectionIDId%%20eq%%20%@%%20and%%20sl_roomIDId%%20eq%%20%@&$top=1",propertyId,insIdstr,roomIdstr];
        
        [self.listClient getListItemsByFilter:@"Incidents" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (error==nil) {
                                              NSString *text =nil ;
                                              NSString *type=nil;
                                              if([listItems count]>0)
                                              {
                                                  self.commentItemId =[NSString stringWithFormat:@"%@",(NSString *)[[listItems objectAtIndex:0] getData:@"Id"]];
                                                  text = (NSString *)[[listItems objectAtIndex:0] getData:@"sl_inspectorIncidentComments"];
                                                  
                                                  //if type is null??
                                                  type =(NSString *)[[listItems objectAtIndex:0] getData:@"sl_type"] ;
                                                  if(text != (NSString *)[NSNull null])
                                                  {
                                                      ((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text = text;
                                                  }
                                              }
                                              else
                                              {
                                                  
                                                  self.commentItemId = nil;
                                                  ((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text = @"";
                                              }
                                              [self setIncidentCommmentViewShow:type];
                                              [self stopCommentViewSpiner];
                                              

                                          }
                                          else
                                          {
                                              //query failed
                                              [self showHintAlertView:@"ERROR" message:@"Query inspection comments list failed."];
                                              [self enableViewAfterCommentDismiss];
                                              [self stopCommentViewSpiner];
                                          }
                                      });
                                  }];
        
    }
    else
    {
        [self showHintAlertView:@"ERROR" message:@"Check propertyId/inspectionId/RoomId failed."];
        [self enableViewAfterCommentDismiss];
        [self stopCommentViewSpiner];
    }
}
-(void)uploadRoomImages:(NSString *)insid roomId:(NSString *)rId incidentId:(NSString *)incidentId callback:(void (^)(NSString *info,BOOL success))callback
{
    __block int loopIndex = 0;
    // NSMutableString* loopindex = [[NSMutableString alloc] initWithString:@"0"];
    
    
    
    for (UIImage *image in self.commentViewImages) {
        [self uploadRoomImageFileFromPopupView:image
                                  inspectionId:insid
                                        roomId:rId
                                    incidentId:incidentId
                                      callback:^(NSString *info,BOOL success)
         {
             loopIndex++;
             if (!success) {
                 callback(info,NO);
             }
             else
             {
                 //uplod collectionview
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UICollectionView * collectionView = (UICollectionView *)[self.view viewWithTag:RightRoomCollectionViewTag];
                     [collectionView reloadData];
                     self.selectRightCollectionIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                     [collectionView selectItemAtIndexPath:self.selectRightCollectionIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                 });
                 
                 if(loopIndex >= [self.commentViewImages count])
                 {
                     callback(nil,YES);
                 }
                 
             }
             
             
         }];
    }
        

}
-(void)createCommentListItem:(NSString *)insid roomId:(NSString *)rId  callback:(void (^)(NSString *info,BOOL success))callback
{
    NSMutableString *body =[[NSMutableString alloc] init];
    [body appendFormat:@"{'__metadata': { 'type': 'SP.Data.InspectionCommentsListItem' }, 'sl_inspectionIDId':%d,'sl_roomIDId':%d",[insid intValue],[rId intValue]];
    if(((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text.length>0)
    {
        [body appendFormat:@",'Title':'%@'",((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text];
    }
    else
    {
        [body appendString:@",'Title':null"];
    }
    [body appendString:@"}"];
    [self.listClient createListItem:@"Inspection Comments" body:body callback:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         //NSLog(@"response %@ .\r\n",response);
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if(error!=nil
            ||[httpResponse statusCode] != 201)
         {
             //[self showHintAlertView:@"ERROR" message:@"Create the item failed."];
             //[self stopCommentViewSpiner];
             callback(@"Create the item failed.",NO);
         }
         else
         {
             //success.
             //[self showHintAlertView:@"Hint" message:@"Create the item successfully."];
             //[self stopCommentViewSpiner];
             //[self cancelButtonClicked];
             callback(nil,YES);
         }
     }];
}

-(void)updateCommentListItem:(void (^)(NSString *info,BOOL success))callback
{
    NSMutableString *body = [[NSMutableString alloc] initWithString:@"{'__metadata': { 'type': 'SP.Data.InspectionCommentsListItem' }" ];
    if(((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text.length>0)
    {
        [body appendFormat:@",'Title':'%@'",((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text];
    }
    else
    {
        [body appendString:@",'Title':null"];
    }
    [body appendString:@"}"];
    
    [self.listClient updateListItem:@"Inspection Comments" itemID:self.commentItemId body:body
                           callback: ^(NSData *data,NSURLResponse *response, NSError *error)
     {
        // NSLog(@"response %@ .\r\n",response);
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if(error !=nil || [httpResponse statusCode] == 400)
         {
             // [self showHintAlertView:@"ERROR" message:@"Update the item failed."];
             //[self stopCommentViewSpiner];
             callback(@"Update the item failed.",NO);
         }
         else{
             //[self showHintAlertView:@"Hint" message:@"Update the item successfully."];
             //[self stopCommentViewSpiner];
             //[self cancelButtonClicked];
             callback(nil,YES);
         }
     }];

}
-(void)commentViewDone
{
    NSString *insIdstr = [self getSelectLeftInspectionItemId];
    NSString *roomIdstr = [self getSelectLeftRoomItemId];
    if (insIdstr!=nil && roomIdstr!=nil) {
        [self startCommentViewSpiner:CGRectMake(640,219,50,50)];
        if (self.commentItemId == nil) {
            [self createCommentListItem:insIdstr roomId:roomIdstr callback:^(NSString *info,BOOL success)
             {
                     if (success) {
                         if ([self.commentViewImages count]>0) {
                             //here we need check whether we need upload images
                             [self uploadRoomImages:insIdstr
                                             roomId:roomIdstr
                                         incidentId:self.commentItemId
                                           callback:^(NSString *info,BOOL success)
                              {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                  if (success) {
                                      [self showHintAlertView:@"Hint" message:@"Create Inspection Comments list item and upload images successfully."];
                                      [self stopCommentViewSpiner];
                                      [self cancelButtonClicked];
                                  }
                                  else
                                  {
                                      [self showHintAlertView:@"ERROR" message:info];
                                      [self stopCommentViewSpiner];
                                  }
                                });
                                  
                              }];
                                                 
                         }
                         else
                         {
                             dispatch_async(dispatch_get_main_queue(), ^{
                             [self showHintAlertView:@"Hint" message:@"Create Inspection Comments list item successfully."];
                             [self stopCommentViewSpiner];
                             [self cancelButtonClicked];
                             });
                         }
                     }
                     else
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self showHintAlertView:@"ERROR" message:info];
                             [self stopCommentViewSpiner];
                        });
                     }
                 
             }];
        }
        else
        {
            [self updateCommentListItem:^(NSString *info,BOOL success)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (success) {
                         if ([self.commentViewImages count]>0) {
                             //here we need check whether we need upload images
                             [self uploadRoomImages:insIdstr
                                             roomId:roomIdstr
                                         incidentId:self.commentItemId
                                           callback:^(NSString *info,BOOL success)
                              {
                                  if (success) {
                                      [self showHintAlertView:@"Hint" message:@"Update Inspection Comments list item and upload images successfully."];
                                      [self stopCommentViewSpiner];
                                      [self cancelButtonClicked];
                                  }
                                  else
                                  {
                                      [self showHintAlertView:@"ERROR" message:info];
                                      [self stopCommentViewSpiner];
                                  }
                                  
                              }];
                         }
                         else
                         {
                             [self showHintAlertView:@"Hint" message:@"Update Inspection Comments list item successfully."];
                             [self stopCommentViewSpiner];
                             [self cancelButtonClicked];
                         }
                     }
                     else
                     {
                         [self showHintAlertView:@"ERROR" message:info];
                         [self stopCommentViewSpiner];
                     }
                 });
             }];
        }
    }
    else
    {
        [self showHintAlertView:@"ERROR" message:@"InspectionId/RoomId is null"];
    }

}
-(void)incidentCommentViewDone
{
    NSString *proId = self.selectRightPropertyItemId;
    NSString *insid = [self getSelectLeftInspectionItemId];
    NSString *roomId =[self getSelectLeftRoomItemId];
    NSString *comment =((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text;
    NSString *type = [(UIButton *)[self.view viewWithTag:CommentDpBtnTag] currentTitle];
    
    if (proId!=nil && insid!=nil && roomId!=nil) {
        [self startCommentViewSpiner:CGRectMake(640,219,50,50)];
        if (self.commentItemId == nil) {
            //create incident Here
            [self createIncidentItem:comment type:type ispectionId:insid propertyId:proId roomId:roomId callback:^(NSString *success)
             {
                 if(![success isEqualToString:@"YES"])
                 {
                     [self showHintAlertView:@"Hint" message:@"Create incident item failed."];
                 }
                 else
                 {
                     //success create, then upload images
                     if ([self.commentViewImages count]>0) {
                         //here we need check whether we need upload images
                         [self uploadRoomImages:insid
                                         roomId:roomId
                                     incidentId:self.commentItemId
                                       callback:^(NSString *info,BOOL success)
                          {
                              dispatch_async(dispatch_get_main_queue(), ^{
                              if (success) {
                                  [self sendExchangeEmail:type comment:comment];
                                  [self showHintAlertView:@"Hint" message:@"Create incident item and upload images successfully."];
                                  [self stopCommentViewSpiner];
                                  [self cancelButtonClicked];
                              }
                              else
                              {
                                  [self showHintAlertView:@"ERROR" message:info];
                                  [self stopCommentViewSpiner];
                              }
                              });
                              
                          }];
                     }
                     else
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self showHintAlertView:@"Hint" message:@"Create incident item successfully."];
                             [self stopCommentViewSpiner];
                             [self cancelButtonClicked];
                             
                         });
                         

                     }
                 }
                 
            }];
        }
        else
        {
            //update here
            [self updateIncidentCommentListItem:comment type:type callback:^(NSString *success)
             {
                 if(![success isEqualToString:@"YES"])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [self showHintAlertView:@"Hint" message:@"Update incident item failed."];
                     });
                     
                 }
                 else
                 {
                     //success create, then upload images
                     if ([self.commentViewImages count]>0) {
                         //here we need check whether we need upload images
                         [self uploadRoomImages:insid
                                         roomId:roomId
                                     incidentId:self.commentItemId
                                       callback:^(NSString *info,BOOL success)
                          {
                              dispatch_async(dispatch_get_main_queue(), ^{
                              if (success) {
                                  [self showHintAlertView:@"Hint" message:@"Update incident item and upload images successfully."];
                                  [self stopCommentViewSpiner];
                                  [self cancelButtonClicked];
                              }
                              else
                              {
                                  [self showHintAlertView:@"ERROR" message:info];
                                  [self stopCommentViewSpiner];
                              }
                              });
                              
                          }];
                     }
                     else
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                         [self showHintAlertView:@"Hint" message:@"Update incident item successfully."];
                         [self stopCommentViewSpiner];
                         [self cancelButtonClicked];
                         });
                     }
                 }
                 
             }];
        }
    }
    else
    {
        [self showHintAlertView:@"ERROR" message:@"InspectionId/RoomId is null"];
    }
}

-(void)updateIncidentCommentListItem:(NSString *)comment type:(NSString *)type callback:(void (^)(NSString *success))callback
{
        NSMutableString *body =[[NSMutableString alloc] init];
        [body appendString:@"{'__metadata': { 'type': 'SP.Data.IncidentsListItem' }"];
        
        if(comment.length>0)
        {
            [body appendFormat:@",'sl_inspectorIncidentComments':'%@'",comment];
        }
        else
        {
            [body appendString:@",'sl_inspectorIncidentComments':null"];
        }
        if(type!=nil && type.length >0)
        {
            [body appendFormat:@",'sl_type':'%@'",type];
        }
        else
        {
            [body appendString:@",'sl_type':null"];
        }
        [body appendString:@"}"];
       // NSLog(@"body %@",body);
        
        [self.listClient updateListItem:@"Incidents" itemID:self.commentItemId body:body
                               callback: ^(NSData *data,NSURLResponse *response, NSError *error)
         {
             //NSLog(@"response %@ .\r\n",response);
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             if(error !=nil || [httpResponse statusCode] == 400)
             {
                 callback(@"NO");
             }
             else{
                 callback(@"YES");
             }
         }];
}
-(void)uploadRoomImageFileFromPopupView:(UIImage *)smallImage
                           inspectionId:(NSString *)insid
                           roomId:(NSString *)rId
                           incidentId:(NSString *)incidentId
                           callback:(void (^)(NSString *info,BOOL success))callback
{
    
    NSString *imagename =[EKNEKNGlobalInfo createFileName:@".jpg"];
    [self.listClient uploadImage:smallImage libraryName:@"RoomInspectionPhotos" imageName:imagename
                        callback: ^(NSData *data,NSURLResponse *response, NSError *error)
     {
         if(error!=nil)
         {
             callback(@"Upload image file failed.",NO);
         }
         else
         {
             [self.listClient getFileItemIDByFileName:@"RoomInspectionPhotos" imageName:imagename callback: ^(NSMutableArray *listItems, NSError *error)
              {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if(error==nil && [listItems count]>0) {
                          NSDictionary *temp =(NSDictionary *)[listItems objectAtIndex:0];
                          NSString *fileId = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Id"]];
                          
                          
                          NSMutableString *body =[[NSMutableString alloc] init];
                          [body appendFormat:@"{'__metadata': { 'type': 'SP.Data.RoomInspectionPhotosItem' }, 'sl_inspectionIDId':%d,'sl_roomIDId':%d",[[self getSelectLeftInspectionItemId] intValue],[[self getSelectLeftRoomItemId] intValue]];
                          if (![self getCommentViewWhetherShow]&&self.commentItemId!=nil) {
                              [body appendFormat:@",'sl_incidentIDId':%d",[self.commentItemId intValue]];
                          }
                          [body appendString:@"}"];
                          [self.listClient updateListItem:@"Room Inspection Photos" itemID:fileId body:body callback:^(NSData *data, NSURLResponse *response, NSError *error)
                           {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   if(error!=nil
                                      ||[httpResponse statusCode] == 400)
                                   {
                                       callback(@"Update image item failed.",NO);
                                   }
                                   else
                                   {
                                       NSMutableDictionary *insdic = [self.roomsOfInspectionDic objectForKey:insid];
                                       if (insdic == nil) {
                                           insdic = [[NSMutableDictionary alloc] init];
                                           [self.roomsOfInspectionDic setObject:insdic forKey:insid];
                                       }
                                       NSMutableArray *roomArray =[insdic objectForKey:rId];
                                       if (roomArray==nil) {
                                           roomArray = [[NSMutableArray alloc] init];
                                           [insdic  setObject:roomArray forKey:rId];
                                       }
                                       NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] init];
                                       [imageDic setObject:fileId forKey:@"Id"];
                                       [imageDic setObject:imagename forKey:@"ServerRelativeUrl"];
                                       [imageDic setObject:smallImage forKey:@"image"];
                                       
                                       [roomArray addObject:imageDic];
                                       
                                       callback(nil,YES);
                                   }
                               });
                           }];
                      }
                      else
                      {
                          callback(@"Get image file ID failed.",NO);
                      }
                  });
              }];
             
         }
         
     }];
}
         /*dispatch_async(dispatch_get_main_queue(), ^{
             if (error!=nil) {
                 callback(@"Upload image file failed.",NO);
             }
             [self.listClient getFileItemIDByFileName:@"RoomInspectionPhotos" imageName:imagename callback: ^(NSMutableArray *listItems, NSError *error)
              {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if(error==nil && [listItems count]>0)
                      {
                          NSDictionary *temp =(NSDictionary *)[listItems objectAtIndex:0];
                          NSString *fileId = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Id"]];
                          
                          
                          NSMutableString *body =[[NSMutableString alloc] init];
                          [body appendFormat:@"{'__metadata': { 'type': 'SP.Data.RoomInspectionPhotosItem' }, 'sl_inspectionIDId':%d,'sl_roomIDId':%d",[[self getSelectLeftInspectionItemId] intValue],[[self getSelectLeftRoomItemId] intValue]];
                          if (![self getCommentViewWhetherShow]&&self.commentItemId!=nil) {
                              [body appendFormat:@",'sl_incidentIDId':%d",[self.commentItemId intValue]];
                          }
                          [body appendString:@"}"];
                          
                          [self.listClient updateListItem:@"Room Inspection Photos" itemID:fileId body:body callback:^(NSData *data, NSURLResponse *response, NSError *error)
                           {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   
                                   if(error!=nil
                                      ||[httpResponse statusCode] == 400)
                                   {
                                       [self stopCommentViewSpiner];
                                       [self showHintAlertView:@"ERROR" message:@"Update image item failed."];
                                   }
                                   else
                                   {
                                       [self.commentViewImages addObject:smallImage];
                                       [((UICollectionView *)[self.view viewWithTag:CommentCollectionViewTag]) reloadData];
                                       //update right collection view
                                       NSString *insId =[self getSelectLeftInspectionItemId];
                                       NSString *roomId =[self getSelectLeftRoomItemId];
                                       NSMutableDictionary *insdic = [self.roomsOfInspectionDic objectForKey:insId];
                                       if (insdic == nil) {
                                           insdic = [[NSMutableDictionary alloc] init];
                                           [self.roomsOfInspectionDic setObject:insdic forKey:insId];
                                       }
                                       NSMutableArray *roomArray =[insdic objectForKey:roomId];
                                       if (roomArray==nil) {
                                           roomArray = [[NSMutableArray alloc] init];
                                           [insdic  setObject:roomArray forKey:roomId];
                                       }
                                       NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] init];
                                       [imageDic setObject:fileId forKey:@"Id"];
                                       [imageDic setObject:imagename forKey:@"ServerRelativeUrl"];
                                       [imageDic setObject:smallImage forKey:@"image"];
                                       
                                       [roomArray addObject:imageDic];
                                       UICollectionView * collectionView = (UICollectionView *)[self.view viewWithTag:RightRoomCollectionViewTag];
                                       [collectionView reloadData];
                                       self.selectRightCollectionIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                       [collectionView selectItemAtIndexPath:self.selectRightCollectionIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                                       
                                       
                                       [self stopCommentViewSpiner];
                                       [self showHintAlertView:@"Hint" message:@"Update image item successfully."];
                                   }
                                   
                                   
                               });
                           }];
                          
                          
                      }
                      else
                      {
                          [self stopCommentViewSpiner];
                          [self showHintAlertView:@"ERROR" message:@"Get image file ID failed."];
                      }
                  });*/
-(void)createIncidentItem:(NSString *)comment type:(NSString *)type ispectionId:(NSString *)insIdstr propertyId:(NSString *)proId roomId:(NSString *)roomIdstr callback:(void (^)(NSString *success))callback
{
    
    NSMutableString *body =[[NSMutableString alloc] init];
    [body appendFormat:@"{'__metadata': { 'type': 'SP.Data.IncidentsListItem' }, 'sl_inspectionIDId':%d,'sl_roomIDId':%d,'sl_date':'%@','sl_propertyIDId':%d",[insIdstr intValue],[roomIdstr intValue],[NSDate date],[proId intValue]];
    
    if(comment!=nil && comment.length>0)
    {
        [body appendFormat:@",'sl_inspectorIncidentComments':'%@'",comment];
    }
    else
    {
        [body appendString:@",'sl_inspectorIncidentComments':null"];
    }
    if(type!=nil && type.length >0)
    {
        [body appendFormat:@",'sl_type':'%@'",type];
    }
    else
    {
        [body appendString:@",'sl_type':null"];
    }
    
    [body appendString:@"}"];
    [self.listClient createListItem:@"Incidents" body:body callback:
         ^(NSData *data, NSURLResponse *response, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 //NSLog(@"response %@ .\r\n",response);
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                 if(error!=nil
                    ||[httpResponse statusCode] != 201)
                 {
                     callback(@"NO");
                 }
                 else
                 {
                     NSString *subId =[self getCreateListItemId:(NSString *)[httpResponse.allHeaderFields objectForKey:@"Location"]];
                     if (subId!=nil) {
                         self.commentItemId = subId;
                         //update the incidentOfInspectionDic flag
                         [self updateInspectionTabelAndRoomTable:proId inspectionId:insIdstr roomId:roomIdstr];
                         callback(@"YES");
                     }
                     else
                     {
                         callback(@"NO");
                     }
                     
                 }
             });
         }];
}

#pragma mark - other
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
#pragma mark UIPickerViewDataSource

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 376;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(self.incidentTypeArray!=nil)
    {
        return [self.incidentTypeArray count];
    }
    else
    {
        return 0;
    }
}
-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = (NSString *)[self.incidentTypeArray objectAtIndex:row];
    NSAttributedString *attString =[[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return attString;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.incidentTypeArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    [(UIButton *)[self.view viewWithTag:CommentDpBtnTag] setTitle:[self.incidentTypeArray objectAtIndex:row] forState:UIControlStateNormal];
    pickerView.hidden = YES;
}

#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag == RightPropertyDetailTableViewTag)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == RightPropertyDetailTableViewTag)
    {
        if(section == 0)
        {
            NSMutableArray *toparray =[self.rightPropertyListDic objectForKey:@"top"];
            if(toparray!=nil && [toparray count]>0)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
        else
        {
            
            NSMutableArray *bottomarray =[self.rightPropertyListDic objectForKey:@"bottom"];
            if(bottomarray!=nil)
            {
                return [bottomarray count];
            }
            else
            {
                return 0;
            }
        }
    }
    else if(tableView.tag == LeftPropertyDetailTableViewTag)
    {
        if(self.selectRightPropertyTableIndexPath!=nil)
        {
            return 3;
        }
        else
        {
            return 0;
        }
        
    }
    else if(tableView.tag == LeftInspectionLeftTableViewTag)
    {
        if(self.selectRightPropertyTableIndexPath!=nil)
        {
            NSDictionary *tempdic  = [self getSelectPropertyDic];
            if(tempdic!=nil)
            {
                NSArray * list = [tempdic objectForKey:@"inspectionslist"];
                if(list!=nil)
                {
                    return [list count];
                }
            }
        }
        return 0;
    }
    else if(tableView.tag == LeftInspectionMidTableViewTag||
            tableView.tag == LeftInspectionRightTableViewTag)
    {
        if(self.selectRightPropertyTableIndexPath!=nil)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else if(tableView.tag == LeftRoomTableViewTag)
    {
        if(self.selectRightPropertyItemId!=nil)
        {
            NSDictionary *prodic = [self getSelectPropertyDic];
            if (prodic!=nil) {
                NSArray *roomArray = [prodic objectForKey:@"RoomsArray"];
                if(roomArray!=nil)
                {
                    return [roomArray count];
                }
            }

        }
        return 0;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == RightPropertyDetailTableViewTag)
    {
        return 109;
    }
    else if(tableView.tag == LeftPropertyDetailTableViewTag)
    {
        if(indexPath.row == 2)
        {
            return 225;
        }
        else
        {
            return 25;
        }
    }
    else if(tableView.tag == LeftInspectionLeftTableViewTag||
            tableView.tag == LeftRoomTableViewTag)
    {
        return 30;
    }
    else if(tableView.tag == LeftInspectionMidTableViewTag||
            tableView.tag == LeftInspectionRightTableViewTag)
    {
        return 50;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == RightPropertyDetailTableViewTag)
    {
        return 30;
        
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == RightPropertyDetailTableViewTag)
    {
        if (section == 0)
        {
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
            NSString *lbl1str = @"CURRENT INSPECTION";
           // NSDictionary *attributes = @{NSFontAttributeName:font};
            //CGSize lbsize = [lbl1str sizeWithAttributes:attributes];
            UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 620, 30)];
            lbl1.text = lbl1str;
            lbl1.textAlignment = NSTextAlignmentLeft;
            lbl1.font = font;
            lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
            return lbl1;
        }
        else
        {
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
            NSString *lbl1str = @"UPCOMING INSPECTIONS";
            //NSDictionary *attributes = @{NSFontAttributeName:font};
            //CGSize lbsize = [lbl1str sizeWithAttributes:attributes];
            UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 620, 30)];
            lbl1.text = lbl1str;
            lbl1.textAlignment = NSTextAlignmentLeft;
            lbl1.font = font;
            lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
            
            return lbl1;
        }
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == RightPropertyDetailTableViewTag)
    {
        NSString *identifier = @"PropertyListCell";
        PropertyListCell *cell  = cell = [tableView dequeueReusableCellWithIdentifier:identifier  forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [self setRightTableCell:cell cellForRowAtIndexPath:indexPath];
        return cell;
    }
    else if(tableView.tag == LeftInspectionMidTableViewTag ||
            tableView.tag == LeftInspectionRightTableViewTag )
    {
        NSString *identifier = @"ContactOwnerCell";
        ContactOwnerCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSDictionary * tempdic = [self getSelectPropertyDic];
        if(tempdic!=nil)
        {
            if(tableView.tag == LeftInspectionMidTableViewTag)
            {
                [cell setCellValue:(NSString *)[EKNEKNGlobalInfo getObjectFromDefault:@"dispatcherEmail"]];
            }
            else
            {
                [cell setCellValue:[tempdic objectForKey:@"contactemail"]];
            }
        }
        
        return cell;
    }
    else if(tableView.tag == LeftInspectionLeftTableViewTag)
    {
        NSString *identifier = @"InspectionListCell";
        InspectionListCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [self setLeftInspectionTableCell:cell cellForRowAtIndexPath:indexPath];
        return cell;
    }
    else if(tableView.tag == LeftRoomTableViewTag)
    {
        NSString *identifier = @"RoomListCell";
        RoomListCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        [self setLeftRoomTableCell:cell cellForRowAtIndexPath:indexPath];
        return cell;
    }
    else if(tableView.tag == LeftPropertyDetailTableViewTag)
    {
        if(self.selectRightPropertyTableIndexPath!=nil && self.rightPropertyListDic!=nil)
        {
            NSDictionary *pro = [self getProperyListItemDicByIndexPath:self.selectRightPropertyTableIndexPath];
                if(pro!=nil)
                {
                    if(indexPath.row==2)
                    {
                        NSString *identifier = @"PropertyDetailsImage";
                        PropertyDetailsImage *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
                        if (cell == nil) {
                            [tableView registerNib:[UINib nibWithNibName:@"PropertyDetailsImage" bundle:nil] forCellReuseIdentifier:identifier];
                            cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                        }
                        
                        NSString *address = [pro objectForKey:@"sl_address1"];
                        //NSString *propertyId =[NSString stringWithFormat:@"%@",[pro objectForKey:@"ID"]];
                        NSMutableDictionary *prodict = [self getSelectPropertyDic];
                        UIImage *image =(UIImage *)[prodict objectForKey:@"image"];
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
                            cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                        }
                        if (indexPath.row == 0) {
                            NSString *title = [pro objectForKey:@"Title"];
                            [cell setCellValue:[UIImage imageNamed:@"home"] title:title];
                        }
                        else
                        {
                            NSString *title = [pro objectForKey:@"sl_owner"];
                            [cell setCellValue:[UIImage imageNamed:@"man"] title:title];
                        }
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        return cell;
                    }
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == RightPropertyDetailTableViewTag)
    {
        if([self.selectRightPropertyTableIndexPath compare:indexPath]!=NSOrderedSame)
        {
            self.selectRightPropertyItemId = nil;
            self.selectLetInspectionIndexPath = nil;
            self.selectLetRoomIndexPath = nil;
            self.selectRightCollectionIndexPath =nil;
            
            [self didSelectRightPropertyTableItem:indexPath];
        }
    }
    else if(tableView.tag == LeftInspectionLeftTableViewTag)
    {
      [self didSelectLeftInspectionsTableItem:indexPath tableview:tableView];
    }
    else if(tableView.tag == LeftRoomTableViewTag)
    {
        if(self.selectLetRoomIndexPath!=indexPath)
        {
            [self didSelectLeftRoomTableItem:indexPath refresh:NO];
        }

    }
    else if(tableView.tag == LeftInspectionMidTableViewTag ||
            tableView.tag == LeftInspectionRightTableViewTag )
    {
        ContactOwnerCell *cell =(ContactOwnerCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        NSString *address = cell.emailLable.text;
        [self showSendEmailViewController:address];
    }
    else
    {
        
    }
}
#pragma mark - Tableview/TableCell init/update value
-(void)InitRightPropertyTable
{
    //get current property inspection list
    [self getInspectionListAccordingPropertyId:self.selectRightPropertyItemId];
    
    //right property table view need reload data
    UITableView *rightPropertyTableView = (UITableView *)[self.view viewWithTag:RightPropertyDetailTableViewTag];
    [rightPropertyTableView reloadData];
    if ([[self.rightPropertyListDic objectForKey:@"top"] count]>0) {
        NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:0];
        [rightPropertyTableView selectRowAtIndexPath:temp animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self didSelectRightPropertyTableItem:temp];
    }
    else if([[self.rightPropertyListDic objectForKey:@"bottom"] count]>0)
    {
        NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:1];
        [rightPropertyTableView selectRowAtIndexPath:temp animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self didSelectRightPropertyTableItem:temp];
    }
    else
    {
        return;
    }

    
}

-(void)setLeftInspectionTableCell:(InspectionListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *prodic = [self getSelectPropertyDic];
    
    if(prodic!=nil)
    {
        NSMutableArray *inspectionList = [prodic objectForKey:@"inspectionslist"];
        NSDictionary *inspecdic =[inspectionList objectAtIndex:indexPath.row];
        if(inspecdic!=nil)
        {
            BOOL showPlus = NO;
            BOOL showFinal = NO;
            if([[inspecdic objectForKey:@"bowner"] isEqualToString:@"YES"])
            {
                if([[inspecdic objectForKey:@"sl_datetime"] isEqualToString:[EKNEKNGlobalInfo converStringFromDate:[NSDate date]]])
                {
                    showPlus = YES;
                }
                if([[inspecdic objectForKey:@"sl_finalized"] isEqualToString:@"YES"])
                {
                    showFinal = YES;
                }
            }
            
            
            [cell setCellValue:[inspecdic objectForKey:@"sl_datetime"]
                         owner:[inspecdic objectForKey:@"sl_accountname"]
                         incident:[inspecdic objectForKey:@"icon"]
                         plus:showPlus
                          final:showFinal
                          inspectionItemId:[inspecdic objectForKey:@"ID"]];
        }
    }
}
-(void)setLeftRoomTableCell:(RoomListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *roomsArray = [[self getSelectPropertyDic] objectForKey:@"RoomsArray"];
    if(roomsArray!=nil)
    {
        NSDictionary *roomDic = [roomsArray objectAtIndex:indexPath.row];
        NSString *roomId = [roomDic objectForKey:@"Id"];
        NSString *roomIconName = @"greenRoom";
        
        if([[self getRoomItemIcon:roomId] isEqualToString:@"YES"])
        {
            roomIconName = @"redRoom";
        }
        [cell setCellValue:roomIconName title:[roomDic objectForKey:@"Title"]];
    }
}
-(void)setRightTableCell:(PropertyListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *pro = [self getProperyListItemDicByIndexPath:indexPath];
    if(pro!=nil)
    {
        NSString *address = [pro objectForKey:@"sl_address1"];
        NSString *propertyId =[NSString stringWithFormat:@"%@",[pro objectForKey:@"ID"]];
        if(propertyId!=nil)
        {
            NSMutableDictionary *prodict = [self.propertyDic objectForKey:propertyId];
            UIImage *image =(UIImage *)[prodict objectForKey:@"image"];
            [cell setCellValue:image address:address];
        }
    }
}
-(void)updateRightPropertyTableCellImage:(NSString *)proid image:(UIImage *)image
{
   // BOOL found =  false;
    ListItem *inspectionitem = nil;
    if([[self.rightPropertyListDic objectForKey:@"top"] count]>0)
    {
        inspectionitem = [[self.rightPropertyListDic objectForKey:@"top"] objectAtIndex:0];
    }
    NSIndexPath *updateIndexPath = nil;
    if(inspectionitem!=nil)
    {
        NSDictionary *pro = (NSDictionary *)[inspectionitem getData:@"sl_propertyID"];
        if(pro!=nil)
        {
            NSString *propertyId =[NSString stringWithFormat:@"%@",[pro objectForKey:@"ID"]];
            if([propertyId isEqualToString:proid])
            {
                updateIndexPath =[NSIndexPath indexPathForRow:0 inSection:0];
                [self updateLeftPropertyDetailTableCell:image updateIndexPath:updateIndexPath];
            }
        }
    }

    NSMutableArray *bottomarray = [self.rightPropertyListDic objectForKey:@"bottom"];
    if(bottomarray!=nil)
    {
        for(NSInteger i = 0; i< [bottomarray count]; i++)
        {
            ListItem *tp = [bottomarray objectAtIndex:i];
                
            NSDictionary *pro = (NSDictionary *)[tp getData:@"sl_propertyID"];
            if(pro!=nil)
            {
                NSString *propertyId =[NSString stringWithFormat:@"%@",[pro objectForKey:@"ID"]];
                if([propertyId isEqualToString:proid])
                {
                    updateIndexPath =[NSIndexPath indexPathForRow:i inSection:1];
                    [self updateLeftPropertyDetailTableCell:image updateIndexPath:updateIndexPath];
                    break;
                }
            }
        }
    }
}
-(void)updateLeftPropertyDetailTableCell:(UIImage *)image updateIndexPath:(NSIndexPath *)updateIndexPath
{
    [self updateRightPropertyTableCell:updateIndexPath image:image];
    if([self.selectRightPropertyTableIndexPath compare:updateIndexPath]==NSOrderedSame)
    {
        UITableView * propertyDetailTableView =(UITableView *)[self.view viewWithTag:LeftPropertyDetailTableViewTag];
        [propertyDetailTableView beginUpdates];
        NSIndexPath *upi = [NSIndexPath indexPathForRow:2 inSection:0];
        [propertyDetailTableView reloadRowsAtIndexPaths:@[upi] withRowAnimation:UITableViewRowAnimationNone];
        [propertyDetailTableView endUpdates];
        
        [(UITableView *)[self.view viewWithTag:RightPropertyDetailTableViewTag] selectRowAtIndexPath:updateIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}
-(void)updateRightPropertyTableCell:(NSIndexPath *)indexpath image:(UIImage*)image
{
    UITableView *rightPropertyTableView = (UITableView *)[self.view viewWithTag:RightPropertyDetailTableViewTag];
    [rightPropertyTableView beginUpdates];
    [rightPropertyTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [rightPropertyTableView endUpdates];
    
    // PropertyListCell *up = (PropertyListCell *)[self.rightTableView cellForRowAtIndexPath:indexpath];
    //[up.imageView setImage:image];
}

-(void)didSelectRightPropertyTableItem:(NSIndexPath*)indexpath
{
    self.selectRightPropertyTableIndexPath = indexpath;
    
    ListItem *inspectionitem = nil;
    if(self.selectRightPropertyTableIndexPath.section == 0)
    {
        inspectionitem = [[self.rightPropertyListDic objectForKey:@"top"] objectAtIndex:0];
    }
    else
    {
        NSMutableArray *bottomarray = [self.rightPropertyListDic objectForKey:@"bottom"];
        if(bottomarray!=nil)
        {
            inspectionitem = [bottomarray objectAtIndex:self.selectRightPropertyTableIndexPath.row];
        }
    }
    if(inspectionitem!=nil)
    {
        NSDictionary *pro = (NSDictionary *)[inspectionitem getData:@"sl_propertyID"];
        self.selectRightPropertyItemId =[NSString stringWithFormat:@"%@",[pro objectForKey:@"ID"]];
        
        NSDictionary *insdic = (NSDictionary *)[inspectionitem getData:@"sl_inspector"];
        NSMutableDictionary *propertydic=[self getSelectPropertyDic];
        if(propertydic == nil)
        {
            propertydic = [[NSMutableDictionary alloc] init];
            [self.propertyDic setObject:propertydic forKey:self.selectRightPropertyItemId];
        }
        [propertydic setObject:[insdic objectForKey:@"sl_accountname"] forKey:@"contactowner"];
        [propertydic setObject:[pro objectForKey:@"sl_emailaddress"] forKey:@"contactemail"];
    }
    
    //reload left property detail table;
    [(UITableView *)[self.view viewWithTag:LeftPropertyDetailTableViewTag] reloadData];
    
    [self getInspectionListAccordingPropertyId:self.selectRightPropertyItemId];
    //reload left property insection left table;
    [(UITableView *)[self.view viewWithTag:LeftInspectionLeftTableViewTag] reloadData];
    [(UITableView *)[self.view viewWithTag:LeftInspectionMidTableViewTag] reloadData];
    [(UITableView *)[self.view viewWithTag:LeftInspectionRightTableViewTag] reloadData];
}
-(void)didSelectLeftInspectionsTableItem:(NSIndexPath*)indexPath tableview:(UITableView *)tableView
{
    InspectionListCell *cell = (InspectionListCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *stringTemp = [NSString stringWithFormat:@"        %@  |  %@",cell.dateTime.text,cell.owner.text];
    [(UILabel *)[self.view viewWithTag:RightRoomImageDateLblTag] setText:stringTemp];
    if(cell.bfinalized)
    {
        [self.view viewWithTag:LeftFinalizeBtnTag].hidden = NO;
    }
    else
    {
        [self.view viewWithTag:LeftFinalizeBtnTag].hidden = YES;
    }
    
    if([self.view viewWithTag:LeftBackButtonViewTag].hidden)
    {
        self.selectLetInspectionIndexPath = indexPath;
        self.selectLetRoomIndexPath = nil;
        self.selectRightCollectionIndexPath = nil;
        
        [UIView animateWithDuration:0.3 animations:
         ^{
             [self.view viewWithTag:LefSliderViewTag].frame = CGRectMake(24, 100,  320, 657);
             [self.view viewWithTag:LeftRoomSegViewTag].hidden = NO;
             if(self.roomsOfInspectionDic==nil)
             {
                 //get room data using service
                 [self getRoomInspectionPhotosList];
             }
             else
             {
                 [(UITableView *)[self.view viewWithTag:LeftRoomTableViewTag] reloadData];
                 [self didSelectLeftRoomTableItem:[NSIndexPath indexPathForRow:0 inSection:0] refresh:YES];
             }
             
         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [UIView animateWithDuration:0.3 animations:
                                  ^{
                                      [self.view viewWithTag:RightSliderViewTag].frame=CGRectMake(355, 91, 669, 677);
                                      [self.view viewWithTag:LeftBackButtonViewTag].hidden = NO;
                                  }
                                                  completion:^(BOOL finished){
                                                  }];
                             }
                         }];
    }
    else
    {
        if (self.selectLetInspectionIndexPath != indexPath) {
            self.selectLetInspectionIndexPath = indexPath;
            self.selectLetRoomIndexPath = nil;
            self.selectRightCollectionIndexPath = nil;
            
            [(UITableView *)[self.view viewWithTag:LeftRoomTableViewTag] reloadData];
            [self didSelectLeftRoomTableItem:[NSIndexPath indexPathForRow:0 inSection:0] refresh:YES];
        }
    }
}
-(void)didSelectLeftRoomTableItem:(NSIndexPath *)indexpath refresh:(BOOL)refresh
{
    self.selectLetRoomIndexPath =nil;
    self.selectRightCollectionIndexPath =nil;
    [self setRightLargeImage:nil];
    UICollectionView * collectionView = (UICollectionView *)[self.view viewWithTag:RightRoomCollectionViewTag];
    [collectionView reloadData];
    
    BOOL bRreshCollectionView = YES;
    if (refresh) {
        bRreshCollectionView = NO;
        //here we need get room table
        NSDictionary *prodic = [self getSelectPropertyDic];
        if (prodic!=nil) {
            NSMutableArray *roomsArray = [prodic objectForKey:@"RoomsArray"];
            if(roomsArray!=nil && [roomsArray count]>0)
            {
                self.selectLetRoomIndexPath = indexpath;
                [(UITableView *)[self.view viewWithTag:LeftRoomTableViewTag] selectRowAtIndexPath:self.selectLetRoomIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
                bRreshCollectionView =YES;
            }
        }
    }
    else
    {
         self.selectLetRoomIndexPath = indexpath;
    }
    if (bRreshCollectionView) {
        if ([self getRightCollectionViewItemsCount]>0)
        {
            self.selectRightCollectionIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [collectionView selectItemAtIndexPath:self.selectRightCollectionIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }

}
-(void)didUpdateTableCell:(NSIndexPath *)indexpath tag:(PropertySubViewsTag)tag
{
    UITableView *table = (UITableView *)[self.view viewWithTag:tag];
    [table beginUpdates];
    [table reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [table endUpdates];
    [table selectRowAtIndexPath:indexpath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
-(void)updateInspectionTabelAndRoomTable:(NSString *)proId inspectionId:(NSString *)insIdstr roomId:(NSString *)roomIdstr
{
    //update the incidentOfInspectionDic flag
    NSMutableDictionary *prodict =[self.incidentOfInspectionDic objectForKey:proId];
    NSMutableDictionary *insdict = [prodict objectForKey:insIdstr];
    if (insdict ==nil) {
        insdict =[[NSMutableDictionary alloc] init];
        [prodict setObject:insdict forKey:insIdstr];
    }
    if ([insdict objectForKey:[NSString stringWithFormat:@"room%@",roomIdstr]]==nil) {
        [insdict setObject:@"YES" forKey:[NSString stringWithFormat:@"room%@",roomIdstr]];
        [self didUpdateTableCell:self.selectLetRoomIndexPath tag:LeftRoomTableViewTag];
    }
    if ([insdict objectForKey:@"icon"]==nil) {
        [insdict setObject:@"red" forKey:@"icon"];
        
        //update list item
        NSMutableArray *inspectionList = [[self getSelectPropertyDic] objectForKey:@"inspectionslist"];
        NSMutableDictionary *insDic = [inspectionList objectAtIndex:self.selectLetInspectionIndexPath.row];
        NSString *icon =[insDic objectForKey:@"icon"];
        if (icon!=nil && [icon isEqualToString:@"green"]) {
            [insDic setObject:@"red" forKey:@"icon"];
            [self didUpdateTableCell:self.selectLetInspectionIndexPath tag:LeftInspectionLeftTableViewTag];
        }
    }
}
#pragma mark - Collection view delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag == RightRoomCollectionViewTag)//right image collection view
    {
        return [self getRightCollectionViewItemsCount];
    }
    else if(collectionView.tag == CommentCollectionViewTag)
    {
        return [self.commentViewImages count];
    }
    return 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == RightRoomCollectionViewTag)
    {
        self.selectRightCollectionIndexPath = indexPath;
        EKNCollectionViewCell *cell = (EKNCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
       // cell.selectImageViw.hidden = NO;
        if (cell.imagecell!=nil) {
            [self setRightLargeImage:cell.imagecell.image];
        }
        else
        {
            [self setRightLargeImage:nil];
        }
    }
    else if(collectionView.tag == CommentCollectionViewTag)
    {

    }
}
/*- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if(collectionView.tag == RightRoomCollectionViewTag)
    {
        EKNCollectionViewCell *cell = (EKNCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.selectImageViw.hidden = YES;
    }
}*/
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     if(collectionView.tag == RightRoomCollectionViewTag)
    {
        NSString *identifier = @"EKNCollectionViewCell";

        EKNCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [self setRightCollectionCellValue:cell indexpath:indexPath];
        //NSLog(@"collection view %p",cell);
        return cell;
    }
    else if(collectionView.tag == CommentCollectionViewTag)
    {
        NSString *identifier = @"CommentCollectionViewCell";
        
        CommentCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell.commetImage setImage:[self.commentViewImages  objectAtIndex:indexPath.row]];
        cell.commetImage.hidden = NO;
        return cell;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == RightRoomCollectionViewTag)
    {
        return CGSizeMake(150, 116);
    }
    else if(collectionView.tag == CommentCollectionViewTag)
    {
        return CGSizeMake(140, 79);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
    /*CGFloat width = image.size.width;
    CGFloat heigth = image.size.height;
    if(heigth > 116)
    {
        width = width / (heigth / 116);
        heigth = 116;
    }
    return CGSizeMake(width, heigth);*/
    
    
}
#pragma mark - Collection cell init value
-(void)setRightCollectionCellValue:(EKNCollectionViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    NSString *proId = self.selectRightPropertyItemId;
    NSString *insId = [self getSelectLeftInspectionItemId];
    NSString *roomId = [self getSelectLeftRoomItemId];
    NSInteger roomIdex =self.selectLetRoomIndexPath.row;
    
    NSArray *roomsArray = [[self.propertyDic objectForKey:proId] objectForKey:@"RoomsArray"];
    
    
    if([roomsArray count]>=roomIdex+1)
    {
        NSArray *imagesArray = [[self.roomsOfInspectionDic objectForKey:insId] objectForKey:roomId];
        if([imagesArray count]>=indexpath.row+1)
        {
            NSDictionary *imagedic = [imagesArray objectAtIndex:indexpath.row];
            UIImage *roomImage = [imagedic objectForKey:@"image"];
            if(roomImage!=nil)
            {
                [cell.imagecell setImage:roomImage];
                if (cell.selected) {
                    [self setRightLargeImage:roomImage];
                }
                
                [self stopPropertyViewSpiner];
            }
            else
            {
                [self startPropertyViewSpiner:CGRectMake(500,384,50,50)];
                [cell.imagecell setImage:nil];
                
                if([imagedic objectForKey:@"ServerRelativeUrl"] == nil)
                {
                    NSString *fileId = [imagedic objectForKey:@"Id"];
                    //task read file infor
                    [self.listClient getListItemFileByFilter:@"Room Inspection Photos"
                                                                                     FileId:fileId
                                                                                     filter:@"$select=ServerRelativeUrl"
                                                                                   callback:^(NSMutableArray *listItems, NSError *error)
                                                             {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     
                                                                     if([listItems count]>0)
                                                                     {
                                                                         NSString *path =(NSString *)[[listItems objectAtIndex:0] getData:@"ServerRelativeUrl"];
                                                                         [imagedic setValue:path forKey:@"ServerRelativeUrl"];
                                                                         [self getRoomImageFileREST:path
                                                                                         propertyId:[proId integerValue]
                                                                                       inspectionId:[insId integerValue]
                                                                                       roomId:[roomId integerValue]
                                                                                       imageIndex:indexpath.row];
                                                                     }
                                                                 });
                                                             }];
                    
                }
            }

            
        }
    }
    
}
@end


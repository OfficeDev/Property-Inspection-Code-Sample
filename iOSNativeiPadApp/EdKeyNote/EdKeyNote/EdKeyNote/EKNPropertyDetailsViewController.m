//
//  EKNPropertyDetailsViewController.m
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNPropertyDetailsViewController.h"

@interface EKNPropertyDetailsViewController ()

@end

@implementation EKNPropertyDetailsViewController

-(void)initData
{
    //init extern data
    self.selectRightPropertyItemId = @"1";//for test
    self.loginName = @"Rob Barker";//for test
    //cloris will modify
    
    self.selectLetInspectionIndexPath = nil;
    self.selectRightPropertyTableIndexPath = nil;
    self.selectLetRoomIndexPath = nil;
    self.listClient = [self getClient];
    self.commentViewImages = [[NSMutableArray alloc] init];
    self.commentItemId = nil;
    self.incidentTypeArray = nil;;
    self.mailController = nil;
    
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
    rightCollectionView.delegate = self;
    rightCollectionView.dataSource =self;
    
    [rightCollectionView registerClass:[EKNCollectionViewCell class] forCellWithReuseIdentifier:@"EKNCollectionViewCell"];
    [rightSlideView addSubview:rightCollectionView];
}
-(void)setRightLargeImage:(UIImage *)image
{
    if(image!=nil)
    {
        [self stopPropertyViewSpiner];
    }
    UIImageView *largeIamgeView = (UIImageView *)[self.view viewWithTag:RightRoomImageLargeImageTag];
    [largeIamgeView setImage:image];
}
#pragma mark - spiner/comment pop up
-(void)addSpinner
{
    self.propertyViewSpinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    self.propertyViewSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.propertyViewSpinner];
    self.propertyViewSpinner.hidesWhenStopped = YES;
    
    self.commentViewSpinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,550+91,50,50)];
    self.commentViewSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
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
    [commentCollectionView registerClass:[EKNCollectionViewCell class] forCellWithReuseIdentifier:@"EKNCollectionViewCell"];
    [commentPopupView addSubview:commentCollectionView];
    
    
    UIView *commentBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(106, 149, 886, 160)];
    commentBackgoundView.tag =CommentTextBackgroundViewTag;
    commentBackgoundView.backgroundColor = [UIColor whiteColor];
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
    [commentPopupView addSubview:idPicker];
    
    commentPopupView.hidden = YES;
    [self.view addSubview:commentPopupView];
    

    
}

/*- (void) addPhotoDetailPopupView
 {
 UIView *photoDetailPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
 photoDetailPopupView.tag = CommentPhotoDetailPopViewTag;
 photoDetailPopupView.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(0.00/255.00f) blue:(0.00/255.00f) alpha:0.8];
 UIImageView *largePhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(407, 305, 210, 158)];
 
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
 }*/
#pragma mark - AlertView
-(void)showHintAlertView:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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
    OAuthentication* authentication = [OAuthentication alloc];
    [authentication setToken:self.token];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    return [[ListClient alloc] initWithUrl:[standardUserDefaults objectForKey:@"demoSiteCollectionUrl"]
                               credentials: authentication];
}

-(NSInteger)getRightCollectionViewItemsCount
{
    NSMutableArray *roomsArray = [self.roomsOfInspectionDic objectForKey:[self getSelectLeftInspectionItemId]];
    if(roomsArray!=nil)
    {
        NSDictionary * roomdic = [roomsArray objectAtIndex:self.selectLetRoomIndexPath.row];
        NSArray *imagesArray =[roomdic objectForKey:@"ImagesArray"];
        if(imagesArray!=nil)
        {
            return [imagesArray count];
        }
    }
    return 0;
}
-(NSString *)getSelectLeftInspectionItemId
{
    if(self.selectRightPropertyTableIndexPath!=nil)
    {
        NSDictionary *tempdic  = [self.propertyDic objectForKey:self.selectRightPropertyItemId];
        if(tempdic!=nil)
        {
            NSArray * inspectionlist = [tempdic objectForKey:@"inspectionslist"];
            if(inspectionlist!=nil)
            {
                if(self.selectLetInspectionIndexPath!=nil)
                {
                    NSDictionary *inspecdic =[inspectionlist objectAtIndex:self.selectLetInspectionIndexPath.row];
                    NSString *insId = [inspecdic objectForKey:@"ID"];
                    return insId;
                }
            }
        }
    }
    return nil;
}
-(NSString *)getSelectLeftRoomItemId:(NSString *)insidstring
{
    NSInteger insId = [insidstring intValue];
    
    NSArray *roomsArray = [self.roomsOfInspectionDic objectForKey:[NSString stringWithFormat:@"%ld",insId]];
    NSInteger roomIdex =self.selectLetRoomIndexPath.row;
    if([roomsArray count]>=roomIdex+1)
    {
        NSDictionary *roomdic = [roomsArray objectAtIndex:roomIdex];
        return (NSString *)[roomdic objectForKey:@"Id"];
    }
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
    
        
    if(type != (NSString *)[NSNull null])
    {
       [(UIButton *)[self.view viewWithTag:CommentDpBtnTag] setTitle:type forState:UIControlStateNormal];
        
        NSInteger index = [self.incidentTypeArray indexOfObject:type];
        [(UIPickerView *)[self.view viewWithTag:CommentPickerViewTag] selectRow:index inComponent:0 animated:NO];
    }

}
-(void)setCommmentViewShow
{
    [self.view viewWithTag:CommentTextBackgroundViewTag].frame =CGRectMake(106, 149, 886, 160);
    [self.view viewWithTag:CommentTextViewTag].frame =CGRectMake(121, 169, 856, 120);
    [self.view viewWithTag:CommentPopViewTag].hidden = NO;
    [self.view viewWithTag:CommentDpBtnTag].hidden = YES;
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
}
-(void)stopCommentViewSpiner
{
    [self.commentViewSpinner stopAnimating];
}
-(void)showSendEmailViewController:(NSString *)address
{
    if(self.mailController == nil)
    {
        self.mailController = [[MFMailComposeViewController alloc] init];
        self.mailController.mailComposeDelegate = self;
    }
    NSArray *to = [NSArray arrayWithObjects:address, nil];
    
    NSString *body =@"Edkey Note Demo";
    [self.mailController setToRecipients:to];
    [self.mailController setMessageBody:body isHTML:NO];
    [self.navigationController pushViewController:self.mailController animated:YES];
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
        [self disableViewAfterCommentPopUp];
        
        [self startCommentViewSpiner:CGRectMake(129+50,330+91,50,50)];
        
        NSString *insIdstr = [self getSelectLeftInspectionItemId];
        if (insIdstr!=nil) {
            NSString *roomIdstr = [self getSelectLeftRoomItemId:insIdstr];
            NSMutableString *filterStr = [[NSMutableString alloc] initWithFormat:@"$select=Title,ID&$filter=sl_inspectionIDId%%20eq%%20%@%%20and%%20sl_roomIDId%%20eq%%20%@&$top=1",insIdstr,roomIdstr];
            
            NSURLSessionTask* task = [self.listClient getListItemsByFilter:@"Inspection Comments" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if (error==nil) {
                                                  NSString *text = @"";
                                                  if([listItems count]>0)
                                                  {
                                                      
                                                      self.commentItemId =[NSString stringWithFormat:@"%@",(NSString *)[[listItems objectAtIndex:0] getData:@"Id"]];
                                                      text = (NSString *)[[listItems objectAtIndex:0] getData:@"Title"];

                                                  }
                                                  else
                                                  {
                                                      //can't find, we need creat a new item
                                                      self.commentItemId = nil;
                                                  }
                                                  ((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text = text;
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
              [task resume];
            
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
        if(self.incidentTypeArray == nil)
        {
            [self.commentViewImages removeAllObjects];
            [self disableViewAfterCommentPopUp];
            
            [self startCommentViewSpiner:CGRectMake(129+50,330+91,50,50)];
            
            [self.listClient getFieldValue:self.token listTitle:@"Incidents" field:@"Type" propertyName:@"Choices" callback:^(NSMutableArray *listItems, NSError *error)
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
    
        [self.listClient updateListItem:self.token listName:@"Inspections" itemID:insid body:body callback: ^(
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
                      [self showHintAlertView:@"" message:@"Finalize Successfully."];
                      [self stopCommentViewSpiner];
                  }
                  
              });
         
         }];
    }
    
}
-(void)cameraButtonClicked
{
    //here we click the commerabutton
}
-(void)cancelButtonClicked
{
    [self.view viewWithTag:CommentPopViewTag].hidden = YES;
    [self enableViewAfterCommentDismiss];
    [(UITextView *)[self.view viewWithTag:CommentTextViewTag] resignFirstResponder];
}
-(void)doneButtonClicked
{
    if ([self getCommentViewWhetherShow]) {
        [self updateCommentListItem];
    }
    else
    {
        //upload comment list incident
        [self updateIncidentListItem];
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
    [self startPropertyViewSpiner:CGRectMake(135,140,50,50)];
    
    NSURLSessionTask* task = [self.listClient getListItemsByFilter:@"Inspections" filter:@"$select=ID,sl_datetime,sl_finalized,sl_inspector/ID,sl_inspector/Title,sl_inspector/sl_accountname,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_emailaddress&$expand=sl_inspector,sl_propertyID&$orderby=sl_datetime%20desc" callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *upcomingList = [[NSMutableArray alloc] init];
            ListItem* currentInspectionData = [[ListItem alloc] init];
            BOOL bfound=false;
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
                bfound = false;
                NSDictionary * pdic = (NSDictionary *)[tempitem getData:@"sl_propertyID"];
                if(pdic!=nil)
                {
                    if([[pdic objectForKey:@"ID"] intValue] == [self.selectRightPropertyItemId intValue])
                    {
                        bfound = true;
                        currentInspectionData = tempitem;
                    }
                }
                if(!bfound)
                {
                    NSString *tempdatetime =(NSString *)[tempitem getData:@"sl_datetime"];
                    if(tempdatetime!=nil)
                    {
                        NSDate *inspectiondatetime = [EKNEKNGlobalInfo converDateFromString:tempdatetime];
                        if([inspectiondatetime compare:[NSDate date]] == NSOrderedDescending)
                        {
                            [upcomingList addObject:tempitem];
                        }
                    }
                }
            }
            //get the right pannel data
            self.rightPropertyListDic = [[NSMutableDictionary alloc] init];
            [self.rightPropertyListDic setObject:currentInspectionData forKey:@"top"];
            [self.rightPropertyListDic setObject:upcomingList forKey:@"bottom"];
            
            //get property resource list:
            [self getPropertyResourceList];
        });
    }];
    
    [task resume];
}

-(void)getPropertyResourceList
{
    NSURLSessionTask* getpropertyResourcetask = [self.listClient getListItemsByFilter:@"Property Photos" filter:@"$select=sl_propertyIDId,Id" callback:^(NSMutableArray * listItems, NSError *error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //self.propertyResourceListArray =listItems;
                            [self getPropertyResourceFile:(NSMutableArray* )listItems];
                        });
                    }];
    
    [getpropertyResourcetask resume];
}

-(void)getPropertyResourceFile:(NSMutableArray* )listItems
{
    NSMutableString* loopindex = [[NSMutableString alloc] initWithString:@"0"];
    NSMutableArray *loopitems =listItems;
    self.propertyDic = [[NSMutableDictionary alloc] init];
    
    for (ListItem* tempitem in loopitems)
    {
        NSString *propertyId =[NSString stringWithFormat:@"%@",[tempitem getData:@"sl_propertyIDId"]];
    
        NSURLSessionTask* getFileResourcetask = [self.listClient getListItemFileByFilter:@"Property Photos"
                                                        FileId:(NSString *)[tempitem getData:@"ID"]
                                                        filter:@"$select=ServerRelativeUrl"
                                                        callback:^(NSMutableArray *listItems, NSError *error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            int preindex = [loopindex intValue];
                            preindex++;
                                                         
                            if([listItems count]>0)
                            {
                                NSMutableDictionary *propertyData =[[NSMutableDictionary alloc] init];
                                [propertyData setObject:[[listItems objectAtIndex:0] getData:@"ServerRelativeUrl"] forKey:@"ServerRelativeUrl"];
                                                             
                                [self.propertyDic setObject:propertyData forKey:propertyId];
                            }
                                                         
                            NSLog(@"propertyId %@",propertyId);
                            if(preindex == [loopitems count])
                            {
                                    //get Incidents list
                                    [self getIncidentsListArray];
                                                        
                            }
                            [loopindex setString:[NSString stringWithFormat:@"%d",preindex]];
                            NSLog(@"loopindex %@",loopindex);
                        });
                                                     
                    }];
        
        [getFileResourcetask resume];
    }
}
-(void)getIncidentTypeField:(void (^)(NSMutableArray *listItems, NSError *error))callback
{
    //NSURLSessionTask* getIncidentTypeFiledtask =[self.listClient getListItemsByFilter:@"Incidents" filter:<#(NSString *)#> callback:<#^(NSMutableArray *listItems, NSError *)callback#>:]
   // [getIncidentTypeFiledtask resume];
}
-(void)getIncidentsListArray
{
    self.incidentOfInspectionDic = [[NSMutableDictionary alloc] init];
    self.incidentOfRoomsDic = [[NSMutableDictionary alloc] init];
    NSURLSessionTask* getincidentstask = [self.listClient getListItemsByFilter:@"Incidents" filter:@"$select=sl_inspectionIDId,sl_roomIDId,Id"  callback:^(NSMutableArray *        listItems, NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                for (ListItem* tempitem in listItems) {
                    NSString *key =[NSString stringWithFormat:@"%@",[tempitem getData:@"sl_inspectionIDId"]];
                        
                    if(![self.incidentOfInspectionDic objectForKey:key])
                    {
                        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"red",@"icon", nil];
                        [self.incidentOfInspectionDic setObject:temp forKey:key];

                    }
                    NSString *roomId =[NSString stringWithFormat:@"%@",[tempitem getData:@"sl_roomIDId"]];
                    if (![self.incidentOfRoomsDic objectForKey:roomId]) {
                        [self.incidentOfRoomsDic setObject:@"1" forKey:roomId];
                    }
                }
                [self InitRightPropertyTable];
                //get All property images
                [self getAllPropertyImageFiles];
                
                [self stopPropertyViewSpiner];
            });
        }];
    [getincidentstask resume];
}
-(void)getInspectionListAccordingPropertyId:(NSString*)pid
{
    if([self.propertyDic objectForKey:pid] ==nil)
    {
        NSMutableDictionary *propertyTempDic = [[NSMutableDictionary alloc] init];
        [self.propertyDic setObject:propertyTempDic forKey:pid];
    }
    
    if(![[self.propertyDic objectForKey:pid] objectForKey:@"inspectionslist"])
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
                    

                    if ([[insdic objectForKey:@"Title"] isEqualToString:self.loginName ]) {
                        NSString *final = (NSString *)[tempitem getData:@"sl_finalized"];
                        
                        if (final == (NSString *)[NSNull null]) {
                            [inspectionItem setObject:@"YES" forKey:@"bowner"];
                        }
                    }
                    NSDate *inspectiondatetime = [EKNEKNGlobalInfo converDateFromString:(NSString *)[tempitem getData:@"sl_datetime"]];
                    [inspectionItem setObject:[EKNEKNGlobalInfo converStringFromDate:inspectiondatetime] forKey:@"sl_datetime"];
                    
                    if([inspectiondatetime compare:[NSDate date]] == NSOrderedDescending)
                    {
                    //upcoming
                        [inspectionItem setObject:@"black" forKey:@"icon"];
                    }
                    else
                    {
                        if([[self.incidentOfInspectionDic objectForKey:inspectionId] objectForKey:@"icon"]!=nil)
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
    
    [self.listClient getFile:self.token ServerRelativeUrl:path callback:^(NSData *data,NSURLResponse *response,NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"cloris get image erro %@",error);
             if (error == nil) {
                 NSLog(@"data length %lu",[data length]);
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
    
    ListClient* client = [self getClient];
    self.roomsOfInspectionDic = [[NSMutableDictionary alloc] init];
    NSURLSessionTask* task = [client getListItemsByFilter:@"Room Inspection Photos" filter:@"$select=Id,sl_inspectionIDId,sl_roomID/Title,sl_roomID/Id&$expand=sl_roomID"
                                                     callback:^(NSMutableArray *listItems, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (ListItem *temp in listItems) {
                    NSString *insId =[NSString stringWithFormat:@"%@",[temp getData:@"sl_inspectionIDId"]];

                    
                    NSMutableArray *roomsArray= [self.roomsOfInspectionDic objectForKey:insId];
                    if(roomsArray ==nil)
                    {
                        roomsArray = [[NSMutableArray alloc] init];
                        [self.roomsOfInspectionDic setObject:roomsArray forKey:insId];
                    }
                    
                    NSDictionary *romtemp = (NSDictionary *)[temp getData:@"sl_roomID"];
                    if(romtemp!=nil)
                    {
                        NSString *roomId =[NSString stringWithFormat:@"%@",[romtemp objectForKey:@"Id"]];
                        //check roomid whehter exist
                        NSMutableDictionary *roomDic=nil;
                        for (NSMutableDictionary *tempDic in roomsArray) {
                            if ([[tempDic objectForKey:@"Id"] isEqualToString:roomId]) {
                                roomDic = tempDic;
                                break;
                            }
                        }
                        if(roomDic == nil)
                        {
                            roomDic = [[NSMutableDictionary alloc] init];
                            [roomDic setObject:roomId forKey:@"Id"];
                            [roomDic setObject:[romtemp objectForKey:@"Title"] forKey:@"Title"];
                            [roomsArray addObject:roomDic];
                            
                        }
                        
                        NSMutableArray *imagesArray = [roomDic objectForKeyedSubscript:@"ImagesArray"];
                        if(imagesArray ==nil)
                        {
                            imagesArray = [[NSMutableArray alloc] init];
                            [roomDic setObject:imagesArray forKey:@"ImagesArray"];
                        }
                        
                        NSString *fileId = [NSString stringWithFormat:@"%@",[temp getData:@"Id"]];
                        if(fileId!=nil)
                        {
                            NSMutableDictionary *imagesDic = [[NSMutableDictionary alloc] init];
                            [imagesDic setObject:fileId forKey:@"Id"];
                            [imagesArray addObject:imagesDic];
                        }
                    }
                }
                [(UITableView *)[self.view viewWithTag:LeftRoomTableViewTag] reloadData];

                [self stopPropertyViewSpiner];
                
                [self didSelectLeftRoomTableItem:[NSIndexPath indexPathForRow:0 inSection:0] refresh:YES];
                //((UIButton *)[self.view viewWithTag:LeftBackButtonViewTag]).enabled = YES;
            });
            
        }];
        
        [task resume];
}
-(void)getRoomImageFileREST:(NSString *)path
                 propertyId:(NSInteger)proId
               inspectionId:(NSInteger)insid
                  roomIndex:(NSInteger)roomIndex
                 imageIndex:(NSInteger)imageIndex
{
    [self.listClient getFile:self.token ServerRelativeUrl:path callback:^(NSData *data,NSURLResponse *response,NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"cloris get room image erro %@",error);
             if (error == nil) {
                 NSLog(@"data length %lu",[data length]);
                 UIImage *image =[[UIImage alloc] initWithData:data];
                 NSMutableArray *imageArray = [[[self.roomsOfInspectionDic objectForKey:[NSString stringWithFormat:@"%ld",insid]] objectAtIndex:roomIndex] objectForKey:@"ImagesArray"];
                 
                 if([imageArray count]>= imageIndex+1)
                 {
                     NSMutableDictionary *imagDic = [imageArray objectAtIndex:imageIndex];
                     [imagDic setObject:image forKey:@"image"];
                     
                     NSString *currentInsId =[self getSelectLeftInspectionItemId];
                     if (proId == [self.selectRightPropertyItemId intValue]
                         && currentInsId!=nil && insid == [currentInsId intValue]
                         &&self.selectLetRoomIndexPath!=nil && roomIndex == self.selectLetRoomIndexPath.row) {
                         
                         NSLog(@"proId %ld, insid = %ld, roomIndex =%ld",proId,insid,roomIndex);
                         //update collection cell
                         UICollectionView *clviw =(UICollectionView *)[self.view viewWithTag:RightRoomCollectionViewTag];
                         EKNCollectionViewCell *cell = (EKNCollectionViewCell *)[clviw cellForItemAtIndexPath:[NSIndexPath indexPathForRow:imageIndex inSection:0]];
                         if (cell.selected) {
                             [self setRightLargeImage:image];
                             //cell.selectImageViw.hidden = NO;
                         }
                         [clviw reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:imageIndex inSection:0], nil]];
                         
                     }
                 }
                 
             }
             else
             {
                 //retry one
                 NSMutableDictionary *imagDic = [[[[self.roomsOfInspectionDic objectForKey:[NSString stringWithFormat:@"%ld",insid]] objectAtIndex:roomIndex] objectForKey:@"ImagesArray"] objectAtIndex:imageIndex];
                 
                 if([imagDic objectForKey:@"trytimes"]!=nil)
                 {
                     NSInteger times =[[imagDic objectForKey:@"trytimes"] integerValue];
                     if(times>=3)
                     {
                         UICollectionView *clviw =(UICollectionView *)[self.view viewWithTag:RightRoomCollectionViewTag];
                         EKNCollectionViewCell *cell = (EKNCollectionViewCell *)[clviw cellForItemAtIndexPath:[NSIndexPath indexPathForRow:imageIndex inSection:0]];
                         if (cell.selected) {
                             [self stopPropertyViewSpiner];
                         }
                     }
                     else
                     {
                         times=times+1;
                         [imagDic setObject:[NSString stringWithFormat:@"%ld",(long)times] forKey:@"trytimes"];
                         [self getRoomImageFileREST:path propertyId:proId inspectionId:insid roomIndex:roomIndex imageIndex:imageIndex];
                     }
                 }
                 else
                 {
                     [imagDic setObject:@"1" forKey:@"trytimes"];
                     [self getRoomImageFileREST:path propertyId:proId inspectionId:insid roomIndex:roomIndex imageIndex:imageIndex];
                 }
             }
         });
     }];
}
-(void)getIncidentComment
{
    NSString *insIdstr = [self getSelectLeftInspectionItemId];
    if (insIdstr!=nil) {
        [self.commentViewImages removeAllObjects];
        [self disableViewAfterCommentPopUp];
        [self startCommentViewSpiner:CGRectMake(129+50,330+91,50,50)];
        
        NSString *roomIdstr = [self getSelectLeftRoomItemId:insIdstr];
        NSMutableString *filterStr = [[NSMutableString alloc] initWithFormat:@"$select=sl_inspectorIncidentComments,ID,sl_type&$filter=sl_inspectionIDId%%20eq%%20%@%%20and%%20sl_roomIDId%%20eq%%20%@&$top=1",insIdstr,roomIdstr];
        
        NSURLSessionTask* task = [self.listClient getListItemsByFilter:@"Incidents" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (error==nil) {
                                              NSString *text;
                                              NSString *type=nil;
                                              if([listItems count]>0)
                                              {
                                                  self.commentItemId =[NSString stringWithFormat:@"%@",(NSString *)[[listItems objectAtIndex:0] getData:@"Id"]];
                                                  text = (NSString *)[[listItems objectAtIndex:0] getData:@"sl_inspectorIncidentComments"];
                                                  
                                                  //if type is null??
                                                  type =(NSString *)[[listItems objectAtIndex:0] getData:@"sl_type"] ;
                                                  
                                              }
                                              else
                                              {
                                                  //can't find, we need creat a new item
                                                  self.commentItemId = nil;
                                              }
                                              if(text != (NSString *)[NSNull null])
                                              {
                                                  ((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text = text;
                                              }
                                              [self setIncidentCommmentViewShow:type];

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
        [task resume];
        
    }
}
-(void)updateCommentListItem
{
    [self startCommentViewSpiner:CGRectMake(640,319,50,50)];
    
    if (self.commentItemId == nil) {
        NSString *insIdstr = [self getSelectLeftInspectionItemId];
        if (insIdstr!=nil) {
            NSString *roomIdstr = [self getSelectLeftRoomItemId:insIdstr];
            if(roomIdstr!=nil)
            {
                
                NSMutableString *body =[[NSMutableString alloc] init];
                [body appendFormat:@"{'__metadata': { 'type': 'SP.Data.InspectionCommentsListItem' }, 'sl_inspectionIDId':%d,'sl_roomIDId':%d",[insIdstr intValue],[roomIdstr intValue]];
                if(((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text.length>0)
                {
                    [body appendFormat:@",'Title':'%@'",((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text];
                }
                else
                {
                    [body appendString:@",'Title':null"];
                }
                
                [body appendString:@"}"];
                [self.listClient createListItem:self.token listName:@"Inspection Comments" body:body callback:^(NSData *data, NSURLResponse *response, NSError *error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //NSMutableArray *test = [self.listClient parseDataArray:data];
                         NSLog(@"response %@ .\r\n",response);
                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                         if(error!=nil
                            ||[httpResponse statusCode] != 201)
                         {
                             [self showHintAlertView:@"ERROR" message:@"Create the item failed."];
                             [self stopCommentViewSpiner];
                         }
                         else
                         {
                             //success.
                             [self showHintAlertView:@"Hint" message:@"Create the item successfully."];
                             [self stopCommentViewSpiner];
                             [self cancelButtonClicked];
                         }
                     });
                 }];
            }
            else
            {
                [self showHintAlertView:@"ERROR" message:@"Room Id is null"];
                [self stopCommentViewSpiner];
            }
            
        }
        else
        {
            [self showHintAlertView:@"ERROR" message:@"Inspection Id is null"];
            [self stopCommentViewSpiner];
        }
        
    }
    else
    {
        NSString *body = [NSString stringWithFormat:@"{'__metadata': { 'type': 'SP.Data.InspectionCommentsListItem' }, 'Title':'%@'}",((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text];
        [self.listClient updateListItem:self.token listName:@"Inspection Comments" itemID:self.commentItemId body:body
                                 callback: ^(NSData *data,NSURLResponse *response, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"response %@ .\r\n",response);
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                 if(error !=nil || [httpResponse statusCode] == 400)
                 {
                     [self showHintAlertView:@"ERROR" message:@"Update the item failed."];
                     [self stopCommentViewSpiner];
                 }
                 else{
                     [self showHintAlertView:@"Hint" message:@"Update the item successfully."];
                     [self stopCommentViewSpiner];
                     [self cancelButtonClicked];
                 }
             });
         }];
        
    }
}
-(void)updateIncidentListItem
{
    
    [self startCommentViewSpiner:CGRectMake(880,319,50,50)];
    NSString *type = ((UIButton *)[self.view viewWithTag:CommentDpBtnTag]).titleLabel.text;
    
    if (self.commentItemId == nil) {
        NSString *insIdstr = [self getSelectLeftInspectionItemId];
        if (insIdstr!=nil) {
            NSString *roomIdstr = [self getSelectLeftRoomItemId:insIdstr];
            if(roomIdstr!=nil)
            {
                NSMutableString *body =[[NSMutableString alloc] init];
                [body appendFormat:@"{'__metadata': { 'type': 'SP.Data.IncidentsListItem' }, 'sl_inspectionIDId':%d,'sl_roomIDId':%d",[insIdstr intValue],[roomIdstr intValue]];
                if(((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text.length>0)
                {
                    [body appendFormat:@",'sl_inspectorIncidentComments':'%@'",((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text];
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
            
                [self.listClient createListItem:self.token listName:@"Incidents" body:body callback:^(NSData *data, NSURLResponse *response, NSError *error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //NSMutableArray *test = [self.listClient parseDataArray:data];
                         NSLog(@"response %@ .\r\n",response);
                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                         if(error!=nil
                            ||[httpResponse statusCode] != 201)
                         {
                             [self showHintAlertView:@"ERROR" message:@"Create the incident item failed."];
                             [self stopCommentViewSpiner];
                         }
                         else
                         {
                             //success.
                             [self showHintAlertView:@"Hint" message:@"Create the incident item successfully."];
                             [self stopCommentViewSpiner];
                             [self cancelButtonClicked];
                         }
                     });
                 }];
            }
            else
            {
                [self showHintAlertView:@"ERROR" message:@"Room Id is null"];
                [self stopCommentViewSpiner];
            }
            
        }
        else
        {
            [self showHintAlertView:@"ERROR" message:@"Inspection Id is null"];
            [self stopCommentViewSpiner];
        }
        
    }
    else
    {
        
        NSMutableString *body =[[NSMutableString alloc] init];
        [body appendString:@"{'__metadata': { 'type': 'SP.Data.IncidentsListItem' }"];
        
        if(((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text.length>0)
        {
            [body appendFormat:@",'sl_inspectorIncidentComments':'%@'",((UITextView *)[self.view viewWithTag:CommentTextViewTag]).text];
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
        NSLog(@"body %@",body);

        [self.listClient updateListItem:self.token listName:@"Incidents" itemID:self.commentItemId body:body
                               callback: ^(NSData *data,NSURLResponse *response, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"response %@ .\r\n",response);
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                 if(error !=nil || [httpResponse statusCode] == 400)
                 {
                     [self showHintAlertView:@"ERROR" message:@"Update the incident item failed."];
                     [self stopCommentViewSpiner];
                 }
                 else{
                     [self showHintAlertView:@"Hint" message:@"Update the incident item successfully."];
                     [self stopCommentViewSpiner];
                     [self cancelButtonClicked];
                 }
             });
         }];
        
    }
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
#pragma mark -mail delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

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
            if(toparray!=nil)
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
            NSDictionary *tempdic  = [self.propertyDic objectForKey:self.selectRightPropertyItemId];
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
        if(self.selectLetInspectionIndexPath!=nil)
        {
            NSArray *roomArray = [self.roomsOfInspectionDic objectForKey:[self getSelectLeftInspectionItemId]];
            if(roomArray!=nil)
            {
                return [roomArray count];
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
        NSDictionary * tempdic = [self.propertyDic objectForKey:self.selectRightPropertyItemId];
        if(tempdic!=nil)
        {
            if(tableView.tag == LeftInspectionMidTableViewTag)
            {
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                [cell setCellValue: [standardUserDefaults objectForKey:@"dispatcherEmail"]];
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
            ListItem *inspectionitem = nil;
            if(self.selectRightPropertyTableIndexPath.section == 0)
            {
                inspectionitem = [self.rightPropertyListDic objectForKey:@"top"];
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
                        NSMutableDictionary *prodict = [self.propertyDic objectForKey:self.selectRightPropertyItemId];
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
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == RightPropertyDetailTableViewTag)
    {
        [self didSelectRightPropertyTableItem:indexPath];
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
    NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:0];
    [rightPropertyTableView selectRowAtIndexPath:temp animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self didSelectRightPropertyTableItem:temp];
}

-(void)setLeftInspectionTableCell:(InspectionListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *prodic = [self.propertyDic objectForKey:self.selectRightPropertyItemId];
    
    if(prodic!=nil)
    {
        NSMutableArray *inspectionList = [prodic objectForKey:@"inspectionslist"];
        NSDictionary *inspecdic =[inspectionList objectAtIndex:indexPath.row];
        if(inspecdic!=nil)
        {
            [cell setCellValue:[inspecdic objectForKey:@"sl_datetime"]
                         owner:[inspecdic objectForKey:@"sl_accountname"]
                         incident:[inspecdic objectForKey:@"icon"]
                          plus:[[inspecdic objectForKey:@"bowner"] isEqualToString:@"YES"]];
        }
    }
}
-(void)setLeftRoomTableCell:(RoomListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *roomsArray = [self.roomsOfInspectionDic objectForKey:[self getSelectLeftInspectionItemId]];
    if(roomsArray!=nil)
    {
        NSDictionary *roomDic = [roomsArray objectAtIndex:indexPath.row];
        NSString *roomIconName = @"greenRoom";
        if(![self.roomsOfInspectionDic objectForKey:[self getSelectLeftInspectionItemId]])
        {
            roomIconName = @"redRoom";
        }
        [cell setCellValue:roomIconName title:[roomDic objectForKey:@"Title"]];
    }
}
-(void)setRightTableCell:(PropertyListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListItem *inspectionitem = nil;
    if(indexPath.section == 0)
    {
        inspectionitem = [self.rightPropertyListDic objectForKey:@"top"];
    }
    else
    {
        NSMutableArray *bottomarray = [self.rightPropertyListDic objectForKey:@"bottom"];
        inspectionitem = [bottomarray objectAtIndex:indexPath.row];
    }
    
    NSDictionary *pro = (NSDictionary *)[inspectionitem getData:@"sl_propertyID"];
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
    BOOL found =  false;
    ListItem *inspectionitem = nil;
    inspectionitem = [self.rightPropertyListDic objectForKey:@"top"];
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
                [self updateRightPropertyTableCell:updateIndexPath image:image];
                found = true;
            }
        }
    }
    if(!found)
    {
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
                        [self updateRightPropertyTableCell:updateIndexPath image:image];
                        found = true;
                        break;
                    }
                }
            }
        }
    }
    if(found && self.selectRightPropertyTableIndexPath == updateIndexPath)
    {
        UITableView * propertyDetailTableView =(UITableView *)[self.view viewWithTag:LeftPropertyDetailTableViewTag];
        [propertyDetailTableView beginUpdates];
        NSIndexPath *upi = [NSIndexPath indexPathForRow:2 inSection:0];
        
        [propertyDetailTableView reloadRowsAtIndexPaths:@[upi] withRowAnimation:UITableViewRowAnimationNone];
        if(self.selectRightPropertyTableIndexPath == updateIndexPath)
        {
            [(UITableView *)[self.view viewWithTag:RightPropertyDetailTableViewTag] selectRowAtIndexPath:updateIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        [propertyDetailTableView endUpdates];
        
        
        //PropertyDetailsImage *up = (PropertyDetailsImage *)[self.propertyDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        // [up.imageView setImage:image];
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
    if(self.selectRightPropertyTableIndexPath != indexpath)
    {
        self.selectRightPropertyTableIndexPath = indexpath;
        self.selectRightPropertyItemId = nil;
        
        self.selectLetInspectionIndexPath = nil;
        self.selectLetRoomIndexPath = nil;
        
        
        //set currentsetId
        ListItem *inspectionitem = nil;
        if(self.selectRightPropertyTableIndexPath.section == 0)
        {
            inspectionitem = [self.rightPropertyListDic objectForKey:@"top"];
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
            NSMutableDictionary *propertydic=[self.propertyDic objectForKey:self.selectRightPropertyItemId];
            if([self.propertyDic objectForKey:self.selectRightPropertyItemId] == nil)
            {
                propertydic = [[NSMutableDictionary alloc] init];
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
}
-(void)didSelectLeftInspectionsTableItem:(NSIndexPath*)indexPath tableview:(UITableView *)tableView
{
    if(self.selectLetInspectionIndexPath !=indexPath)
    {
        self.selectLetInspectionIndexPath = indexPath;
        self.selectLetRoomIndexPath = nil;
        
        InspectionListCell *cell = (InspectionListCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString *stringTemp = [NSString stringWithFormat:@"        %@  |  %@",cell.dateTime.text,cell.owner.text];
        [(UILabel *)[self.view viewWithTag:RightRoomImageDateLblTag] setText:stringTemp];
        if(cell.plusImage.image!=nil)
        {
            [self.view viewWithTag:LeftFinalizeBtnTag].hidden = NO;
        }
        else
        {
            [self.view viewWithTag:LeftFinalizeBtnTag].hidden = YES;
        }
        
    }
    if([self.view viewWithTag:LeftBackButtonViewTag].hidden)
    {
        
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
        [(UITableView *)[self.view viewWithTag:LeftRoomTableViewTag] reloadData];
        [self didSelectLeftRoomTableItem:[NSIndexPath indexPathForRow:0 inSection:0] refresh:YES];
    }
}
-(void)didSelectLeftRoomTableItem:(NSIndexPath *)indexpath refresh:(BOOL)refresh
{
    if([[self.roomsOfInspectionDic objectForKey:[self getSelectLeftInspectionItemId]] count]>=indexpath.row+1)
    {
        
        self.selectLetRoomIndexPath = indexpath;
        if(refresh)
        {
            [(UITableView *)[self.view viewWithTag:LeftRoomTableViewTag] selectRowAtIndexPath:self.selectLetRoomIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        
        //
        //here we will reload right collection view;
        UICollectionView * collectionView = (UICollectionView *)[self.view viewWithTag:RightRoomCollectionViewTag];
        [collectionView reloadData];
        
        self.selectRightCollectionIndexPath =nil;
        [self setRightLargeImage:nil];
        if ([self getRightCollectionViewItemsCount]>0) {
            //load spiner for remote get image file;
            [self startPropertyViewSpiner:CGRectMake(500,384,50,50)];
            self.selectRightCollectionIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [collectionView selectItemAtIndexPath:self.selectRightCollectionIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        
    }
    else
    {
        [self setRightLargeImage:nil];
        UICollectionView * collectionView = (UICollectionView *)[self.view viewWithTag:RightRoomCollectionViewTag];
        [collectionView reloadData];
    }
    
}
#pragma mark - Room Detail Right Collection view
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
        EKNCollectionViewCell *cell = (EKNCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        UIImage *image = [self.commentViewImages objectAtIndex:indexPath.row];
        [cell.imagecell setImage:image];
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
        NSLog(@"collection view %p",cell);
        return cell;
    }
    else if(collectionView.tag == CommentCollectionViewTag)
    {
        
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
#pragma mark - Room Collection cell init value
-(void)setRightCollectionCellValue:(EKNCollectionViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    NSInteger proId = [self.selectRightPropertyItemId intValue];
    NSInteger insId = [[self getSelectLeftInspectionItemId] intValue];
    
    NSArray *roomsArray = [self.roomsOfInspectionDic objectForKey:[NSString stringWithFormat:@"%ld",insId]];
    NSInteger roomIdex =self.selectLetRoomIndexPath.row;
    
    if([roomsArray count]>=roomIdex+1)
    {
        NSDictionary *roomdic = [roomsArray objectAtIndex:roomIdex];
        NSArray *imagesArray = [roomdic objectForKey:@"ImagesArray"];
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
                [cell.imagecell setImage:nil];
                
                if([imagedic objectForKey:@"ServerRelativeUrl"] == nil)
                {
                    NSString *fileId = [imagedic objectForKey:@"Id"];
                    //task read file infor
                    ListClient *client = [self getClient];
                    NSURLSessionTask* getFileResourcetask = [client getListItemFileByFilter:@"Room Inspection Photos"
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
                                                                                         propertyId:proId
                                                                                       inspectionId:insId
                                                                                       roomIndex:roomIdex
                                                                                       imageIndex:indexpath.row];
                                                                     }
                                                                 });
                                                             }];
                    
                    [getFileResourcetask resume];
                }
            }

            
        }
    }
    
}
@end

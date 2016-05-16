//
//  EKNIncidentViewController.m
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNIncidentViewController.h"

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
    
    [self addLeftPanel];
    
    UIImageView *seperatorline = [[UIImageView alloc] initWithFrame:CGRectMake(344, 91, 5, 677)];
    seperatorline.image = [UIImage imageNamed:@"sepratorline"];
    [self.view addSubview:seperatorline];
    
    [self addMiddlePanel];
    [self addRightPanel];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton  setFrame:CGRectMake(0, 350, 15, 71)];
    [self.backButton  setBackgroundImage:[UIImage imageNamed:@"before"] forState:UIControlStateNormal];
    [self.backButton  addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.hidden = YES;
    [self.view addSubview:self.backButton];
    
    [self addSpinner];
    
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
    
    self.incidentPhotoListDic = [[NSMutableDictionary alloc] init];
    self.inspectionDetailDic = [[NSMutableDictionary alloc] init];
    
    self.detailViewIsShowing = NO;
    
    self.incidentMenuArray = [[NSMutableArray alloc] initWithObjects:@"left_nav1",@"left_nav_selected1", @"INCIDENT DETAILS",
                              @"left_nav2",@"left_nav_selected2", @"PROPERTY MEMBERS",
                              @"left_nav3",@"left_nav_selected3", @"CONVERSATIONS",
                              @"left_nav4",@"left_nav_selected4", @"RECENT DOCUMENTS",
                              @"left_nav5",@"left_nav_selected5", @"NOTES",
                              @"left_nav6",@"left_nav_selected6", @"PROPERTY FILES",
                              @"left_nav7",@"left_nav_selected7", @"EMAIL DISPATCHER",nil
                              ];
    self.groupAllFilesDic = [[NSMutableDictionary alloc] init];
}
-(void)addSpinner{
    
    UIView *bkview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bkview.tag = AlertTransparentViewTag;
    [bkview setBackgroundColor:[UIColor colorWithRed:0.00f/255.00f green:0.00f/255.00f blue:0.00f/255.00f alpha:0.3]];
    bkview.hidden = YES;
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(487,359,50,50)];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.spinner setColor:[UIColor blackColor]];
    self.spinner.hidesWhenStopped = YES;
    
    [bkview addSubview:self.spinner];
    [self.view addSubview:bkview];
    
}
//add left middle right view

-(void)addLeftPanel{
    self.leftPanelView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 91, 344, 768)];
    self.leftPanelView.tag = LeftPanelViewTag;
    [self.leftPanelView setBackgroundColor:[UIColor whiteColor]];
    self.leftPanelView.scrollEnabled = NO;
    self.leftPanelView.contentSize = CGSizeMake(344, 1125+40);
    [self.view addSubview:self.leftPanelView];
    [self addSubViewsToLeftPanelView];
}
//left view
-(void)addSubViewsToLeftPanelView{
    
    self.lpsIncidentMenuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -448, 344, 448) style:UITableViewStylePlain];
    self.lpsIncidentMenuTableView.tag = LpsIncidentmenuTableViewTag;
    self.lpsIncidentMenuTableView.hidden = YES;
    self.lpsIncidentMenuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lpsIncidentMenuTableView.backgroundColor = [UIColor colorWithRed:238.00f/255.00f green:238.00f/255.00f blue:238.00f/255.00f alpha:1];
    self.lpsIncidentMenuTableView.delegate = self;
    self.lpsIncidentMenuTableView.dataSource = self;
    [self.lpsIncidentMenuTableView setScrollEnabled:NO];
    
    NSIndexPath *initIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.lpsIncidentMenuTableView selectRowAtIndexPath:initIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.lpsIncidentMenuTableView didSelectRowAtIndexPath:initIndexPath];
    
    [self.leftPanelView addSubview:self.lpsIncidentMenuTableView];
    
    
    self.lpsPropertyDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(25, 9, 315, 349) style:UITableViewStyleGrouped];
    self.lpsPropertyDetailTableView.tag = LpsPropertyDetailTableViewTag;
    self.lpsPropertyDetailTableView.backgroundColor = [UIColor whiteColor];
    self.lpsPropertyDetailTableView.delegate = self;
    self.lpsPropertyDetailTableView.dataSource = self;
    [self.lpsPropertyDetailTableView setScrollEnabled:NO];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    NSString *lbl1str = @"PROPERTY DETAILS";
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 40)];
    lbl1.text = lbl1str;
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = font;
    lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.lpsPropertyDetailTableView.tableHeaderView = lbl1;
    [self.leftPanelView addSubview:self.lpsPropertyDetailTableView];
    
    self.lpsContactOwnerTableView= [[UITableView alloc] initWithFrame:CGRectMake(24, 389, 315, 82) style:UITableViewStyleGrouped];
    self.lpsContactOwnerTableView.tag = LpsContactOwnerTableViewTag;
    self.lpsContactOwnerTableView.backgroundColor = [UIColor whiteColor];
    self.lpsContactOwnerTableView.delegate = self;
    self.lpsContactOwnerTableView.dataSource = self;
    [self.lpsContactOwnerTableView setScrollEnabled:NO];
    
    NSString *lbl2str = @"CONTACT OWNER";
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 40)];
    lbl2.text = lbl2str;
    lbl2.textAlignment = NSTextAlignmentLeft;
    lbl2.font = font;
    lbl2.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.lpsContactOwnerTableView.tableHeaderView = lbl2;
    [self.leftPanelView addSubview:self.lpsContactOwnerTableView];
    
    self.lpsContactOfficeTableView = [[UITableView alloc] initWithFrame:CGRectMake(24, 491, 315, 82) style:UITableViewStyleGrouped];
    self.lpsContactOfficeTableView.tag = LpsContactOfficeTableViewTag;
    self.lpsContactOfficeTableView.backgroundColor = [UIColor whiteColor];
    self.lpsContactOfficeTableView.delegate = self;
    self.lpsContactOfficeTableView.dataSource = self;
    [self.lpsContactOfficeTableView setScrollEnabled:NO];
    
    NSString *lbl3str = @"CONTACT OFFICE";
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 40)];
    lbl3.text = lbl3str;
    lbl3.textAlignment = NSTextAlignmentLeft;
    lbl3.font = font;
    lbl3.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.lpsContactOfficeTableView.tableHeaderView = lbl3;
    [self.leftPanelView addSubview:self.lpsContactOfficeTableView];
    
    
    self.lpsBottomView =[[UIView alloc] initWithFrame:CGRectMake(24, 677, 315, 288)];
    self.lpsBottomView.tag = LpsBottomViewTag;
    self.lpsBottomView.backgroundColor = [UIColor whiteColor];
    self.lpsBottomView.hidden = YES;
    [self.leftPanelView addSubview:self.lpsBottomView];
    
    UITableView *inspectionDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 315, 166) style:UITableViewStyleGrouped];
    inspectionDetailTableView.tag = LpbsInspectionDetailTableViewTag;
    inspectionDetailTableView.backgroundColor = [UIColor whiteColor];
    inspectionDetailTableView.delegate = self;
    inspectionDetailTableView.dataSource = self;
    [inspectionDetailTableView setScrollEnabled:NO];
    
    UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 40)];
    lbl4.text = @"INSPECTION DETAILS";
    lbl4.textAlignment = NSTextAlignmentLeft;
    lbl4.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    lbl4.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    inspectionDetailTableView.tableHeaderView = lbl4;
    [self.lpsBottomView addSubview:inspectionDetailTableView];
    
    UIButton *finalizeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 196, 315, 33)];
    finalizeBtn.tag = LpbsFinalizeBtnTag;
    [finalizeBtn setBackgroundImage:[UIImage imageNamed:@"finalize_repair"] forState:UIControlStateNormal];
    [finalizeBtn addTarget:self action:@selector(updateRepairCompleted) forControlEvents:UIControlEventTouchUpInside];
    [self.lpsBottomView addSubview:finalizeBtn];
    
}
-(void)expandLeftPanel{
    self.lpsIncidentMenuTableView.frame = CGRectMake(0, 0, 344, 448);
    self.lpsIncidentMenuTableView.hidden = NO;
    
    self.lpsPropertyDetailTableView.frame = CGRectMake(25, 448+9, 315, 349);
    
    self.lpsContactOfficeTableView.hidden = YES;
    self.lpsContactOwnerTableView.hidden = YES;
    self.lpsBottomView.frame = CGRectMake(24, 448+9+349+31, 315, 288);
    self.lpsBottomView.hidden = NO;
    
    self.leftPanelView.scrollEnabled = YES;
    
}
-(void)collapseLeftPanel{
    
    self.lpsIncidentMenuTableView.frame = CGRectMake(0, -448, 344, 448);
    self.lpsIncidentMenuTableView.hidden = YES;
    self.lpsPropertyDetailTableView.frame = CGRectMake(25, 9, 315, 349);
    self.lpsContactOfficeTableView.hidden = NO;
    self.lpsContactOwnerTableView.hidden = NO;
    self.lpsBottomView.hidden = YES;
    [self.leftPanelView scrollRectToVisible:CGRectMake(0, 0,344, 768) animated:NO];
    self.leftPanelView.scrollEnabled = NO;
}
//middle view
-(void)addMiddlePanel{
    UITableView *middlePanelTableView = [[UITableView alloc] initWithFrame:CGRectMake(380, 100, 620, 657) style:UITableViewStyleGrouped];
    middlePanelTableView.tag = MpsIncidentsListTableViewTag;
    middlePanelTableView.backgroundColor = [UIColor clearColor];
    [middlePanelTableView setSeparatorColor:[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1]];
    middlePanelTableView.delegate = self;
    middlePanelTableView.dataSource = self;
    [middlePanelTableView.layer setCornerRadius:10.0];
    [middlePanelTableView.layer setMasksToBounds:YES];
    [self.view addSubview: middlePanelTableView];
}

//right view
-(void)addRightPanel
{
    self.rightPanelView = [[UIView alloc] initWithFrame:CGRectMake(1024, 91, 675, 677)];
    self.rightPanelView.tag = RightPanelViewTag;
    [self.view addSubview:self.rightPanelView];
    [self addIncidentDetailViewToRightPanel];
    
    
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

-(void)addIncidentDetailViewToRightPanel{
    EKNIncidentDetailView *incidentDetailView = [[EKNIncidentDetailView alloc] initWithFrame:CGRectMake(0, 0, self.rightPanelView.frame.size.width, self.rightPanelView.frame.size.height)];
    incidentDetailView.tag = RpsIncidentDetailViewTag;
    [incidentDetailView intIncidentDetailView:self.token];
    incidentDetailView.backgroundColor = [UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1];
    incidentDetailView.tag = RpsIncidentDetailViewTag;
    incidentDetailView.actiondelegate = self;
    [self.rightPanelView addSubview:incidentDetailView];
}
//action when select middle view
-(void)didSelectIncidentListTable:(NSIndexPath*)indexpath
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
    
    self.selectGroupId = (NSString *)[(NSDictionary *)[incidentItem getData:@"sl_propertyID"] objectForKey:@"sl_group"];
    NSLog(@"incidentID:%@,inspectionID:%@,roomID:%@,taskID:%@, selectGroupId:%@",self.selectIncidentId,self.selectInspectionId,self.selectRoomId,self.selectTaskId,self.selectGroupId );
    
    //set finalize repair button
    ((UIButton *)[self.view viewWithTag:LpbsFinalizeBtnTag]).hidden = ![EKNEKNGlobalInfo isBlankString:completedDate];
    
    //set the inspection table
    [self.inspectionDetailDic setObject:@"" forKey:@"name"];
    [self.inspectionDetailDic setObject:@"" forKey:@"email"];
    [self.inspectionDetailDic setObject:@"" forKey:@"date"];
    [(UITableView *)[self.view viewWithTag:LpbsInspectionDetailTableViewTag] reloadData];
    [self getInspectionDataByID:inspectionID];
    
    //set room title and incident type
    NSString *detailRoomTitle = [EKNEKNGlobalInfo getString:roomTitle];
    NSString *detailincidentType = [EKNEKNGlobalInfo getString:incidentType];
    
    [(EKNIncidentDetailView *)[self.view viewWithTag:RpsIncidentDetailViewTag]  showIncidentDetailView:detailRoomTitle incidentType:detailincidentType status:status incidentItem:incidentItem inspectionId:self.selectInspectionId incidentId:self.selectIncidentId roomId:self.selectRoomId];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.detailViewIsShowing = YES;
        [self expandLeftPanel];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            UIView *rightPanelView = [self.view viewWithTag:RightPanelViewTag];
            rightPanelView.frame = CGRectMake(349, 91, 675, 677);
            rightPanelView.hidden = NO;
        } completion:^(BOOL finished) {
            self.backButton.hidden = NO;
        }];
    }];
}

-(void)backAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backButton.hidden = YES;
        [self collapseLeftPanel];
    } completion:^(BOOL finished) {
        ((UIView *)[self.view viewWithTag:LpsBottomViewTag]).hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view viewWithTag:RightPanelViewTag].frame = CGRectMake(1024, 91, 675, 677);
        } completion:^(BOOL finished) {
            [self.view viewWithTag:RightPanelViewTag].hidden = YES;
            self.detailViewIsShowing = NO;
        }];
    }];
}

//action delegete
-(void)setGroupData:(NSMutableDictionary *)data key:(NSString *)key groupId:(NSString *)groupId
{
    NSMutableDictionary* dict = [self.groupAllFilesDic objectForKey:key];
    
    if(dict == nil){
        dict = [[NSMutableDictionary alloc] init];
        [self.groupAllFilesDic setObject:dict forKey:key];
    }
    [dict setValue:data forKey:groupId];
    
}
-(EKNListItem *)getSelectIncidentListItem{
    EKNListItem *item = [self.incidentListArray objectAtIndex:self.selectedIndex];
    return item;
}
- (void)presentViewController:(UIViewController *)viewControllerToPresent{
    [self presentViewController:viewControllerToPresent animated:YES completion:NULL];
}
-(void)showLoading
{
    UIView *bkview = [self.view viewWithTag:AlertTransparentViewTag];
    bkview.hidden = NO;
    [self.view bringSubviewToFront:bkview];
    
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
}

-(void)hideLoading
{
    if(self.spinner != nil)
    {
        UIView *bkview = [self.view viewWithTag:AlertTransparentViewTag];
        bkview.hidden = YES;
        [self.view sendSubviewToBack:bkview];
        self.spinner.hidden = YES;
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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

-(void)showSendEmailViewController:(NSString *)address body:(NSString *)body
{
    UIDevice *device =[UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPad Simulator"]) {
        [self showHintAlertView:@"Hint" message:@"Simulator does not support Mail View"];
        return;
    }
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    NSArray *to = [NSArray arrayWithObjects:address, nil];
    
    [mc setToRecipients:to];
    [mc setMessageBody:body isHTML:NO];
    [self presentViewController:mc animated:YES completion:NULL];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//////
///load init data
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
    NSString *filter = [NSString stringWithFormat:@"$select=ID,Title,sl_inspectorIncidentComments,sl_dispatcherComments,sl_repairComments,sl_status,sl_type,sl_date,sl_repairCompleted,sl_inspectionIDId,sl_roomIDId,sl_taskId,sl_inspectionID/ID,sl_inspectionID/sl_datetime,sl_inspectionID/sl_finalized,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_emailaddress,sl_propertyID/sl_group,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode,sl_roomID/ID,sl_roomID/Title&$expand=sl_inspectionID,sl_propertyID,sl_roomID&$filter=sl_propertyIDId eq %@ and sl_inspectionIDId gt 0 and sl_roomIDId gt 0&$orderby=sl_date desc",self.selectPropertyId];
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
                [self.lpsPropertyDetailTableView reloadData];
                [self.lpsContactOwnerTableView reloadData];
                [self.lpsContactOfficeTableView reloadData];
                [((UITableView *)[self.view viewWithTag:MpsIncidentsListTableViewTag])  reloadData];
                
                [self getPropertyPhoto];
                [self getIncidentListPhoto];
            }
        });
    }];
}
//finalize button action
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
                    ((UIButton *)[self.view viewWithTag:LpbsFinalizeBtnTag]).hidden = YES;
                    [((EKNIncidentDetailView *)[self.view viewWithTag:RpsIncidentDetailViewTag]) afterUpdateRepairCompleted:NO];
                    [self hideLoading];
                    [self updateMpsIncidentsListTableCell:self.selectedIndexPath];
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
    EKNGraphService *graph = [[EKNGraphService alloc] init];
    [graph sendMail:emailDataDic callback:^(int returnValue, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             // NSLog(@" send email error %@,%d",error,returnValue);
             if (returnValue ==0) {
                 //
                 [self showHintAlertView:@"Success" message:@"Message sent Success!"];
                 NSLog(@"Send email success.");
             }
             else
             {
                 [self showHintAlertView:@"Failure" message:@"Message sent Failed!"];
                 NSLog(@"Send email failed.");
             }
         });
         
     }];
    
    //update task
     EKNPlanService *service = [[EKNPlanService alloc] init];
    [service updateTask:self.selectGroupId incidentId:self.selectIncidentId callback:^(NSString *error) {
    }];
    //
}

-(void)sendDispatcherEmail
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *address = [standardUserDefaults objectForKey:@"dispatcherEmail"];
    [self showSendEmailViewController:address body:@"IOS Sent dispather Email"];
    
    
    
    /*NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
     NSString *to = [standardUserDefaults objectForKey:@"dispatcherEmail"];
     
     NSMutableDictionary *emailDataDic = [[NSMutableDictionary alloc] init];
     [emailDataDic setObject:@"Sent from ios" forKey:@"subject"];
     [emailDataDic setObject:to forKey:@"to"];
     [emailDataDic setObject:@"Sent from ios" forKey:@"body"];
     
     [self showLoading];
     
     
     EKNGraphService *graph = [[EKNGraphService alloc] init];
     [graph sendMail:emailDataDic callback:^(int returnValue, NSError *error)
     {
     dispatch_async(dispatch_get_main_queue(), ^{
     [self hideLoading];
     if (error ==nil) {
     //
     [self showHintAlertView:@"EMAIL DISPATCHER" message:@"Send email success."];
     NSLog(@"Send email success.");
     }
     else
     {
     [self showHintAlertView:@"EMAIL DISPATCHER" message:@"Send email failed."];
     NSLog(@"Send email failed.");
     }
     });
     }
     ];*/
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
                ((UIButton *)[self.view viewWithTag:LpbsFinalizeBtnTag]).hidden = YES;
                [((EKNIncidentDetailView *)[self.view viewWithTag:RpsIncidentDetailViewTag]) afterUpdateRepairCompleted:NO];
                [self updateMpsIncidentsListTableCell:self.selectedIndexPath];
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
//get inspection detail server data
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
                [(UITableView *)[self.view viewWithTag:LpbsInspectionDetailTableViewTag] reloadData];
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
                    [self.lpsPropertyDetailTableView  reloadData];
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
//get incident list photos of middle view
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
                    [(UITableView *)[self.view viewWithTag:MpsIncidentsListTableViewTag] reloadData];
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
//table view delegete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == MpsIncidentsListTableViewTag)
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
    else if(tableView.tag == LpsPropertyDetailTableViewTag)
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
    else if(tableView.tag == LpsContactOwnerTableViewTag||
            tableView.tag == LpsContactOfficeTableViewTag )
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
    else if(tableView.tag == LpbsInspectionDetailTableViewTag)
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
    else if(tableView.tag == LpsIncidentmenuTableViewTag){
        return 7;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == MpsIncidentsListTableViewTag)
    {
        return 160;
    }
    else if(tableView.tag == LpsPropertyDetailTableViewTag)
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
    else if(tableView.tag == LpsContactOwnerTableViewTag ||
            tableView.tag == LpsContactOfficeTableViewTag ||
            tableView.tag == LpbsInspectionDetailTableViewTag)
    {
        return 42;
    }
    else if(tableView.tag == LpsIncidentmenuTableViewTag){
        return 64;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == MpsIncidentsListTableViewTag)
    {
        return 60;
    }
    else if(tableView.tag == LpsContactOfficeTableViewTag ||
            tableView.tag == LpsContactOwnerTableViewTag ||
            tableView.tag == LpbsInspectionDetailTableViewTag)
    {
        return 0;
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == MpsIncidentsListTableViewTag)
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
    if(tableView.tag == MpsIncidentsListTableViewTag)
    {
        NSString *identifier = [NSString stringWithFormat:@"IncidentListItemCell-%ld-%ld-%ld",tableView.tag,indexPath.section, indexPath.row];
        IncidentListItemCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"IncidentListItemCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [self setMpsIncidentsListTableCell:cell cellForRowAtIndexPath:indexPath];
        return cell;
    }
    else if(tableView.tag ==  LpsIncidentmenuTableViewTag){
        
        NSString *identifier = [NSString stringWithFormat:@"IncidentMenuCell-%ld-%ld-%ld",tableView.tag,indexPath.section, indexPath.row];
        IncidentMenuCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"IncidentMenuCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setCellValue:[self.incidentMenuArray objectAtIndex:indexPath.row*3] selectIconName:[self.incidentMenuArray objectAtIndex:indexPath.row*3+1] menuTitle:[self.incidentMenuArray objectAtIndex:indexPath.row*3+2]];
        return cell;
    }
    else if(tableView.tag == LpsContactOwnerTableViewTag ||
            tableView.tag == LpsContactOfficeTableViewTag )
    {
        NSString *identifier = [NSString stringWithFormat:@"ContactOwnerCell-%ld-%ld-%ld",tableView.tag ,indexPath.section, indexPath.row];
        ContactOwnerCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ContactOwnerCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        if(tableView.tag == LpsContactOfficeTableViewTag )
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
    else if(tableView.tag == LpsPropertyDetailTableViewTag ||
            tableView.tag == LpbsInspectionDetailTableViewTag)
    {
        if(tableView.tag == LpsPropertyDetailTableViewTag)
        {
            
            if(indexPath.row==2)
            {
                NSString *identifier = [NSString stringWithFormat:@"PropertyDetailsImage-%ld-%ld-%ld",tableView.tag,indexPath.section, indexPath.row];
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
                NSString *identifier = [NSString stringWithFormat:@"PropertyDetailsCell-%ld-%ld-%ld",tableView.tag,indexPath.section, indexPath.row];
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
            NSString *identifier = [NSString stringWithFormat:@"InspectionDetailsCell-%ld-%ld-%ld",tableView.tag,indexPath.section, indexPath.row];
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
    if(tableView.tag == MpsIncidentsListTableViewTag)
    {
        [self didSelectIncidentListTable:indexPath];
    }
    else if(tableView.tag == LpsContactOwnerTableViewTag ||
            tableView.tag == LpsContactOfficeTableViewTag)
    {
        ContactOwnerCell *cell =(ContactOwnerCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString *address = cell.emailLable.text;
        [self showSendEmailViewController:address body:@"IOS Repair Demo"];
    }
    else if(tableView.tag == LpbsInspectionDetailTableViewTag)
    {
        if(indexPath.row == 1)
        {
            PropertyDetailsCell *cell = (PropertyDetailsCell *)[tableView cellForRowAtIndexPath:indexPath];
            NSString *address = cell.propertyTitle.text;
            [self showSendEmailViewController:address body:@"IOS Repair Demo"];
        }
    }
    else if(tableView.tag == LpsIncidentmenuTableViewTag){
        IncidentMenuCell * cell =(IncidentMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setCellSatus:YES];
        if(indexPath.row == IncidentDetailsMenu){
            [self.rightPanelView bringSubviewToFront:(EKNIncidentDetailView *)[self.rightPanelView viewWithTag:RpsIncidentDetailViewTag]];
        }
        else if(indexPath.row == EmailDispatcherMenu){
            [self sendDispatcherEmail];
        }
        else if(indexPath.row == NotesMenu
                || indexPath.row == ConversationsMenu
                || indexPath.row == PropertyMembersMenu
                || indexPath.row == ProperyFilesMenu
                || indexPath.row == RecentDocumentsMenu){
            NSInteger commontag;
            NSString *groupkey = nil;
            if(indexPath.row == NotesMenu){
                commontag = RpsOneNoteViewTag;
                groupkey =@"onenote";
            }
            else if(indexPath.row == ConversationsMenu){
                commontag = RpsConversationViewTag;
                groupkey =@"conversations";
            }
            else if(indexPath.row == PropertyMembersMenu){
                commontag = RpsPropertyMembersViewTag;
                groupkey =@"propertymembers";
            }
            else if(indexPath.row == ProperyFilesMenu){
                commontag = RpsPropertyFilesViewTag;
                groupkey = @"propertyfiles";
            }
            else if(indexPath.row == RecentDocumentsMenu){
                commontag = RpsRecentDocumentViewTag;
                groupkey = @"propertyfiles";
            }
            
            EKNPPcommonTableView * commonTable = (EKNPPcommonTableView *)[self.rightPanelView viewWithTag:commontag];
            if( commonTable == nil){
                commonTable = [[EKNPPcommonTableView alloc] initWithFrame:CGRectMake(0, 0, self.rightPanelView.frame.size.width, self.rightPanelView.frame.size.height)];
                [commonTable setBackgroundColor:[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1]];
                commonTable.tag = commontag;
                commonTable.actiondelegate = self;
                [commonTable initPPcommonTableView:self.selectGroupId brecent:(indexPath.row == RecentDocumentsMenu)];
                
                [self.rightPanelView addSubview:commonTable];
                
            }
            [self.rightPanelView bringSubviewToFront:commonTable];
            NSMutableDictionary *groupDic =[[self.groupAllFilesDic objectForKey:groupkey] objectForKey:self.selectGroupId];
            if(groupDic == nil){
                [commonTable getPPcommonTableService:self.selectIncidentId];
            }
            else{
                [commonTable loadPPcommonTableView:groupDic];
            }
            
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == LpsIncidentmenuTableViewTag){
        IncidentMenuCell * cell =(IncidentMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setCellSatus:NO];
    }
}

-(void)setMpsIncidentsListTableCell:(IncidentListItemCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

-(void)updateMpsIncidentsListTableCell:(NSIndexPath *)indexpath
{
    UITableView *incidentListTable = (UITableView *)[self.view viewWithTag:MpsIncidentsListTableViewTag];
    [incidentListTable beginUpdates];
    [incidentListTable reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [incidentListTable endUpdates];
}
@end

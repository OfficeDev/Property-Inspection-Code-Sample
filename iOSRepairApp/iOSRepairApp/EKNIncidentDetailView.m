//
//  EKN.m
//  iOSRepairApp
//
//  Created by canviz on 9/3/15.
//  Copyright (c) 2015 canviz. All rights reserved.
//

#import "EKNIncidentDetailView.h"

@implementation EKNIncidentDetailView
-(id)intIncidentDetailView:(NSString *)token{
    self.token = token;
    [self initData];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    UIView *rightTopView = [[UIView alloc] initWithFrame:CGRectMake(31, 15, 620, 50)];
    rightTopView.backgroundColor = [UIColor colorWithRed:134.00f/255.00f green:134.00f/255.00f blue:134.00f/255.00f alpha:1];
    
    
    CGSize size1 = [EKNEKNGlobalInfo getSizeFromStringWithFont:@"Room" font:font];
    UILabel *roomTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size1.width, 50)];
    roomTitleLbl.text = @"Room";
    roomTitleLbl.tag = RpidsRoomTitleLblTag;
    roomTitleLbl.textAlignment = NSTextAlignmentLeft;
    roomTitleLbl.font = font;
    roomTitleLbl.textColor = [UIColor whiteColor];
    [rightTopView addSubview:roomTitleLbl];
    
    
    UILabel *separatorLbl = [[UILabel alloc] initWithFrame:CGRectMake(10 + size1.width, 5, 40, 40)];
    separatorLbl.text = @"|";
    separatorLbl.tag = RpidsSeparatorLblTag;
    separatorLbl.textAlignment = NSTextAlignmentCenter;
    separatorLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    separatorLbl.textColor = [UIColor whiteColor];
    [rightTopView addSubview:separatorLbl];
    
    CGSize size2 = [EKNEKNGlobalInfo getSizeFromStringWithFont:@"Type" font:font];
    UILabel *incidentTypeLbl = [[UILabel alloc] initWithFrame:CGRectMake((10 + size1.width + 40), 0, size2.width, 50)];
    incidentTypeLbl.text = @"Type";
    incidentTypeLbl.tag = RpidsIncidentTypeLblTag;
    incidentTypeLbl.textAlignment = NSTextAlignmentLeft;
    incidentTypeLbl.font = font;
    incidentTypeLbl.textColor = [UIColor whiteColor];
    [rightTopView addSubview:incidentTypeLbl];
    
    [self addSubview:rightTopView];
    
    UIImageView *rightTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, 90, 620, 64)];
    rightTopImageView.image = [UIImage imageNamed:@"incident_detailtab"];
    [self addSubview:rightTopImageView];
    
    //add tab button
    UIButton *tabBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    tabBtn1.frame = CGRectMake(31, 90, 206, 64);
    tabBtn1.tag = RpidsDispatcherCommentsBtnTag;
    [tabBtn1 addTarget:self action:@selector(rightTabSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tabBtn1];
    UIButton *tabBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    tabBtn2.frame = CGRectMake(237, 90, 207, 64);
    tabBtn2.tag = RpidsInspectorCommentsBtnTag;
    [tabBtn2 addTarget:self action:@selector(rightTabSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tabBtn2];
    UIButton *tabBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    tabBtn3.frame = CGRectMake(444, 90, 207, 64);
    tabBtn3.tag = RpidsAddCommentsBtnTag;
    [tabBtn3 addTarget:self action:@selector(rightTabSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tabBtn3];
    
    self.detailRightDispatcher = [[UIView alloc] initWithFrame:CGRectMake(31, 170, 644, 507)];
    [self addSubview:self.detailRightDispatcher];
    
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
    [self addSubview:self.detailRightInspector];
    
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
    [self addSubview:self.detailRightAdd];
    
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
    
    UIButton *repairCommentDoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(508, 437, 112, 50)];
    repairCommentDoneBtn.tag = RpidsAddCommentsDoneBtnTag;
    repairCommentDoneBtn.backgroundColor = [UIColor colorWithRed:100.00f/255.00f green:153.00f/255.00f blue:209.00f/255.00f alpha:1];;
    [repairCommentDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
    repairCommentDoneBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    repairCommentDoneBtn.titleLabel.textColor = [UIColor whiteColor];
    repairCommentDoneBtn.layer.masksToBounds = YES;
    repairCommentDoneBtn.layer.cornerRadius = 5;
    [repairCommentDoneBtn addTarget:self action:@selector(updateRepairComment) forControlEvents:UIControlEventTouchUpInside];
    [self.detailRightAdd addSubview:repairCommentDoneBtn];
    
    return self;
}

-(void)initData{
    self.client = [[EKNListClient alloc] initWithUrl:[EKNEKNGlobalInfo getSiteUrl]
                                               token: self.token];
    
    self.roomInspectionPhotoDic = [[NSMutableDictionary alloc] init];
    self.repairPhotoDic = [[NSMutableDictionary alloc] init];
    self.cameraIsAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

-(void)setRoomTitleAndIncidentType:(NSString *)title type:(NSString *)type
{
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    NSString *lblStr = [@"Room: " stringByAppendingString:[EKNEKNGlobalInfo getString:title]];
    CGSize size1 = [EKNEKNGlobalInfo getSizeFromStringWithFont:lblStr font:font];
    UILabel *roomTitleLbl =(UILabel *)[self viewWithTag:RpidsRoomTitleLblTag];
    roomTitleLbl.frame = CGRectMake(10, 0, size1.width, 50);
    roomTitleLbl.text = lblStr;
    
    UILabel *separatorLbl =(UILabel *)[self viewWithTag:RpidsSeparatorLblTag];
    separatorLbl.frame = CGRectMake(10 + size1.width, 5, 40, 40);
    
    UILabel *incidentTypeLbl =(UILabel *)[self viewWithTag:RpidsIncidentTypeLblTag];
    NSString *lbl1Str = [@"Type: " stringByAppendingString:[EKNEKNGlobalInfo getString:type]];
    CGSize size2 = [EKNEKNGlobalInfo getSizeFromStringWithFont:lbl1Str font:font];
    incidentTypeLbl.frame = CGRectMake((10 + size1.width + 40), 0, size2.width, 50);
    incidentTypeLbl.text = lbl1Str;
}

-(void)showIncidentDetailView:(NSString *)roomtitle incidentType:(NSString *)incidentType status:(NSString *)status incidentItem:(EKNListItem *)incidentItem
inspectionId:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId
{
    [self setRoomTitleAndIncidentType:roomtitle type:incidentType];
    
    self.selectIncidentId = incidentId;
    self.selectInspectionId = inspectionId;
    self.selectRoomId = roomId;
    
    self.canEditComments = !([status isEqualToString:@"Repair Pending Approval"] || [status isEqualToString:@"Repair Approved"]);
    UIButton * repairCommentDoneBtn = (UIButton *)[self viewWithTag:RpidsAddCommentsDoneBtnTag];
    repairCommentDoneBtn.hidden = !self.canEditComments;
    self.tabComments.editable = self.canEditComments;
    
    
    //set comments [sl_inspectorIncidentComments,sl_dispatcherComments,sl_repairComments]
    self.tabDispatcherComments.text = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"sl_dispatcherComments"]];
    self.tabInsptorComments.text = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"sl_inspectorIncidentComments"]];
    self.tabComments.text = [EKNEKNGlobalInfo getString:(NSString *)[incidentItem getData:@"sl_repairComments"]];
    
    self.detailRightDispatcher.frame = CGRectMake(31, 170, 644, 507);
    self.detailRightInspector.frame = CGRectMake(675, 170, 644, 507);
    self.detailRightAdd.frame = CGRectMake(675, 170, 644, 507);
    self.detailRightInspector.hidden = YES;
    self.detailRightAdd.hidden = YES;
    self.detailRightDispatcher.hidden = NO;
    
    
}

-(void)rightTabSelected:(UIButton *)button
{
    if(button.tag == RpidsDispatcherCommentsBtnTag)
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
    else if(button.tag == RpidsInspectorCommentsBtnTag)
    {
        if(self.detailRightInspector.hidden == YES)
        {
            [self.inspectorCommentCollection reloadData];
            if([self.roomInspectionPhotoDic objectForKey:self.selectIncidentId] == nil)
            {
                [self.actiondelegate showLoading];
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
    else if(button.tag == RpidsAddCommentsBtnTag)
    {
        if(self.detailRightAdd.hidden == YES)
        {
            [self.commentCollection reloadData];
            if([self.repairPhotoDic objectForKey:self.selectIncidentId] == nil)
            {
                [self.actiondelegate showLoading];
                
                [self getRepairVideo:self.selectIncidentId];
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

//get selected inspection photos
-(void)getInspectorPhoto:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId
{
    NSString *filter = [NSString stringWithFormat:@"$select=ID,Title&$filter=sl_inspectionIDId eq %@ and sl_incidentIDId eq %@ and sl_roomIDId eq %@&$orderby=Modified desc",inspectionId,incidentId,roomId];
    NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self.client getListItemsByFilter:@"Room Inspection Photos" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.actiondelegate hideLoading];
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
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFileByServerRelativeUrl('%@%@",[EKNEKNGlobalInfo getSiteUrl],serverRelativeUrl,@"')/$value"];
    
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
-(void)getRepairVideo:(NSString *)incidentId {
    EKNVedioService *videoService =[[EKNVedioService alloc] init];
    [videoService getVideos:[incidentId intValue] callback:^(NSArray *videoItems, MSOrcError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(videoItems != nil && [videoItems count] > 0)
            {
                NSDictionary *dict = [self.repairPhotoDic objectForKey:incidentId];
                if(dict == nil){
                    dict =[[NSMutableDictionary alloc] init];
                    [self.repairPhotoDic setObject:dict forKey:incidentId];
                }
                NSMutableArray *videosArray = [[self.repairPhotoDic objectForKey:incidentId] objectForKey:@"videos"];
                if(videosArray == nil){
                    videosArray = [[NSMutableArray alloc] init];
                    [[self.repairPhotoDic objectForKey:incidentId] setObject:videosArray forKey:@"videos"];
                }
                for (NSDictionary *item in videoItems) {
                    [videosArray addObject:item];
                }
            }
            [self getRepairPhoto:self.selectInspectionId incidentId:self.selectIncidentId roomId:self.selectRoomId];
        });
    }];
}
-(void)getRepairPhoto:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId
{
    NSString *filter = [NSString stringWithFormat:@"$select=ID,Title&$filter=sl_inspectionIDId eq %@ and sl_incidentIDId eq %@ and sl_roomIDId eq %@&$orderby=Modified desc",inspectionId,incidentId,roomId];
    NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self.client getListItemsByFilter:@"Repair Photos" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.actiondelegate hideLoading];
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
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFileByServerRelativeUrl('%@%@",[EKNEKNGlobalInfo getSiteUrl],serverRelativeUrl,@"')/$value"];
    
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
                        
                        NSMutableDictionary *dic = [self.repairPhotoDic objectForKey:incidentId];
                        if(dic == nil){
                            dic = [[NSMutableDictionary alloc] init];
                            [self.repairPhotoDic setObject:dic forKey:incidentId];
                        }
                        
                        NSMutableArray *photos = [dic objectForKey:@"photos"];//
                        if(photos == nil){
                            photos = [[NSMutableArray alloc] init];
                            [dic setObject:photos forKey:@"photos"];
                        }
                        
                        [photos addObject:image];
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

//collection view
-(UIImage *)getCollectionImage:(NSInteger) index{
    NSInteger videosCount = 0;
    if([[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"videos"] != nil){
        videosCount =[[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"videos"] count];
    }
    UIImage *image;
    if(index< videosCount){
        image = [UIImage imageNamed:@"video"];
    }
    else{
        NSMutableArray *imageArray = (NSMutableArray *)[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"];
        image = imageArray[index - videosCount];
    }
    return image;
}
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
        if([self.repairPhotoDic objectForKey:self.selectIncidentId] != nil)
        {
            NSInteger photosCount = 0;
            NSInteger videosCount = 0;
            if([[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"] != nil){
                photosCount = [[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"] count];
            }
            if([[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"videos"] != nil){
                videosCount =[[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"videos"] count];
            }
            return photosCount+videosCount;
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
        [self.actiondelegate showLargePhoto:image];
    }
    else
    {
        NSInteger videosCount = 0;
        if([[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"videos"] != nil){
            videosCount =[[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"videos"] count];
        }
        if(indexPath.row < videosCount){
            NSDictionary *item = (NSDictionary *)[[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"videos"] objectAtIndex:indexPath.row];
            NSString *weburl =[item objectForKey:@"webUrl"];
            if (weburl!=nil) {
                [EKNEKNGlobalInfo openUrl:weburl];
            }
        }
        else{
            NSMutableArray *imageArray = (NSMutableArray *)[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"];
            image = imageArray[indexPath.row-videosCount];
            [self.actiondelegate showLargePhoto:image];
        }
        
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID= @"cvCell";
    EKNCollectionViewCell *cell = (EKNCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    UIImage *image;
    if(collectionView == self.inspectorCommentCollection)
    {
        NSMutableArray *imageArray = (NSMutableArray *)[[self.roomInspectionPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"photos"];
        image = imageArray[indexPath.row];
    }
    else
    {
        image = [self getCollectionImage:indexPath.row];

    }
    [cell setImage:image];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 116);
}

-(void)afterUpdateRepairCompleted:(BOOL)canEdit{
    self.canEditComments = canEdit;
    ((UIButton *)[self viewWithTag:RpidsAddCommentsDoneBtnTag]).hidden = !canEdit;
    self.tabComments.editable = canEdit;
}
// add comment done button
- (void)updateRepairComment
{
    [self.actiondelegate showLoading];
    NSString *repairComments = [EKNEKNGlobalInfo getString:self.tabComments.text];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/lists/GetByTitle('%@')/Items(%@)",[EKNEKNGlobalInfo getSiteUrl],@"Incidents",self.selectIncidentId];
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
            [self.actiondelegate hideLoading];
            if([EKNEKNGlobalInfo requestSuccess:response])
            {
                EKNListItem *item = [self.actiondelegate getSelectIncidentListItem];
                NSMutableDictionary *dic = (NSMutableDictionary *)[item valueForKey:@"_jsonData"];
                [dic setValue:repairComments forKey:@"sl_repairComments"];
                [self.actiondelegate showSuccessMessage:@"Update repair comments successfully."];
            }
            else
            {
                [self.actiondelegate showErrorMessage:@"Update repair comments failed."];
            }
        });
    }];
    [task resume];
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
                 otherButtonTitles: @"Select Photo",@"New Photo",@"New Video",nil];
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
    [sheet showInView:self.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && self.cameraIsAvailable)//take new photo
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self openCamera];
        }];
    }
    else if(buttonIndex == 2 && self.cameraIsAvailable){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self openVideo:UIImagePickerControllerSourceTypeCamera];
        }];
    }
    else if(buttonIndex == 0)//select photo library
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self selectPicture];
        }];
    }
}
-(void)openVideo:(NSInteger) sourceType{

        if(sourceType == UIImagePickerControllerSourceTypeCamera){
            NSArray * availableMediaTyps = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            BOOL canTakeVideo = NO;
            for (NSString * mediaType in availableMediaTyps) {
                if([mediaType isEqualToString:(NSString *) kUTTypeMovie]){
                    canTakeVideo = YES;
                    break;
                }
            }
            if(!canTakeVideo){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Error accessing media"
                                      message:@"Device doesn't support that media source."
                                      delegate:nil
                                      cancelButtonTitle:@"Error"
                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
        }
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = sourceType;
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
        imagePickerController.videoMaximumDuration = 20;
        imagePickerController.allowsEditing = NO;
        imagePickerController.delegate = self;
        
        [self.actiondelegate presentViewController:imagePickerController];
    
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
        [self.actiondelegate presentViewController:picker];
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
    
    NSString *mediaType =[info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
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
        
        [self.actiondelegate showLoading];
        [self.client uploadImageToRepairPhotos:self.token image:thumb inspectionId:self.selectInspectionId incidentId:self.selectIncidentId roomId:self.selectRoomId callback:^(NSError *error) {
            [self.actiondelegate hideLoading];
            if(error != nil)
            {
                [self.actiondelegate showErrorMessage:@"Upload image failed."];
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
    else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        NSData *data = [NSData dataWithContentsOfURL:mediaURL];
        
        
        EKNVedioService *videoService =[[EKNVedioService alloc] init];
        [self.actiondelegate showLoading];
        NSString *filename = [EKNEKNGlobalInfo createFileName:@".mp4"];
        [videoService uploadVideo:[NSString stringWithFormat:@"IncidentRepairVideo_[%@]",self.selectIncidentId] fileName:filename fileData:data description:@"" callback:^(SPVideoItem *videoItem, MSOrcError *error) {
             [self.actiondelegate hideLoading];
            if(error != nil)
            {
                [self.actiondelegate showErrorMessage:@"Upload video failed."];
            }
            else
            {
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:videoItem.Title forKey:@"title"];
                [item setObject:videoItem.YammerObjectUrl forKey:@"webUrl"];
                
                if([self.repairPhotoDic objectForKey:self.selectIncidentId] != nil && [[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"videos"] != nil)
                {
                    [[[self.repairPhotoDic objectForKey:self.selectIncidentId] objectForKey:@"videos"] addObject:item];
                }
                else
                {
                    NSMutableDictionary *dic = [self.repairPhotoDic objectForKey:self.selectIncidentId];
                    if(dic == nil){
                        dic = [[NSMutableDictionary alloc] init];
                        [self.repairPhotoDic setObject:dic forKey:self.selectIncidentId];
                    }
                    NSMutableArray * video =[dic objectForKey:@"videos"];
                    if(video==nil){
                        video =[[NSMutableArray alloc] init];
                        [dic setObject:video forKey:@"videos"];
                    }
                    [video addObject:item];
                }
                [self.commentCollection reloadData];
            }
            NSLog(@"videoItem %@",videoItem.YammerObjectUrl);
        }];
        
        
        
    }
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end

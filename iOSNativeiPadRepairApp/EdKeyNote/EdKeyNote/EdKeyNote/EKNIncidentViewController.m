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
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 91, 344, 768)];
    [leftview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:leftview];
    
    UIImageView *seperatorline = [[UIImageView alloc] initWithFrame:CGRectMake(344, 91, 5, 677)];
    seperatorline.image = [UIImage imageNamed:@"sepratorline"];
    [self.view addSubview:seperatorline];
    
    [self addPropertyDetailTable];
    [self addRightTable];
    [self addIncidentDetailView];
    [self loadData];
}

-(void)initData
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    self.siteUrl = [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"];
    self.incidentPhotoListDic = [[NSMutableDictionary alloc] init];
    
    self.detailViewIsShowing = YES;
    self.selectPropertyId = @"1";//for test
    self.loginName = @"Rob Barker";//for test
    self.currentRightIndexPath = nil;
    
    self.inspectionDetailDic = [[NSMutableDictionary alloc] init];
    //test data
    [self.inspectionDetailDic setObject:@"Carl Spackler" forKey:@"name"];
    [self.inspectionDetailDic setObject:@"cspackler@cpm.com" forKey:@"email"];
    [self.inspectionDetailDic setObject:@"09/30/14" forKey:@"date"];
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
    [self.detailLeftView addSubview:self.finalizeBtn];
    
    self.detailRightView = [[UIView alloc] initWithFrame:CGRectMake(1024, 91, 680, 677)];
    self.detailRightView.backgroundColor = [UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1];
    self.detailRightView.hidden = YES;
    [self.view addSubview:self.detailRightView];
    
    UIView *rightTopView = [[UIView alloc] initWithFrame:CGRectMake(31, 15, 620, 50)];
    rightTopView.backgroundColor = [UIColor colorWithRed:134.00f/255.00f green:134.00f/255.00f blue:134.00f/255.00f alpha:1];
    [self.detailRightView addSubview:rightTopView];
    NSString *lbl4Str = @"Room:Kitchen";
    CGSize size1 = [EKNEKNGlobalInfo getSizeFromStringWithFont:lbl4Str font:font];
    UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size1.width, 50)];
    lbl4.text = lbl4Str;
    lbl4.textAlignment = NSTextAlignmentLeft;
    lbl4.font = font;
    lbl4.textColor = [UIColor whiteColor];
    [rightTopView addSubview:lbl4];
    
    UILabel *lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(10 + size1.width, 5, 40, 40)];
    lbl5.text = @"|";
    lbl5.textAlignment = NSTextAlignmentCenter;
    lbl5.font = font;
    lbl5.textColor = [UIColor whiteColor];
    [rightTopView addSubview:lbl5];
    
    NSString *lbl6Str = @"Type:Plumbing";
    CGSize size2 = [EKNEKNGlobalInfo getSizeFromStringWithFont:lbl6Str font:font];
    UILabel *lbl6 = [[UILabel alloc] initWithFrame:CGRectMake((10 + size1.width + 40), 0, size2.width, 50)];
    lbl6.text = lbl6Str;
    lbl6.textAlignment = NSTextAlignmentLeft;
    lbl6.font = font;
    lbl6.textColor = [UIColor whiteColor];
    [rightTopView addSubview:lbl6];
    
    UIImageView *rightTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, 90, 620, 64)];
    rightTopImageView.image = [UIImage imageNamed:@"incident_detailtab"];
    [self.detailRightView addSubview:rightTopImageView];
    
    UILabel *lbl7 = [[UILabel alloc] initWithFrame:CGRectMake(31, 170, 620, 30)];
    lbl7.text = @"DISPATCHER COMMENTS";
    lbl7.textAlignment = NSTextAlignmentLeft;
    lbl7.font = [UIFont fontWithName:@"Helvetica" size:30];
    lbl7.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    [self.detailRightView addSubview:lbl7];
    
    UIView *rightCommentBgView = [[UIView alloc] initWithFrame:CGRectMake(31, 220, 620, 400)];
    rightCommentBgView.backgroundColor = [UIColor whiteColor];
    rightCommentBgView.layer.masksToBounds = YES;
    rightCommentBgView.layer.cornerRadius = 10;
    [self.detailRightView addSubview:rightCommentBgView];
    
    UILabel *lbl8 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 600, 380)];
    lbl8.text = @"Duis fringilla rutrum urna. Integer vel justo ut sem egestas ullamcorper. Nullam feugiat lacus eu lectus lacinia, id gravida enim vulputate. Pellentesque posuere nunc quis pharetra pulvinar. Morbi vehicula sed libero eget bibendum. Ut convallis pellentesque purus, in mollis justo suscipit id. Maecenas fringilla, odio nec euismod consectetur, sem tortor rutrum nisl, in efficitur lorem dui sed dui. Aenean urna lectus, pulvinar sed dapibus quis, consectetur a justo. Vivamus eu ante lectus. Phasellus consequat orci lorem, sed sollicitudin augue facilisis eget. Nulla fringilla nibh ullamcorper tellus pellentesque, nec aliquet tellus vehicula. Nullam commodo fermentum tempor";
    lbl8.textAlignment = NSTextAlignmentLeft;
    lbl8.font = [UIFont fontWithName:@"Helvetica" size:14];
    lbl8.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    lbl8.numberOfLines = 0;
    lbl8.lineBreakMode = UILineBreakModeWordWrap;
    [rightCommentBgView addSubview:lbl8];
}

-(void)setRightTableSelectIndex:(NSIndexPath*)indexpath
{
    ListItem *incidentItem = [self.incidentListArray objectAtIndex:indexpath.row];
    NSString *incidentID = (NSString *)[incidentItem getData:@"ID"];
    NSDictionary *propertyData = (NSDictionary *)[incidentItem getData:@"sl_propertyID"];
    NSDictionary *inspectionData = (NSDictionary *)[incidentItem getData:@"sl_inspectionID"];
    
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

-(void)loadData{
    
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0,1024,768)];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.spinner setBackgroundColor:[UIColor colorWithRed:0.00f/255.00f green:0.00f/255.00f blue:0.00f/255.00f alpha:0.2]];
    [self.view addSubview:self.spinner];
    self.spinner.hidesWhenStopped = YES;
    
    [self.spinner startAnimating];
    
    NSString *filter = [NSString stringWithFormat:@"$select=ID,Title,sl_inspectorIncidentComments,sl_dispatcherComments,sl_repairComments,sl_status,sl_type,sl_date,sl_inspectionIDId,sl_roomIDId,sl_inspectionID/ID,sl_inspectionID/sl_datetime,sl_inspectionID/sl_finalized,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_emailaddress,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode,sl_roomID/ID,sl_roomID/Title&$expand=sl_inspectionID,sl_propertyID,sl_roomID&$filter=sl_propertyIDId eq %@ and sl_inspectionIDId gt 0 and sl_roomIDId gt 0&$orderby=sl_date desc",self.selectPropertyId];
    NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"filter string:%@",filterStr);
    
    ListClient* client = [self getClient];
    
    
    NSURLSessionTask* task = [client getListItemsByFilter:@"Incidents" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //NSMutableArray *list = [[NSMutableArray alloc] init];
            //ListItem* currentInspectionData = [[ListItem alloc] init];
            
            self.incidentListArray = listItems;
            
            //for (ListItem* item in listItems) {
            //    [self.incidentListDic setObject:item forKey:(NSString *)[item getData:@"ID"]];
            //}
            
            if(listItems != nil && [listItems count] > 0)
            {
                ListItem *item = listItems[0];
                NSDictionary *property = (NSDictionary *)[item getData:@"sl_propertyID"];
                self.propertyDetailDic = property;
                
                [self.propertyDetailTableView reloadData];
                [self.contactOwnerTableView reloadData];
                [self.contactOfficeTableView reloadData];
                [self.rightTableView reloadData];
            }
            
            [self getPropertyPhoto:client];
            [self getIncidentListPhoto:client];
        });
    }];
    
    [task resume];
}

-(void)getPropertyPhoto:(ListClient *)client
{
    NSURLSessionTask* task = [client getListItemsByFilter:@"Property Photos" filter:@"$select=ID,Title&$filter=sl_propertyIDId%20eq%202&$orderby=Modified%20desc&$top=1" callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if(listItems != nil && [listItems count] == 1)
            {
                NSString *propertyPhotoFileID = (NSString *)[listItems[0] getData:@"ID"];
                [self.propertyDetailDic setValue:propertyPhotoFileID forKey:@"photoID"];
                //NSLog(@"Get property photo ID success");
                [self getPropertyPhotoServerRelativeUrl:client];
            }
        });
    }];
    [task resume];
}

-(void)getPropertyPhotoServerRelativeUrl:(ListClient *)client
{
    NSURLSessionTask* getFileResourcetask = [client getListItemFileByFilter:@"Property Photos"
                                                                     FileId:(NSString *)[self.propertyDetailDic objectForKey:@"photoID"]
                                                                     filter:@"$select=ServerRelativeUrl"
                                                                   callback:^(NSMutableArray *listItems, NSError *error)
                                             {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     if(listItems != nil && [listItems count] > 0)
                                                     {
                                                         [self.propertyDetailDic setValue:[listItems[0] getData:@"ServerRelativeUrl"] forKey:@"photoServerRelativeUrl"];
                                                         //NSLog(@"Get property photo ServerRelativeUrl success");
                                                         [self getPhoto];
                                                     }
                                                 });
                                                 
                                             }];
    
    [getFileResourcetask resume];
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
            if (error == nil) {
                UIImage *image =[[UIImage alloc] initWithData:data];
                [self.propertyDetailDic setValue:image forKey:@"photo"];
                NSLog(@"property table reload");
                [self.propertyDetailTableView reloadData];
            }
            else
            {
                //retry one
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

-(void)getIncidentListPhoto:(ListClient *)client
{
    int index = 0;
    for (ListItem* item in self.incidentListArray) {
        
        NSString *incidentID = (NSString *)[item getData:@"ID"];
        NSString *inspectionID =(NSString *)[item getData:@"sl_inspectionIDId"];
        NSString *roomID = (NSString *)[item getData:@"sl_roomIDId"];
        
        NSString *filter = [NSString stringWithFormat:@"$select=ID,Title&$filter=sl_inspectionIDId eq %@ and sl_incidentIDId eq %@ and sl_roomIDId eq %@&$orderby=Modified desc&$top=1",inspectionID,incidentID,roomID];
        
        NSString *filterStr = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"incident photo filter url:%@",filterStr);
        NSURLSessionTask* task = [client getListItemsByFilter:@"Room Inspection Photos" filter:filterStr callback:^(NSMutableArray *listItems, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(listItems != nil && [listItems count] == 1)
                {
                    NSString *photoID = (NSString *)[listItems[0] getData:@"ID"];
                    NSLog(@"Get incident photo ID success,%@",photoID);
                        [self getRoomInspectionPhotoServerRelativeUrl:client photoID:photoID incidentID:incidentID index:index];
                }
            });
        }];
        [task resume];
        index = index + 1;
    }
}

-(void)getRoomInspectionPhotoServerRelativeUrl:(ListClient *)client photoID:(NSString *)photoID incidentID:(NSString *)incidentID index:(NSInteger)index
{
    NSURLSessionTask* getFileResourcetask = [client getListItemFileByFilter:@"Room Inspection Photos"
                                                                     FileId:photoID
                                                                     filter:@"$select=ServerRelativeUrl"
                                                                   callback:^(NSMutableArray *listItems, NSError *error)
                                             {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     if(listItems != nil && [listItems count] > 0)
                                                     {
                                                         NSString *serverRelativeUrl = (NSString *)[listItems[0] getData:@"ServerRelativeUrl"];
                                                         [self getRoomInspectionPhoto:serverRelativeUrl incidentID:incidentID index:index];
                                                     }
                                                 });
                                                 
                                             }];
    
    [getFileResourcetask resume];
}

-(void)getRoomInspectionPhoto:(NSString *)serverRelativeUrl incidentID:(NSString *)incidentID index:(NSInteger)index
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
            ListItem* tempItem = [self.incidentListArray objectAtIndex:index];
            if (error == nil) {
                UIImage *image =[[UIImage alloc] initWithData:data];
                //[tempItem setValue:@"test" forKey:@"photo"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [self.incidentPhotoListDic setObject:dic forKey:incidentID];
                [[self.incidentPhotoListDic objectForKey:incidentID] setObject:image forKey:@"photo"];
                //NSIndexPath *updateIndexPath =[NSIndexPath indexPathForRow:index inSection:0];
                //[self didUpdateRightTableCell:updateIndexPath image:image];
                
                [self.rightTableView reloadData];
            }
            else
            {
                //retry one
                if([[self.incidentPhotoListDic objectForKey:incidentID] objectForKey:@"trytimes"]!=nil)
                {
                    NSInteger times =(NSInteger)[[self.incidentPhotoListDic objectForKey:incidentID] objectForKey:@"trytimes"];
                    if(times>=3)
                    {
                        
                    }
                    else
                    {
                        times=times+1;
                        [[self.incidentPhotoListDic objectForKey:incidentID] setObject:[NSString stringWithFormat:@"%ld",(long)times] forKey:@"trytimes"];
                        [self getPhoto];
                    }
                }
                else
                {
                    [[self.incidentPhotoListDic objectForKey:incidentID] setObject:@"1" forKey:@"trytimes"];
                    [self getRoomInspectionPhoto:serverRelativeUrl incidentID:incidentID index:index];
                }
            }
        });
    }];
    [task resume];
}

-(void)getPropertyResourceListArray:(ListClient*)client
{
    NSURLSessionTask* getpropertyResourcetask = [client getListItemsByFilter:@"Property Photos" filter:@"$select=sl_propertyIDId,Id" callback:^(NSMutableArray * listItems, NSError *error)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         //NSLog(@"get photo success,%@,%@",listItems,error);
                                                         //self.propertyResourceListArray =listItems;
                                                         //[self getPropertyResourceFile:client PropertyResourceItems:listItems];
                                                     });
                                                 }];
    
    [getpropertyResourcetask resume];
}

-(void)getPropertyResourceFile:(ListClient*)client  PropertyResourceItems:(NSMutableArray* )listItems
{
    NSMutableString* loopindex = [[NSMutableString alloc] initWithString:@"0"];
    NSMutableArray *loopitems =listItems;
    self.propertyDic = [[NSMutableDictionary alloc] init];
    
    for (ListItem* tempitem in loopitems)
    {
        NSString *propertyId =[NSString stringWithFormat:@"%@",[tempitem getData:@"sl_propertyIDId"]];
        
        NSURLSessionTask* getFileResourcetask = [client getListItemFileByFilter:@"Property%20Photos"
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
                                                         
                                                         //NSLog(@"propertyId %@",propertyId);
                                                         if(preindex == [loopitems count])
                                                         {
                                                             //get Incidents list
                                                             [self getIncidentsListArray:client];
                                                             
                                                         }
                                                         [loopindex setString:[NSString stringWithFormat:@"%d",preindex]];
                                                         //NSLog(@"loopindex %@",loopindex);
                                                     });
                                                     
                                                 }];
        
        [getFileResourcetask resume];
    }
}

-(void)getIncidentsListArray:(ListClient*)client
{
    self.incidentOfInspectionDic = [[NSMutableDictionary alloc] init];
    
    NSURLSessionTask* getincidentstask = [client getListItemsByFilter:@"Incidents" filter:@"$select=sl_inspectionIDId,Id"  callback:^(NSMutableArray *        listItems, NSError *error)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  for (ListItem* tempitem in listItems) {
                                                      NSString *key =[NSString stringWithFormat:@"%@",[tempitem getData:@"sl_inspectionIDId"]];
                                                      
                                                      if(![self.incidentOfInspectionDic objectForKey:key])
                                                      {
                                                          [self.incidentOfInspectionDic setObject:@"red" forKey:key];
                                                      }
                                                  }
                                                  
                                                  //get current property inspection list
                                                  //[self GetInspectionListAccordingPropertyId:self.selectPropertyId];
                                                  //right table need reload data
                                                  [self.rightTableView reloadData];
                                                  NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:0];
                                                  [self.rightTableView selectRowAtIndexPath:temp animated:NO scrollPosition:UITableViewScrollPositionNone];
                                                  [self setRightTableSelectIndex:temp];
                                                  
                                                  //get images
                                                  [self getAllImageFiles:client];
                                                  //
                                                  [self.spinner stopAnimating];
                                                  
                                              });
                                          }];
    [getincidentstask resume];
}


-(void)getAllImageFiles:(ListClient*)client
{
    NSArray *prokeys = [self.propertyDic allKeys];
    for (NSString *key in prokeys) {
        [self getFile:key];
    }
}

-(void)getFile:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *siteUrl = [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"];
    
    NSMutableDictionary *prodict = [self.propertyDic objectForKey:key];
    NSString *path =[prodict objectForKey:@"ServerRelativeUrl"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/_api/web/GetFileByServerRelativeUrl('%@%@",siteUrl,path,@"')/$value"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.token];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error == nil) {
                
                UIImage *image =[[UIImage alloc] initWithData:data];
                [[self.propertyDic objectForKey:key] setObject:image
                                                        forKey:@"image"];
                [self updateTableCellImage:key image:image];
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
                        [self getFile:key];
                    }
                }
                else
                {
                    [[self.propertyDic objectForKey:key] setObject:@"1" forKey:@"trytimes"];
                    [self getFile:key];
                }
            }
        });
    }];
    [task resume];
}

-(void)updateTableCellImage:(NSString *)proid image:(UIImage *)image
{
    BOOL found =  false;
    ListItem *inspectionitem = nil;
    inspectionitem = [self.rightPannelListDic objectForKey:@"top"];
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
                [self didUpdateRightTableCell:updateIndexPath image:image];
                found = true;
            }
        }
    }
    if(!found)
    {
        NSMutableArray *bottomarray = [self.rightPannelListDic objectForKey:@"bottom"];
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
                        [self didUpdateRightTableCell:updateIndexPath image:image];
                        found = true;
                        break;
                    }
                }
            }
        }
    }
    if(found && self.currentRightIndexPath == updateIndexPath)
    {
        [self.propertyDetailTableView beginUpdates];
        NSIndexPath *upi = [NSIndexPath indexPathForRow:2 inSection:0];
        
        [self.propertyDetailTableView reloadRowsAtIndexPaths:@[upi] withRowAnimation:UITableViewRowAnimationNone];
        if(self.currentRightIndexPath == updateIndexPath)
        {
            [self.rightTableView selectRowAtIndexPath:updateIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        [self.propertyDetailTableView endUpdates];
        
        
        //PropertyDetailsImage *up = (PropertyDetailsImage *)[self.propertyDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        // [up.imageView setImage:image];
    }
}

-(void)didUpdateRightTableCell:(NSIndexPath *)indexpath image:(UIImage*)image
{
    [self.rightTableView beginUpdates];
    [self.rightTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [self.rightTableView endUpdates];
}

-(ListClient*)getClient{
    OAuthentication* authentication = [OAuthentication alloc];
    [authentication setToken:self.token];
    return [[ListClient alloc] initWithUrl:self.siteUrl credentials: authentication];
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
        if(self.detailViewIsShowing && self.inspectionDetailDic != nil)
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
        //NSDictionary *attributes = @{NSFontAttributeName:font};
        //CGSize lbsize = [lbl1str sizeWithAttributes:attributes];
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
        [cell.imageView setBackgroundColor:[UIColor blackColor]];
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
            NSString *contactOwner = [self.propertyDetailDic objectForKey:@"sl_emailaddress"];
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
                NSString *address = [self.propertyDetailDic objectForKey:@"sl_address1"];
                UIImage *image =(UIImage *)[self.propertyDetailDic objectForKey:@"photo"];
                //NSLog(@"address:%@",address);
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
                    NSString *title = [self.propertyDetailDic objectForKey:@"Title"];
                    [cell setCellValue:[UIImage imageNamed:@"home"] title:title];
                }
                else
                {
                    NSString *title = [self.propertyDetailDic objectForKey:@"sl_owner"];
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
                NSString *name = [self.inspectionDetailDic objectForKey:@"name" ];
                [cell setCellValue:[UIImage imageNamed:@"man"] title:name];
            }
            else if(indexPath.row == 1)
            {
                NSString *email = [self.inspectionDetailDic objectForKey:@"email" ];
                [cell setCellValue:[UIImage imageNamed:@"email"] title:email];
            }
            else
            {
                NSString *date = [self.inspectionDetailDic objectForKey:@"date"];
                [cell setCellValue:[UIImage imageNamed:@"calendar"] title:date];
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
}

-(void)setRightTableCell:(IncidentListItemCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListItem *incidentItem = nil;
    incidentItem = [self.incidentListArray objectAtIndex:indexPath.row];
    
    NSString *incidentID = (NSString *)[incidentItem getData:@"ID"];
    NSDictionary *propertyData = (NSDictionary *)[incidentItem getData:@"sl_propertyID"];
    NSDictionary *inspectionData = (NSDictionary *)[incidentItem getData:@"sl_inspectionID"];
    NSDictionary *roomData = (NSDictionary *)[incidentItem getData:@"sl_roomID"];
    
    if(propertyData != nil && inspectionData != nil && roomData != nil)
    {
        NSString *room = (NSString *)[roomData objectForKey:@"Title"];
        NSString *incident = (NSString *)[incidentItem getData:@"Title"];
        NSString *inspectionDate = [EKNEKNGlobalInfo converStringToDateString:(NSString *)[inspectionData objectForKey:@"sl_datetime"]];
        NSString *repairDate = [EKNEKNGlobalInfo converStringToDateString:(NSString *)[inspectionData objectForKey:@"sl_finalized"]];
        //NSLog(@"date time:%@,%@",inspectionDate,[inspectionData objectForKey:@"sl_datetime"]);
        //NSLog(@"date time:%@,%@",repairDate,[inspectionData objectForKey:@"sl_finalized"]);
        NSString *approved = (NSString *)[incidentItem getData:@"sl_status"];
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
@end

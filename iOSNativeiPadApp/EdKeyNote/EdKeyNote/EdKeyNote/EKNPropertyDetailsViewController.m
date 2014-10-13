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
//@synthesize mapView ;

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
    leftview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftview];
    
    UIImageView *speratorline = [[UIImageView alloc] initWithFrame:CGRectMake(344, 91, 5, 677)];
    speratorline.image = [UIImage imageNamed:@"sepratorline"];
    [self.view addSubview:speratorline];
    
    [self addSegementControl];
    [self addRightTable];
    [self addProopertyDetailTable];
    [self addInspectionsTable];
    
    [self loadData];
}
-(void)initData
{
    //init extern data
    self.selectPrppertyId = @"1";//for test
    self.loginName = @"Rob Barker";
    //cloris will modify
    
    
    self.currentRightIndexPath = nil;
}
-(void)addSegementControl
{
    UIImageView * bkimg =[[UIImageView alloc] initWithFrame:CGRectMake(24, 405, 316, 54)];
    [bkimg setImage:[UIImage imageNamed:@"seg"]];
    [self.view addSubview:bkimg];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(24, 405, 105, 54)];
    [left addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left];
    
    UIButton *mid = [UIButton buttonWithType:UIButtonTypeCustom];
    [mid setFrame:CGRectMake(129, 405, 105, 54)];
    [mid addTarget:self action:@selector(midButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mid];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(234, 405, 106, 54)];
    [right addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
    
}
-(void)leftButtonClicked
{
    if(self.inspectionLeftTableView.hidden == YES)
    {
        self.inspectionLeftTableView.hidden =NO;
        self.inspectionMidTableView.hidden = YES;
        self.inspectionRightTableView.hidden = YES;
    }
}
-(void)midButtonClicked
{
    if(self.inspectionMidTableView.hidden == YES)
    {
        self.inspectionLeftTableView.hidden =YES;
        self.inspectionMidTableView.hidden = NO;
        self.inspectionRightTableView.hidden = YES;
    }
}
-(void)rightButtonClicked
{
    if(self.inspectionRightTableView.hidden == YES)
    {
        self.inspectionLeftTableView.hidden =YES;
        self.inspectionMidTableView.hidden = YES;
        self.inspectionRightTableView.hidden = NO;
    }
}
-(void)addInspectionsTable
{
    self.inspectionLeftTableView = [[UITableView alloc] initWithFrame:CGRectMake(24, 480, 320, 235) style:UITableViewStyleGrouped];
    self.inspectionLeftTableView.backgroundColor = [UIColor whiteColor];
    self.inspectionLeftTableView.delegate = self;
    self.inspectionLeftTableView.dataSource = self;
    [self.inspectionLeftTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    NSString *lbl1str = @"INSPECTIONS";
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    lbl1.text = lbl1str;
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = font;
    lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.inspectionLeftTableView.tableHeaderView = lbl1;
    [self.view addSubview:self.inspectionLeftTableView];
    
    self.inspectionMidTableView = [[UITableView alloc] initWithFrame:CGRectMake(24, 480, 320, 235) style:UITableViewStyleGrouped];
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
    
    self.inspectionRightTableView = [[UITableView alloc] initWithFrame:CGRectMake(24, 480, 320, 235) style:UITableViewStyleGrouped];
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
-(void)addProopertyDetailTable{
    
    self.propertyDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(25, 100, 315, 300) style:UITableViewStyleGrouped];
    
    self.propertyDetailTableView.backgroundColor = [UIColor whiteColor];
    //self.propertyDetailTableView.separatorColor = [UIColor clearColor];
    self.propertyDetailTableView.delegate = self;
    self.propertyDetailTableView.dataSource = self;
    //[self.propertyDetailTableView.layer setCornerRadius:10.0];
    //[self.propertyDetailTableView.layer setMasksToBounds:YES];
    [self.propertyDetailTableView setScrollEnabled:NO];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    NSString *lbl1str = @"PROPERTY DETAILS";
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 25)];
    lbl1.text = lbl1str;
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = font;
    lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    self.propertyDetailTableView.tableHeaderView = lbl1;
    [self.view addSubview:self.propertyDetailTableView];
}
-(void)addRightTable{
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(380, 100, 620, 635) style:UITableViewStyleGrouped];
    
    self.rightTableView.backgroundColor = [UIColor clearColor];
    [self.rightTableView setSeparatorColor:[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1]];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    [self.rightTableView.layer setCornerRadius:10.0];
    [self.rightTableView.layer setMasksToBounds:YES];
    [self.view addSubview:self.rightTableView];
}
-(void)setRightTableSeclectIndex:(NSIndexPath*)indexpath
{
    if(self.currentRightIndexPath != indexpath)
    {
        self.currentRightIndexPath = indexpath;
        
        //set currentsetId
        ListItem *inspectionitem = nil;
        if(self.currentRightIndexPath.section == 0)
        {
            inspectionitem = [self.rightPannelListDic objectForKey:@"top"];
        }
        else
        {
            NSMutableArray *bottomarray = [self.rightPannelListDic objectForKey:@"bottom"];
            if(bottomarray!=nil)
            {
                inspectionitem = [bottomarray objectAtIndex:self.currentRightIndexPath.row];
            }
        }
        if(inspectionitem!=nil)
        {
            NSDictionary *pro = (NSDictionary *)[inspectionitem getData:@"sl_propertyID"];
            self.selectPrppertyId =[NSString stringWithFormat:@"%@",[pro objectForKey:@"ID"]];
            
            NSDictionary *insdic = (NSDictionary *)[inspectionitem getData:@"sl_inspector"];
            NSMutableDictionary *propertydic=[self.propertyDic objectForKey:self.selectPrppertyId];
            if([self.propertyDic objectForKey:self.selectPrppertyId] == nil)
            {
                propertydic = [[NSMutableDictionary alloc] init];
            }
            NSLog(@"self.selectPrppertyId %@",self.selectPrppertyId);
            [propertydic setObject:[insdic objectForKey:@"sl_accountname"] forKey:@"contactowner"];
            [propertydic setObject:[insdic objectForKey:@"sl_emailaddress"] forKey:@"contactemail"];
        }
        
        
        //reload left table;
        [self.propertyDetailTableView reloadData];
        
        [self GetInspectionListAccordingPropertyId:self.selectPrppertyId];
        [self.inspectionLeftTableView reloadData];
        [self.inspectionMidTableView reloadData];
        [self.inspectionRightTableView reloadData];
        
        
        
        
    }
}
-(void)loadData{
    
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.spinner];
    self.spinner.hidesWhenStopped = YES;
    
    [self.spinner startAnimating];
    
    ListClient* client = [self getClient];
    
    
    
    
    NSURLSessionTask* task = [client getListItemsByFilter:@"Inspections" filter:@"$select=ID,sl_datetime,sl_inspector/ID,sl_inspector/Title,sl_inspector/sl_accountname,sl_inspector/sl_emailaddress,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode&$expand=sl_inspector,sl_propertyID" callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //self.inspectionsListArray = [[NSMutableArray alloc] init];
            NSMutableArray *upcomingList = [[NSMutableArray alloc] init];
            ListItem* currentInspectionData = [[ListItem alloc] init];
            BOOL bfound=false;
            self.inspectionsListArray =[[NSMutableArray alloc] initWithArray:[listItems sortedArrayUsingComparator:^(ListItem *obj1, ListItem *obj2)
                                                                              {
                                                                                  NSDate *datetime1 = [EKNEKNGlobalInfo converDateFromString:(NSString *)[obj1 getData:@"sl_datetime"]];
                                                                                  NSDate *datetime2 = [EKNEKNGlobalInfo converDateFromString:(NSString *)[obj2 getData:@"sl_datetime"]];
                                                                                  
                                                                                  if([datetime1 compare:datetime2] == NSOrderedDescending)
                                                                                  {
                                                                                      return (NSComparisonResult)NSOrderedAscending;
                                                                                  }
                                                                                  if([datetime1 compare:datetime2] == NSOrderedAscending)
                                                                                  {
                                                                                      return (NSComparisonResult)NSOrderedDescending;
                                                                                  }
                                                                                  return (NSComparisonResult)NSOrderedSame;
                                                                                  
                                                                              }]];
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
                    NSLog(@"[pdic objectForKey:ID] intValue] %d",[[pdic objectForKey:@"ID"] intValue]);
                  if([[pdic objectForKey:@"ID"] intValue] == [self.selectPrppertyId intValue])
                  {
                      bfound = true;
                      currentInspectionData =tempitem;
                  }
                }
                if(!bfound)
                {
                    NSString *tempdatetime =(NSString *)[tempitem getData:@"sl_datetime"];
                    if(tempdatetime!=nil)
                    {
                        NSDate *inspectiondatetime = [EKNEKNGlobalInfo converDateFromString:tempdatetime];
                        NSLog(@"inspectiondatetime %@",inspectiondatetime);
                        NSLog(@"[NSDate date] %@",[NSDate date]);
                        if([inspectiondatetime compare:[NSDate date]] == NSOrderedDescending)
                        {
                            [upcomingList addObject:tempitem];
                        }
                    }
                }
            }
            //get the right pannel data
            self.rightPannelListDic = [[NSMutableDictionary alloc] init];
            [self.rightPannelListDic setObject:currentInspectionData forKey:@"top"];
            [self.rightPannelListDic setObject:upcomingList forKey:@"bottom"];
            
            
            //get property resource list:
            [self getPropertyResourceListArray:client];

        });
    }];
    
    [task resume];
}

-(void)getPropertyResourceListArray:(ListClient*)client
{
    NSURLSessionTask* getpropertyResourcetask = [client getListItemsByFilter:@"Property%20Photos" filter:@"$select=sl_propertyIDId,Id" callback:^(NSMutableArray *        listItems, NSError *error)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         //self.propertyResourceListArray =listItems;
                                                         
                                                             [self getPropertyResourceFile:client PropertyResourceItems:listItems];
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
                                                         
                                                        NSLog(@"propertyId %@",propertyId);
                                                         if(preindex == [loopitems count])
                                                         {
                                                             //get Incidents list
                                                             [self getIncidentsListArray:client];
                                                             
                                                         }
                                                         [loopindex setString:[NSString stringWithFormat:@"%d",preindex]];
                                                         NSLog(@"loopindex %@",loopindex);
                                                        
 
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
                                                         [self GetInspectionListAccordingPropertyId:self.selectPrppertyId];
                                                         //right table need reload data
                                                         [self.rightTableView reloadData];
                                                         NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:0];
                                                         [self.rightTableView selectRowAtIndexPath:temp animated:NO scrollPosition:UITableViewScrollPositionNone];
                                                         [self setRightTableSeclectIndex:temp];
                                                         
                                                         //get images
                                                         [self getAllImageFiles:client];
                                                         //
                                                         [self.spinner stopAnimating];
                                                         
                                                     });
                                                 }];
    [getincidentstask resume];
}

-(void)GetInspectionListAccordingPropertyId:(NSString*)pid
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
                        [inspectionItem setObject:@"YES" forKey:@"bowner"];
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
                        if([self.incidentOfInspectionDic objectForKey:inspectionId]!=nil)
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
            NSLog(@"cloris get image %@",error);
            if (error == nil) {
                NSLog(@"data length %lu",[data length]);
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
    
   // PropertyListCell *up = (PropertyListCell *)[self.rightTableView cellForRowAtIndexPath:indexpath];
    //[up.imageView setImage:image];
}
-(ListClient*)getClient{
    OAuthentication* authentication = [OAuthentication alloc];
    [authentication setToken:self.token];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    return [[ListClient alloc] initWithUrl:[standardUserDefaults objectForKey:@"demoSiteCollectionUrl"]
                               credentials: authentication];
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
    if(tableView == self.rightTableView)
    {
        return 2;
    }
    else if(tableView == self.propertyDetailTableView)
    {
        return 1;
    }
    else
    {
        return 1;
    }

        
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.rightTableView)
    {
        if(section == 0)
        {
            NSMutableArray *toparray =[self.rightPannelListDic objectForKey:@"top"];
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
            
            NSMutableArray *bottomarray =[self.rightPannelListDic objectForKey:@"bottom"];
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
    else if(tableView == self.propertyDetailTableView)
    {
        if(self.currentRightIndexPath!=nil)
        {
            return 3;
        }
        else
        {
            return 0;
        }
        
    }
    else if(tableView == self.inspectionLeftTableView)
    {
        if(self.currentRightIndexPath!=nil)
        {
            NSDictionary *tempdic  = [self.propertyDic objectForKey:self.selectPrppertyId];
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
    else if(tableView == self.inspectionMidTableView ||
            tableView == self.inspectionRightTableView )
    {
        if(self.currentRightIndexPath!=nil)
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
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.rightTableView)
    {
        return 109;

    }
    else if(tableView == self.propertyDetailTableView)
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
    else if(tableView == self.inspectionLeftTableView)
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.rightTableView)
    {
        return 30;
        
    }
    return 0;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.rightTableView)
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
            NSString *lbl1str = @"UPCOMING INSPECTION";
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
    
    if(tableView == self.rightTableView)
    {
        NSString *identifier = @"PropertyListCell";
        PropertyListCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"PropertyListCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier]; 
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [self setRightTableCell:cell cellForRowAtIndexPath:indexPath];
        return cell;
    }
    else if(tableView == self.inspectionMidTableView ||
            tableView == self.inspectionRightTableView )
    {
        NSString *identifier = @"ContactOwnerCell";
        ContactOwnerCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ContactOwnerCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        NSDictionary * tempdic = [self.propertyDic objectForKey:self.selectPrppertyId];
        if(tempdic!=nil)
        {
            if(tableView == self.inspectionMidTableView )
            {
                [cell setCellValue:[tempdic objectForKey:@"contactemail"]];
            }
            else
            {
                [cell setCellValue:[tempdic objectForKey:@"contactowner"]];
                
            }
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
        [self setLeftInspectionTableCell:cell cellForRowAtIndexPath:indexPath];
        return cell;
    }
    else if(tableView == self.propertyDetailTableView)
    {
        if(self.currentRightIndexPath!=nil && self.rightPannelListDic!=nil)
        {
            ListItem *inspectionitem = nil;
            if(self.currentRightIndexPath.section == 0)
            {
                inspectionitem = [self.rightPannelListDic objectForKey:@"top"];
            }
            else
            {
                NSMutableArray *bottomarray = [self.rightPannelListDic objectForKey:@"bottom"];
                if(bottomarray!=nil)
                {
                    inspectionitem = [bottomarray objectAtIndex:self.currentRightIndexPath.row];
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
                            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                        }
                        
                        NSString *address = [pro objectForKey:@"sl_address1"];
                        //NSString *propertyId =[NSString stringWithFormat:@"%@",[pro objectForKey:@"ID"]];
                        NSMutableDictionary *prodict = [self.propertyDic objectForKey:self.selectPrppertyId];
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
                            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
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
    if(tableView == self.rightTableView)
    {
        [self setRightTableSeclectIndex:indexPath];
    }
    else if(tableView == self.inspectionLeftTableView)
    {
        EKNRoomDetailsViewController *room = [[EKNRoomDetailsViewController alloc] init];
        
        NSDictionary *tempdic = [self.propertyDic objectForKey:self.selectPrppertyId];
        [room initRoomsValue:tempdic
                             propertyId:self.selectPrppertyId
                 inspetionId:indexPath.row
                 token:self.token];
        
        [self.navigationController pushViewController:room animated:YES];
    }
}
-(void)setLeftInspectionTableCell:(InspectionListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *prodic = [self.propertyDic objectForKey:self.selectPrppertyId];
    
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

-(void)setRightTableCell:(PropertyListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListItem *inspectionitem = nil;
    if(indexPath.section == 0)
    {
        inspectionitem = [self.rightPannelListDic objectForKey:@"top"];
    }
    else
    {
        NSMutableArray *bottomarray = [self.rightPannelListDic objectForKey:@"bottom"];
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
@end

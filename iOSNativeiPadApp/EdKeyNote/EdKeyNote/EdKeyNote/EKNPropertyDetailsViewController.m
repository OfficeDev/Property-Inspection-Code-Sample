//
//  EKNPropertyDetailsViewController.m
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNPropertyDetailsViewController.h"
#import <office365-base-sdk/OAuthentication.h>
#import "EKNEKNGlobalInfo.h"

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
    self.navigationController.navigationBar.hidden = YES;

    self.view.backgroundColor=[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1];
    
    UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusbar.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(130.00/255.00f) blue:(114.00/255.00f) alpha:1.0];
    [self.view addSubview:statusbar];
    
    UIImageView *header_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 1024, 71)];
    header_img.image = [UIImage imageNamed:@"navigation_background"];
    [self.view addSubview:header_img];
    
    
    UIFont *boldfont = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    NSString *lbl1str = @"PROPERTY DETAILS";
    NSDictionary *attributes = @{NSFontAttributeName:boldfont};
    CGSize lbsize = [lbl1str sizeWithAttributes:attributes];
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(25, 110, lbsize.width, lbsize.height)];
    //lbl1.backgroundColor = [UIColor clearColor];
    lbl1.text = lbl1str;
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = boldfont;
    lbl1.textColor = [UIColor colorWithRed:165.00f/255.00f green:165.00f/255.00f blue:165.00f/255.00f alpha:1];
    [self.view addSubview:lbl1];
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 91, 344, 768)];
    leftview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftview];
    
    UIImageView *speratorline = [[UIImageView alloc] initWithFrame:CGRectMake(344, 91, 5, 677)];
    speratorline.image = [UIImage imageNamed:@"sepratorline"];
    [self.view addSubview:speratorline];
    
    [self addRightTable];
    [self addProopertyDetailTable];
    
    [self loadData];
    
    // Do any additional setup after loading the view.
}
-(void)initData
{
    self.currentRightIndexPath = nil;
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
        //reload left table;
        [self.propertyDetailTableView reloadData];
    }
}
-(void)loadData{
    
    self.canlendarPrppertyId = 1;//for test
    
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.spinner];
    self.spinner.hidesWhenStopped = YES;
    
    [self.spinner startAnimating];
    
    ListClient* client = [self getClient];
    
    
    
    
    NSURLSessionTask* task = [client getListItemsByFilter:@"Inspections" filter:@"$select=ID,sl_datetime,sl_inspector/ID,sl_inspector/Title,sl_inspector/sl_accountname,sl_inspector/sl_emailaddress,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode&$expand=sl_inspector,sl_propertyID" callback:^(NSMutableArray *listItems, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            self.inspectionsListArray = [[NSMutableArray alloc] init];
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
                    NSLog(@"[pdic objectForKey:ID] intValue] %d",[[pdic objectForKey:@"ID"] intValue]);
                  if([[pdic objectForKey:@"ID"] intValue] == self.canlendarPrppertyId)
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
    NSURLSessionTask* getincidentstask = [client getListItemsByFilter:@"Incidents" filter:@"$select=sl_propertyIDId,Id"  callback:^(NSMutableArray *        listItems, NSError *error)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         for (ListItem* tempitem in listItems) {
                                                             NSString * propertyId = [NSString stringWithFormat:@"%@",[tempitem getData:@"sl_propertyIDId"]];
                                                             
                                                             NSMutableDictionary *propertyTempDic = [[NSMutableDictionary alloc] init];
                                                             
                                                             if ([self.propertyDic objectForKey:propertyId] == nil) {
                                                                 [propertyTempDic setObject:@"green icon" forKey:@"incidents"];
                                                                 [self.propertyDic setObject:propertyTempDic forKey:propertyId];
                                                             }
                                                             else
                                                             {
                                                                 if([[self.propertyDic objectForKey:propertyId] objectForKey:@"incidents"] == nil)
                                                                 {
                                                                     [[self.propertyDic objectForKey:propertyId] setObject:@"green icon" forKey:@"incidents"];
                                                                 }
                                                             }
                                                         }
                                                         
                                                         //get current property inspection list
                                                         NSString *pid = [NSString stringWithFormat:@"%d",self.canlendarPrppertyId];
                                                         [self GetInspectionListAccordingPropertyId:pid];
                                                         
                                                         
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
    
    NSMutableArray *inspectionslistTemp = [[NSMutableArray alloc] init];
    
    for (ListItem* tempitem in self.inspectionsListArray) {
        NSDictionary * pdic = (NSDictionary *)[tempitem getData:@"sl_propertyID"];
        NSDictionary *insdic =(NSDictionary *)[tempitem getData:@"sl_inspector"];
        if(pdic!=nil)
        {
            if([[pdic objectForKey:@"ID"] intValue] == self.canlendarPrppertyId)
            {
                
                NSMutableDictionary * inspectionItem= [[NSMutableDictionary alloc] init];
                
                [inspectionItem setObject:[insdic objectForKey:@"Title"] forKey:@"sl_accountname"];
                if ([insdic objectForKey:@"Title"] == self.loginName) {
                    [inspectionItem setObject:@"YES" forKey:@"bowner"];
                }
                [inspectionItem setObject:[tempitem getData:@"sl_datetime"] forKey:@"sl_datetime"];
                
                [inspectionslistTemp addObject:inspectionItem];
            }
        }
    }
    [[self.propertyDic objectForKey:pid] setObject:inspectionslistTemp forKey:@"inspectionslist"];
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
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.rightTableView)
    {
        if(section ==0)
        {
            return 30;
        }
        else
        {
            return 50;
        }
        
        
    }
    else if(tableView == self.propertyDetailTableView)
    {
        return 25;
    }
    return 40;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.rightTableView)
    {
        if (section == 0)
        {
            UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 620, 30)];
            tview.backgroundColor = [UIColor clearColor];
            
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
            NSString *lbl1str = @"CURRENT INSPECTION";
            NSDictionary *attributes = @{NSFontAttributeName:font};
            CGSize lbsize = [lbl1str sizeWithAttributes:attributes];
            UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lbsize.width, lbsize.height)];
            lbl1.text = lbl1str;
            lbl1.textAlignment = NSTextAlignmentLeft;
            lbl1.font = font;
            lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
            
            [tview addSubview:lbl1];
            
            return tview;
        }
        else
        {
            UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 620, 50)];
            tview.backgroundColor = [UIColor clearColor];
            
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
            NSString *lbl1str = @"UPCOMING INSPECTION";
            NSDictionary *attributes = @{NSFontAttributeName:font};
            CGSize lbsize = [lbl1str sizeWithAttributes:attributes];
            UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, lbsize.width, lbsize.height)];
            lbl1.text = lbl1str;
            lbl1.textAlignment = NSTextAlignmentLeft;
            lbl1.font = font;
            lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
            
            [tview addSubview:lbl1];
            
            return tview;
        }
        
    }
    else if(tableView == self.propertyDetailTableView)
    {
        UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 315, 25)];
        tview.backgroundColor = [UIColor clearColor];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        NSString *lbl1str = @"PROPERTY DETAILS";
        NSDictionary *attributes = @{NSFontAttributeName:font};
        CGSize lbsize = [lbl1str sizeWithAttributes:attributes];
        UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lbsize.width, lbsize.height)];
        lbl1.text = lbl1str;
        lbl1.textAlignment = NSTextAlignmentLeft;
        lbl1.font = font;
        lbl1.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
        
        [tview addSubview:lbl1];
        
        return tview;
    }
    else
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
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
        [self setRightTableCell:cell cellForRowAtIndexPath:indexPath];
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
                        NSString *propertyId =[NSString stringWithFormat:@"%@",[pro objectForKey:@"ID"]];
                        if(propertyId!=nil)
                        {
                            NSMutableDictionary *prodict = [self.propertyDic objectForKey:propertyId];
                            UIImage *image =(UIImage *)[prodict objectForKey:@"image"];
                            [cell setCellValue:image title:address];
                        }
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


        return [[UITableViewCell alloc] init];
    }
    else
    {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.rightTableView)
    {
        [self setRightTableSeclectIndex:indexPath];
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

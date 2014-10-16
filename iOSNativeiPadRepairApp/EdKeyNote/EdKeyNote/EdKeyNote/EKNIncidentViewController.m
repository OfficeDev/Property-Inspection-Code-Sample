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
    
    [self loadData];
}

-(void)initData
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    self.siteUrl = [standardUserDefaults objectForKey:@"demoSiteCollectionUrl"];
    self.incidentPhotoListDic = [[NSMutableDictionary alloc] init];
    
    self.selectPropertyId = @"1";//for test
    self.loginName = @"Rob Barker";//for test
    self.currentRightIndexPath = nil;
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
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(380, 100, 620, 635) style:UITableViewStyleGrouped];
    self.rightTableView.backgroundColor = [UIColor clearColor];
    [self.rightTableView setSeparatorColor:[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1]];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    [self.rightTableView.layer setCornerRadius:10.0];
    [self.rightTableView.layer setMasksToBounds:YES];
    [self.view addSubview:self.rightTableView];
}

-(void)setRightTableSelectIndex:(NSIndexPath*)indexpath
{

}

-(void)loadData{
    
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0,1024,768)];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.spinner setBackgroundColor:[UIColor colorWithRed:0.00f/255.00f green:0.00f/255.00f blue:0.00f/255.00f alpha:0.2]];
    [self.view addSubview:self.spinner];
    self.spinner.hidesWhenStopped = YES;
    
    [self.spinner startAnimating];
    
    ListClient* client = [self getClient];
    
    NSURLSessionTask* task = [client getListItemsByFilter:@"Incidents" filter:@"$select=ID,Title,sl_inspectorIncidentComments,sl_dispatcherComments,sl_repairComments,sl_status,sl_type,sl_date,sl_inspectionIDId,sl_roomIDId,sl_inspectionID/ID,sl_inspectionID/sl_datetime,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_emailaddress,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode,sl_roomID/ID,sl_roomID/Title&$expand=sl_inspectionID,sl_propertyID,sl_roomID&$orderby=sl_date%20desc" callback:^(NSMutableArray *listItems, NSError *error) {
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
        NSLog(@"test output:%@",filter);
        NSString *filterInURL = [filter stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"filter url:%@",filterInURL);
            NSURLSessionTask* task = [client getListItemsByFilter:@"Room Inspection Photos" filter:filterInURL callback:^(NSMutableArray *listItems, NSError *error) {
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

-(void)getRoomInspectionPhotoServerRelativeUrl:(ListClient *)client photoID:(NSString *)photoID incidentID:(NSString *)incidentID index:(NSInteger *)index
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

-(void)getRoomInspectionPhoto:(NSString *)serverRelativeUrl incidentID:(NSString *)incidentID index:(NSInteger *)index
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
        if(self.currentRightIndexPath!=nil)
        {
            return 1;
        }
        else
        {
            return 1;
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
            tableView == self.contactOfficeTableView )
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
            tableView == self.contactOwnerTableView)
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
    else if(tableView == self.propertyDetailTableView)
    {
        if(self.propertyDetailDic != nil)
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
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM'/'dd'/'yyyy"];
    
    NSString *incidentID = (NSString *)[incidentItem getData:@"ID"];
    NSDictionary *propertyData = (NSDictionary *)[incidentItem getData:@"sl_propertyID"];
    NSDictionary *inspectionData = (NSDictionary *)[incidentItem getData:@"sl_inspectionID"];
    NSDictionary *roomData = (NSDictionary *)[incidentItem getData:@"sl_roomID"];
    
    if(propertyData != nil && inspectionData != nil && roomData != nil)
    {
        NSString *room = (NSString *)[roomData objectForKey:@"Title"];
        NSString *incident = (NSString *)[incidentItem getData:@"Title"];
        NSDate *inspectionDate = [EKNEKNGlobalInfo converDateFromString:(NSString *)[inspectionData objectForKey:@"sl_datetime"]];
        NSString *inspectionDateStr = [dateFormat stringFromDate:inspectionDate];
        //NSLog(@"date time:%@,%@,%@",inspectionDate,[inspectionData objectForKey:@"sl_datetime"],inspectionDateStr);
        NSString *approved = (NSString *)[incidentItem getData:@"sl_status"];
        UIImage *image = nil;
        NSMutableDictionary *dic = [self.incidentPhotoListDic objectForKey:incidentID];
        if(dic != nil)
        {
            image =(UIImage *)[dic objectForKey:@"photo"];
            NSLog(@"image size width:%f heigth:%f",image.size.width,image.size.height);
        }
        [cell setCellValue:image room:room incident:incident inspectionDate:inspectionDateStr repairDate:@"10/25/2014" approved:approved];
    }
}
@end

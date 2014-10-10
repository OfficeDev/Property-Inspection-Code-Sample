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
    /*self.view.backgroundColor = [UIColor colorWithRed:239.00f/255.00f green:239.00f/255.00f blue:244.00f/255.00f alpha:1];*/
    self.view.backgroundColor=[UIColor whiteColor];
    
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
    
    /*self.propertyDetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(160/2, 380/2, 610/2, 360/2) style:UITableViewStylePlain];
    self.propertyDetailsTableView.delegate = self;
    self.propertyDetailsTableView.dataSource = self;
    [self.view addSubview:self.propertyDetailsTableView];*/
    
    UIImageView *speratorline = [[UIImageView alloc] initWithFrame:CGRectMake(344, 91, 5, 677)];
    speratorline.image = [UIImage imageNamed:@"sepratorline"];
    [self.view addSubview:speratorline];
    
    
    //[self loadData];
    
    // Do any additional setup after loading the view.
}
-(void)loadData{
    
    self.canlendarPrppertyId = 1;//for test
    
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.spinner];
    self.spinner.hidesWhenStopped = YES;
    
    [self.spinner startAnimating];
    
    ListClient* client = [self getClient];
    
    NSURLSessionTask* task = [client getListItemsByFilter:@"Inspections" filter:@"$select=ID,Title,sl_datetime,sl_inspectorID/ID,sl_inspectorID/Title,sl_inspectorID/sl_accountname,sl_inspectorID/sl_emailaddress,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode&$expand=sl_inspectorID,sl_propertyID" callback:^(NSMutableArray *listItems, NSError *error) {
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
                NSDictionary * indic = (NSDictionary *)[tempitem getData:@"sl_inspectorID"];
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
                
                NSDictionary * pdic = (NSDictionary *)[tempitem getData:@"sl_propertyID"];
                if(pdic!=nil)
                {
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
                        if([inspectiondatetime laterDate:[NSDate date]])
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
        NSDictionary *insdic =(NSDictionary *)[tempitem getData:@"sl_inspectorID"];
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
-(ListClient*)getClient{
    OAuthentication* authentication = [OAuthentication alloc];
    [authentication setToken:self.token];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    return [[ListClient alloc] initWithUrl:[standardUserDefaults objectForKey:@"demoSiteCollectionUrl"]
                               credentials: authentication];
}
/*-(void)loadData{
 
    //Turn on Spinner
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:spinner];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
 
    //Replace this URL with SP REST API URL
    NSString *requestUrl = @"https://techedairlift04.spoppe.com/sites/SuiteLevelAppDemo/_api/lists/GetByTitle('Inspections')/Items$select=ID,Title";
 
    //Add the access token to the Authorization header
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.token];
 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
 
    //Create NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
 
    //Turn on network indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //Create NSURLSessionDataTask and call REST API
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                      NSURLResponse *response,
                                                                                      NSError *error) {
     
        //Turn off network indicator
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        //Turn off spinner
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
        });

        //Handle error
        if (error != nil) {
            NSString *errorMessage = [@"Error accessing O365 SharePoint REST APIs. Reason: " stringByAppendingString: error.description];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
            [alert show];
        }
                
        //Process the data and bind to the user interface
        NSLog(@"%@", data);
        //self.SharepointList  = lists;
    }];
    
    [task resume];
}
*/
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
   if(tableView == self.propertyDetailsTableView)
   {
       return 3;
       //return [self.SharepointList count];
   }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.propertyDetailsTableView)
    {
        if(indexPath.row == 3)
        {
            return 70;
        }
        else
        {
            return 40;
        }

    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.propertyDetailsTableView)
    {
        UITableViewCell *cell = nil;
        NSString *identifier = @"PropertyCellID";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.opaque = NO;
            cell.textLabel.textColor = [UIColor blackColor];
            
            /*if(indexPath.row == 1)
            {
                
            }
            cell.textLabel.text = ((EKNInspectionData *)self.inspectionHistory[self.currentSelectIndex]).inspectionProperty.propertyTitle;
            
            cell.textLabel.numberOfLines = 1;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            [cell.textLabel setNumberOfLines:5];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;*/
        }
        return cell;
    }
    else
    {
        return nil;
    }
    
}

@end

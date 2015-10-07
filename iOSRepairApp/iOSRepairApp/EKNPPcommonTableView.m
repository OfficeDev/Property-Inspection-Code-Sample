//
//  EKN.m
//  iOSRepairApp
//
//  Created by canviz on 9/3/15.
//  Copyright (c) 2015 canviz. All rights reserved.
//

#import "EKNPPcommonTableView.h"

@implementation EKNPPcommonTableView

- (void)initPPcommonTableView:(NSString *)groupId brecent:(BOOL)bRecent{
    self.commonTable = [[UITableView alloc] initWithFrame:CGRectMake(31, 0, 620, 657) style:UITableViewStyleGrouped];
    self.commonTable.backgroundColor = [UIColor clearColor];
    [self.commonTable setSeparatorColor:[UIColor colorWithRed:242.00f/255.00f green:242.00f/255.00f blue:242.00f/255.00f alpha:1]];
    [self.commonTable.layer setCornerRadius:10.0];
    [self.commonTable.layer setMasksToBounds:YES];
    self.commonTable.delegate = self;
    self.commonTable.dataSource = self;
    [self addSubview: self.commonTable];
    self.listDict = [[NSMutableDictionary alloc] init];
    
    self.groupId = groupId;
    self.bRecentDocument = bRecent;
    
}
-(void)getPPcommonTableService{
    switch (self.tag) {
        case RpsPropertyMembersViewTag:
            [self getPropertyMembersService];
            break;
        case RpsConversationViewTag:
            [self getConversationsService];
            break;
        case RpsOneNoteViewTag:
            [self getOneNoteService];
            break;
        case RpsPropertyFilesViewTag:
            [self getPropertyFilesService];
            break;
        case RpsRecentDocumentViewTag:
            [self getPropertyFilesService];
            break;
        default:
            break;
    }
}
-(void)getPropertyMembersService {
    [self.actiondelegate showLoading];
    
    EKNGraphService *graph = [[EKNGraphService alloc] init];
    [graph getGroupMembers:self.groupId callback:^(NSMutableDictionary *listDict, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.actiondelegate hideLoading];
            
            NSMutableDictionary * listItems = [listDict objectForKey:@"list"];
            if(listItems != nil && [listItems count] >0)
            {
                [self.actiondelegate setGroupData:listDict key:@"propertymembers" groupId:self.groupId];
                [self loadPPcommonTableView:listDict];
            }
            else
            {
                [self.actiondelegate showErrorMessage:[NSString stringWithFormat:@"Can't find conversation item. Error code %ld,error message: %@",error.code, error.localizedDescription]];
            }
        });
    }];
}

-(void)getConversationsService {
    [self.actiondelegate showLoading];
    
    EKNGraphService *graph = [[EKNGraphService alloc] init];
    [graph getGroupConversations:self.groupId callback:^(NSMutableDictionary *listDict, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.actiondelegate hideLoading];
            
            NSMutableDictionary * listItems = [listDict objectForKey:@"list"];
            if(listItems != nil && [listItems count] >0)
            {
                [self.actiondelegate setGroupData:listDict key:@"conversations" groupId:self.groupId];
                [self loadPPcommonTableView:listDict];
            }
            else
            {
                [self.actiondelegate showErrorMessage:[NSString stringWithFormat:@"Can't find conversation item. Error code %ld,error message: %@",error.code, error.localizedDescription]];
            }
        });
    }];
}
-(void)getOneNoteService{
    [self.actiondelegate showLoading];
    
    EKNGraphService *graph = [[EKNGraphService alloc] init];
    [graph getGroupNotes:self.groupId callback:^(NSMutableDictionary *listDict, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.actiondelegate hideLoading];
            
            NSMutableDictionary * listItems = [listDict objectForKey:@"list"];
            if(listItems != nil && [listItems count] >0)
            {
                [self.actiondelegate setGroupData:listDict key:@"onenote" groupId:self.groupId];
                [self loadPPcommonTableView:listDict];
            }
            else
            {
                 [self.actiondelegate showErrorMessage:[NSString stringWithFormat:@"Can't find OneNote item. Error code %ld,error message: %@",error.code, error.localizedDescription]];
            }
        });
    }];
}
-(void)getPropertyFilesService{
    [self.actiondelegate showLoading];
    
    EKNGraphService *graph = [[EKNGraphService alloc] init];
    [graph getGroupFiles:self.groupId callback:^(NSMutableDictionary *listDict, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.actiondelegate hideLoading];
            
            NSMutableDictionary * listItems = [listDict objectForKey:@"list"];
            if(listItems != nil && [listItems count] >0)
            {
                [self.actiondelegate setGroupData:listDict key:@"propertyfiles" groupId:self.groupId];
                [self loadPPcommonTableView:listDict];
            }
            else
            {
                [self.actiondelegate showErrorMessage:[NSString stringWithFormat:@"Can't find conversation item. Error code %ld,error message: %@",error.code, error.localizedDescription]];
            }
        });
    }];
}
-(void)clickViewAll{
    NSString *href = [self.listDict objectForKey:@"viewAll"];
    if(href != nil){
        [EKNEKNGlobalInfo openUrl:href];
    }
    
}
-(void)loadPPcommonTableView:(NSMutableDictionary *)listDict{
    
    if(self.bRecentDocument){
        //filter for recent document
        NSMutableArray *filterlist = [[NSMutableArray alloc] init];
        
        NSMutableArray *list = [listDict objectForKey:@"list"];
        for(NSDictionary *item in list){
            NSDate *modifiedDate = [item objectForKey:@"lastmodified"];
            NSDate *lastWeek = [[NSDate date] dateByAddingTimeInterval:-604800.0];
            if([modifiedDate compare:lastWeek] == NSOrderedDescending){
                [filterlist addObject:item];
            }
        }
        NSMutableDictionary *fitlerdic =[[NSMutableDictionary alloc] init];
        [fitlerdic setValue:filterlist forKey:@"list"];
        [fitlerdic setValue:[listDict objectForKey:@"viewAll"] forKey:@"viewAll"];
        self.listDict = fitlerdic;
        
    }
    else{
        self.listDict =listDict;
    }
    [self.commonTable reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 620, 80)];
    
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 620, 30)];
    lbl1.text = @"ALL PROPERTY INFORMATION";
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = [UIFont fontWithName:@"Helvetica" size:24];
    lbl1.textColor = [UIColor blackColor];
    [headerView addSubview:lbl1];
    
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 620, 30)];
    NSString *text2 = nil;
    switch (self.tag) {
        case RpsPropertyMembersViewTag:
            text2 =  @"PROPERTY MEMBERS";
            break;
        case RpsConversationViewTag:
            text2 =  @"CONVERSATIONS";
            break;
        case RpsOneNoteViewTag:
            text2 = @"NOTES";
            break;
        case RpsPropertyFilesViewTag:
            text2 = @"PROPERTY FILES";
            break;
        case RpsRecentDocumentViewTag:
            text2 = @"RECENT DOCUMENTS";
            break;
        default:
            break;
    }
    lbl2.text = text2;
    lbl2.textAlignment = NSTextAlignmentLeft;
    lbl2.font = [UIFont fontWithName:@"Helvetica" size:20];
    lbl2.textColor = [UIColor colorWithRed:136.00f/255.00f green:136.00f/255.00f blue:136.00f/255.00f alpha:1];
    [headerView addSubview:lbl2];
    
    return headerView;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 620, 60)];
    
    
    UIButton *viewAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(500, 10, 110, 40)];
    [viewAllBtn setBackgroundColor:[UIColor colorWithRed:0.00f/255.00f green:130.00f/255.00f blue:114.00f/255.00f alpha:1]];
    [viewAllBtn setTitle:@"View All" forState:UIControlStateNormal];
    [viewAllBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    viewAllBtn.titleLabel.textColor = [UIColor whiteColor];
    [viewAllBtn addTarget:self action:@selector(clickViewAll) forControlEvents:UIControlEventTouchUpInside];
    
    [footer addSubview:viewAllBtn];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.tag == RpsPropertyMembersViewTag){
        return 72;
    }
    else if(self.tag == RpsConversationViewTag){
        return 80;
    }
    else if(self.tag == RpsOneNoteViewTag)
    {
        return 123;
    }
    else if(self.tag == RpsPropertyFilesViewTag
            || self.tag == RpsRecentDocumentViewTag){
        return 160;
    }
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSMutableArray *)[self.listDict objectForKey:@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.tag == RpsConversationViewTag){
        NSString *identifier = [NSString stringWithFormat:@"ConversationCell-%ld-%ld-%ld",tableView.tag,indexPath.section, indexPath.row];
        ConversationCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ConversationCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDictionary *item = [(NSMutableArray *)[self.listDict objectForKey:@"list"] objectAtIndex:indexPath.row];
        
        [cell setCellValue:[item objectForKey:@"topic"] preview:(NSString *)[item objectForKey:@"preview"] webURl:[self.listDict objectForKey:@"viewAll"]];
        return  cell;
    }
    else if(self.tag == RpsPropertyMembersViewTag){
        NSString *identifier = [NSString stringWithFormat:@"PropertyMembersCell-%ld-%ld-%ld",tableView.tag,indexPath.section, indexPath.row];//@"";
        PropertyMembersCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"PropertyMembersCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDictionary *item = [(NSMutableArray *)[self.listDict objectForKey:@"list"] objectAtIndex:indexPath.row];
        
        [cell setCellValue:self.groupId memberid:(NSString *)[item objectForKey:@"memberId"] name:(NSString *)[item objectForKey:@"name"]];
        return  cell;
    }
    else if(self.tag == RpsOneNoteViewTag){
        NSString *identifier = [NSString stringWithFormat:@"OneNoteCell-%ld-%ld-%ld",tableView.tag,indexPath.section, indexPath.row];//@"";
        OneNoteCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"OneNoteCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDictionary *item = [(NSMutableArray *)[self.listDict objectForKey:@"list"] objectAtIndex:indexPath.row];
        
        [cell setCellValue:[item objectForKey:@"title"] webURl:[item objectForKey:@"webUrl"] clientUrl:[item objectForKey:@"clientUrl"]];
        return  cell;
    }
    else if(self.tag == RpsPropertyFilesViewTag
            || self.tag == RpsRecentDocumentViewTag){
        NSString *identifier = [NSString stringWithFormat:@"PropertyFileCell-%ld-%ld-%ld",tableView.tag,indexPath.section, indexPath.row];//@"";//@"";
        PropertyFileCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"PropertyFileCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDictionary *item = [(NSMutableArray *)[self.listDict objectForKey:@"list"] objectAtIndex:indexPath.row];
        
        [cell setCellValue:[item objectForKey:@"fileName"] author:[item objectForKey:@"author"] lastmodified:[item objectForKey:@"lastmodified"] filesize:[item objectForKey:@"size"] weburl:[item objectForKey:@"webUrl"] clientUrl:[item objectForKey:@"clientUrl"]];
        return  cell;
    }
    else{
        return nil;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.tag == RpsConversationViewTag)
    {
        ConversationCell * cell =(ConversationCell *)[tableView cellForRowAtIndexPath:indexPath];
        [EKNEKNGlobalInfo openUrl:cell.webUrl];
    }
    else if(self.tag == RpsOneNoteViewTag){
        OneNoteCell * cell =(OneNoteCell *)[tableView cellForRowAtIndexPath:indexPath];
        [EKNEKNGlobalInfo openUrl:cell.webUrl];
    }
    else if(self.tag == RpsPropertyFilesViewTag
            || self.tag == RpsRecentDocumentViewTag){
        PropertyFileCell * cell =(PropertyFileCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"web url %@",cell.webUrl);
        [EKNEKNGlobalInfo openUrl:cell.webUrl];
    }

}

@end

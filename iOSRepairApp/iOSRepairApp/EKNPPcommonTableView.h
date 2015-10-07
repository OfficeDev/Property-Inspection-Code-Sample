
//
//  EKNOneNoteTableView
//  iOSRepairApp
//
//  Created by canviz on 9/3/15.
//  Copyright (c) 2015 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKNEKNGlobalInfo.h"
#import "EKNGraphService.h"
#import "ConversationCell.h"
#import "PropertyMembersCell.h"
#import "OneNoteCell.h"
#import "PropertyFileCell.h"
@interface EKNPPcommonTableView : UIView<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) UITableView * commonTable;

//"list","viewAll"
@property(nonatomic) NSMutableDictionary *listDict;
@property (nonatomic, assign) id <IncidentSubViewActionDelegate> actiondelegate;
@property (nonatomic) NSString * groupId;
@property (nonatomic) BOOL bRecentDocument;
- (void)initPPcommonTableView:(NSString *)groupId brecent:(BOOL)bRecent;
-(void)loadPPcommonTableView:(NSMutableDictionary *)listDict;
-(void)getPPcommonTableService;
@end



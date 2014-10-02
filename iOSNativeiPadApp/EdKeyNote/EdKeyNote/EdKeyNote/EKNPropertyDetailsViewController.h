//
//  EKNPropertyDetailsViewController.h
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKNInspectionData.h"
@interface EKNPropertyDetailsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray* SharepointList;
@property NSString* token;

@property(nonatomic) UILabel *inspectionTitle;
@property(nonatomic) UILabel *inspectorInfor;

@property(nonatomic) UITableView * propertyDetailsTableView;//here will be relaced by Normal UIview
@property(nonatomic) UITableView * inspectionTableView;
@property(nonatomic) UITableView * roomsTableView;

@property(nonatomic) NSInteger currentSelectIndex;
@property(nonatomic) NSMutableArray *inspectionHistory;
-(void)initParameter:(NSMutableArray *)historyarray;
@end

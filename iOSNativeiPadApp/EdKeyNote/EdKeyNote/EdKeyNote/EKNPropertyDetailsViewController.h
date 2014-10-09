//
//  EKNPropertyDetailsViewController.h
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListClient.h"
#import "ListItem.h"


@interface EKNPropertyDetailsViewController : UIViewController/*<UITableViewDelegate, UITableViewDataSource>*/

//@property NSMutableArray* SharepointList;
@property int canlendarPrppertyId;
@property(nonatomic) NSString* token;

//all inspections list
@property(nonatomic) NSMutableArray *inspectionsListArray;
//current and upcoming inspections dict
@property(nonatomic) NSMutableDictionary *rightPannelListDic;
//left dict,property id is key
@property(nonatomic) NSMutableDictionary *leftPannelDict;
//property Resources list
@property(nonatomic) NSMutableArray *propertyResourceListArray;

//key is propery Id
@property(nonatomic) NSMutableDictionary *propertyPhotoDic;

@property(nonatomic) UIActivityIndicatorView* spinner;

@property(nonatomic) UILabel *inspectionTitle;
@property(nonatomic) UILabel *inspectorInfor;

@property(nonatomic) UITableView * propertyDetailsTableView;//here will be relaced by Normal UIview
@property(nonatomic) UITableView * inspectionTableView;
@property(nonatomic) UITableView * roomsTableView;

@property(nonatomic) NSInteger currentSelectIndex;
@property(nonatomic) NSMutableArray *inspectionHistory;
-(void)initParameter:(NSMutableArray *)historyarray;
-(void)getPropertyResourceListArray:(ListClient*)client;
-(void)getPropertyResourceFile:(ListClient*)client  PropertyResourceItems:(NSMutableArray* )listItems;
@end

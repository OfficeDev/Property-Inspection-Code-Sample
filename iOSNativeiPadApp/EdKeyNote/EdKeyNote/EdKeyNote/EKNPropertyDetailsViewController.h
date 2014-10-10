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
@property(nonatomic) NSString* loginName;
@property(nonatomic) NSString* token;

//all inspections list
@property(nonatomic) NSMutableArray *inspectionsListArray;
//current and upcoming inspections dict
@property(nonatomic) NSMutableDictionary *rightPannelListDic;
//key is propery Id, use to story property Resource and incidents
@property(nonatomic) NSMutableDictionary *propertyDic;


@property(nonatomic) UIActivityIndicatorView* spinner;
@property(nonatomic) UITableView * rightTableView;
@property(nonatomic) NSIndexPath * rightIndexPath;



@property(nonatomic) UILabel *inspectionTitle;
@property(nonatomic) UILabel *inspectorInfor;

@property(nonatomic) UITableView * propertyDetailsTableView;//here will be relaced by Normal UIview
@property(nonatomic) UITableView * inspectionTableView;
@property(nonatomic) UITableView * roomsTableView;





-(void)getPropertyResourceListArray:(ListClient*)client;
-(void)getPropertyResourceFile:(ListClient*)client  PropertyResourceItems:(NSMutableArray* )listItems;
-(void)getIncidentsListArray:(ListClient*)client;
@end

//
//  EKNPropertyDetailsViewController.h
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <office365-base-sdk/OAuthentication.h>
#import "ListClient.h"
#import "ListItem.h"
#import "EKN+UIViewController.h"
#import "PropertyListCell.h"
#import "PropertyDetailsImage.h"
#import "PropertyDetailsCell.h"
#import "InspectionListCell.h"
#import "EKNEKNGlobalInfo.h"
#import "ContactOwnerCell.h"


@interface EKNPropertyDetailsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

//@property NSMutableArray* SharepointList;

//need get data from extend
@property(nonatomic) NSString* loginName;
@property(nonatomic) NSString* token;
@property(nonatomic) NSString* selectPrppertyId;
//end


//all inspections list. store all inspections list, Listitem
@property(nonatomic) NSMutableArray *inspectionsListArray;
//current and upcoming inspections dict
@property(nonatomic) NSMutableDictionary *rightPannelListDic;

//key is propery Id, use to story property Resource and incidents
//inspectionslist
//contactowner
//contactemail
//ServerRelativeUrl
//image
//trytimes
@property(nonatomic) NSMutableDictionary *propertyDic;

//key is inspection Id, use to story inspection andincidents
@property(nonatomic) NSMutableDictionary *incidentOfInspectionDic;


@property(nonatomic) UIActivityIndicatorView* spinner;

@property(nonatomic) UITableView * rightTableView;
@property(nonatomic) NSIndexPath * currentRightIndexPath;

@property(nonatomic) UITableView * propertyDetailTableView;

@property(nonatomic) UITableView * inspectionLeftTableView;
@property(nonatomic) UITableView * inspectionMidTableView;
@property(nonatomic) UITableView * inspectionRightTableView;


/**/

-(void)getPropertyResourceListArray:(ListClient*)client;
-(void)getPropertyResourceFile:(ListClient*)client  PropertyResourceItems:(NSMutableArray* )listItems;
-(void)getIncidentsListArray:(ListClient*)client;
-(void)setRightTableCell:(PropertyListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)didUpdateRightTableCell:(NSIndexPath *)indexpath image:(UIImage*)image;
-(void)setLeftInspectionTableCell:(InspectionListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

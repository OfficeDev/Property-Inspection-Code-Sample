//
//  EKNIncidentViewController.h
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <office365-base-sdk/OAuthentication.h>
#import "ListClient.h"
#import "ListItem.h"
#import "EKN+UIViewController.h"
#import "IncidentListItemCell.h"
#import "PropertyDetailsImage.h"
#import "PropertyDetailsCell.h"
#import "EKNEKNGlobalInfo.h"
#import "ContactOwnerCell.h"

@interface EKNIncidentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

//@property NSMutableArray* SharepointList;

//need get data from extend
@property(nonatomic) NSString* loginName;
@property(nonatomic) NSString* token;
@property(nonatomic) NSString* siteUrl;
@property(nonatomic) NSString* selectPropertyId;
//end


//all inspections list. store all inspections list, Listitem
//ID,sl_datetime,
//sl_inspector/ID,sl_inspector/Title,sl_inspector/sl_accountname,sl_inspector/sl_emailaddress
//sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode
@property(nonatomic) NSMutableArray *incidentListArray;
@property(nonatomic) NSMutableDictionary *incidentPhotoListDic;

//current and upcoming inspections dict
//top: current listitem
//bottom: bottom listitem
@property(nonatomic) NSMutableDictionary *rightPannelListDic;

//key is propery Id, use to store property Resource and incidents
//inspectionslist
//----ID,sl_accountname, bowner, icon, sl_datetime
//contactowner
//contactemail
//ServerRelativeUrl
//image
//trytimes
@property(nonatomic) NSMutableDictionary *propertyDic;

@property(nonatomic) NSDictionary *propertyDetailDic;

//key is inspection Id, use to store inspection andincidents
@property(nonatomic) NSMutableDictionary *incidentOfInspectionDic;
@property(nonatomic) NSMutableDictionary *inspectionDetailDic;

//key is inspection Id, use to store rooms
//one inspection maybe have many rooms
//one room maybe have many pictures
@property(nonatomic) NSMutableDictionary *roomsOfInspectionDic;


@property(nonatomic) UIActivityIndicatorView* spinner;

@property(nonatomic) UITableView * rightTableView;
@property(nonatomic) NSIndexPath * currentRightIndexPath;

@property(nonatomic) UIView *detailLeftView;
@property(nonatomic) UIView *detailRightView;
@property(nonatomic) UIButton *backButton;
@property(nonatomic) UITableView *detailInspectionDetailTableView;

@property(nonatomic) UIView *detailRightDispatcher;
@property(nonatomic) UIView *detailRightInspector;
@property(nonatomic) UIView *detailRightAdd;


//left table views
@property(nonatomic) UITableView * propertyDetailTableView;
@property(nonatomic) UITableView * contactOwnerTableView;
@property(nonatomic) UITableView * contactOfficeTableView;

@property(nonatomic) UIButton *finalizeBtn;

@property(nonatomic) BOOL detailViewIsShowing;

/**/

-(void)getPropertyResourceListArray:(ListClient*)client;
-(void)getPropertyResourceFile:(ListClient*)client  PropertyResourceItems:(NSMutableArray* )listItems;
-(void)getIncidentsListArray:(ListClient*)client;
-(void)setRightTableCell:(IncidentListItemCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)didUpdateRightTableCell:(NSIndexPath *)indexpath image:(UIImage*)image;
@end


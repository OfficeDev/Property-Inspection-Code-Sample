//
//  EKNIncidentViewController.h
//  EdKeyNote
//
//  Created by Max on 10/14/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "EKNListClient.h"
#import "EKNListItem.h"
#import "EKN+UIViewController.h"
#import "IncidentListItemCell.h"
#import "PropertyDetailsImage.h"
#import "PropertyDetailsCell.h"
#import "EKNEKNGlobalInfo.h"
#import "ContactOwnerCell.h"
#import "EKNCollectionViewCell.h"
#import "IncidentMenuCell.h"


#import "EKNIncidentDetailView.h"
#import "EKNPPcommonTableView.h"



@interface EKNIncidentViewController : UIViewController<IncidentSubViewActionDelegate,UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>


//data
@property(nonatomic) EKNListClient *client;
@property(nonatomic) NSString* loginName;
@property(nonatomic) NSString* token;
@property(nonatomic) NSString* siteUrl;
@property(nonatomic) NSString* incidentId;

@property(nonatomic) NSString* selectPropertyId;
@property(nonatomic) NSString* selectIncidentId;
@property(nonatomic) NSString* selectInspectionId;
@property(nonatomic) NSString* selectRoomId;
@property(nonatomic) NSString* selectGroupId;
@property(nonatomic) NSString* selectTaskId;
@property(nonatomic) NSInteger selectedIndex;
@property(nonatomic) NSIndexPath* selectedIndexPath;

@property(nonatomic) NSMutableArray *incidentListArray;
@property(nonatomic) NSMutableDictionary *incidentPhotoListDic;
@property(nonatomic) NSDictionary *propertyDetailDic;
@property(nonatomic) NSMutableDictionary *inspectionDetailDic;
@property(nonatomic) NSMutableDictionary *groupAllFilesDic;


//views
@property(nonatomic) UIActivityIndicatorView* spinner;
@property(nonatomic) UIButton *backButton;
@property(nonatomic) UIView *largePhotoView;
@property(nonatomic) UIImageView *largeImageView;
@property(nonatomic) UIButton *largeImageCloseBtn;

//lefPanelView
@property(nonatomic) UIScrollView *leftPanelView;
@property(nonatomic) UITableView *lpsIncidentMenuTableView;
@property(nonatomic) UITableView *lpsPropertyDetailTableView;
@property(nonatomic) UITableView *lpsContactOwnerTableView;
@property(nonatomic) UITableView *lpsContactOfficeTableView;
@property(nonatomic) UIView *lpsBottomView;

//rightPanelView
@property(nonatomic) UIView *rightPanelView;


@property(nonatomic) NSMutableArray *incidentMenuArray;

//property
@property(nonatomic) BOOL detailViewIsShowing;

@end


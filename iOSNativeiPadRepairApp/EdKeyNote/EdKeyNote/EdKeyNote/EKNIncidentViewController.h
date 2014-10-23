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
#import <office365-base-sdk/OAuthentication.h>
#import "ListClient.h"
#import "ListItem.h"
#import "EKN+UIViewController.h"
#import "IncidentListItemCell.h"
#import "PropertyDetailsImage.h"
#import "PropertyDetailsCell.h"
#import "EKNEKNGlobalInfo.h"
#import "ContactOwnerCell.h"
#import "EKNCollectionViewCell.h"

@interface EKNIncidentViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>


//data
@property(nonatomic) ListClient *client;
@property(nonatomic) NSString* loginName;
@property(nonatomic) NSString* token;
@property(nonatomic) NSString* siteUrl;
@property(nonatomic) NSString* incidentId;
@property(nonatomic) NSString* selectPropertyId;
@property(nonatomic) NSString* selectIncidentId;
@property(nonatomic) NSString* selectInspectionId;
@property(nonatomic) NSString* selectRoomId;
@property(nonatomic) NSString* selectTaskId;
@property(nonatomic) NSInteger selectedIndex;

@property(nonatomic) NSMutableArray *incidentListArray;
@property(nonatomic) NSMutableDictionary *incidentPhotoListDic;
@property(nonatomic) NSMutableDictionary *roomInspectionPhotoDic;
@property(nonatomic) NSMutableDictionary *repairPhotoDic;
@property(nonatomic) NSDictionary *propertyDetailDic;
@property(nonatomic) NSMutableDictionary *inspectionDetailDic;


//views
@property(nonatomic) UIActivityIndicatorView* spinner;
@property(nonatomic) UITableView * rightTableView;
@property(nonatomic) UIView *detailLeftView;
@property(nonatomic) UIView *detailRightView;
@property(nonatomic) UIButton *backButton;
@property(nonatomic) UITableView *detailInspectionDetailTableView;
@property(nonatomic) UIView *detailRightDispatcher;
@property(nonatomic) UIView *detailRightInspector;
@property(nonatomic) UIView *detailRightAdd;
@property(nonatomic) UITableView * propertyDetailTableView;
@property(nonatomic) UITableView * contactOwnerTableView;
@property(nonatomic) UITableView * contactOfficeTableView;
@property(nonatomic) UIButton *finalizeBtn;
@property(nonatomic) UICollectionView *commentCollection;
@property(nonatomic) UICollectionView *inspectorCommentCollection;
@property(nonatomic) UILabel *roomTitleLbl;
@property(nonatomic) UILabel *separatorLbl;
@property(nonatomic) UILabel *incidentTypeLbl;
@property(nonatomic) UIButton *repairCommentDoneBtn;
@property(nonatomic) UITextView *tabDispatcherComments;
@property(nonatomic) UITextView *tabInsptorComments;
@property(nonatomic) UITextView *tabComments;
@property(nonatomic) UIView *largePhotoView;
@property(nonatomic) UIImageView *largeImageView;
@property(nonatomic) UIButton *largeImageCloseBtn;

//property
@property(nonatomic) BOOL canEditComments;
@property(nonatomic) BOOL detailViewIsShowing;
@property(nonatomic) BOOL cameraIsAvailable;


//function
-(void)setRightTableCell:(IncidentListItemCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)didUpdateRightTableCell:(NSIndexPath *)indexpath image:(UIImage*)image;
@end


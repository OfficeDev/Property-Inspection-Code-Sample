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
#import <office365-base-sdk/NSString+NSStringExtensions.h>
#import "ListClient.h"
#import "ListItem.h"
#import "EKN+UIViewController.h"
#import "PropertyListCell.h"
#import "PropertyDetailsImage.h"
#import "PropertyDetailsCell.h"
#import "InspectionListCell.h"
#import "EKNEKNGlobalInfo.h"
#import "ContactOwnerCell.h"
#import "EKNCollectionViewCell.h"
#import "RoomListCell.h"

typedef NS_ENUM(NSInteger, PropertySubViewsTag) {
    LeftPropertyDetailTableViewTag=390,
    LeftBackButtonViewTag,
    LefSliderViewTag=500,
    LefPropertySegLeftBtnTag,
    LefPropertySegMidBtnTag,
    LefPropertySegRightBtnTag,
    LeftInspectionLeftTableViewTag,
    LeftInspectionMidTableViewTag,
    LeftInspectionRightTableViewTag,
    LeftRoomSegViewTag,
    LefRoomSegLeftBtnTag,
    LefRoomSegMidBtnTag,
    LefRoomSegRightBtnTag,
    LeftRoomTableViewTag,
    LeftFinalizeBtnTag,
    
    RightPropertyDetailTableViewTag=600,
    RightSliderViewTag,
    RightRoomImageDateLblTag,
    RightRoomImageLargeImageTag,
    RightRoomCollectionViewTag,
    
    CommentPopViewTag=700,
    CommentCameraBtnTag,
    CommentCollectionViewTag,
    CommentTextBackgroundViewTag,
    CommentTextViewTag,
    CommentDoneBtnTag,
    CommentCancelBtnTag,
    
    CommentPhotoDetailPopViewTag,
    CommentPhotoDetailViewTag,
    CommentPhotoCloseViewTag,
};

@interface EKNPropertyDetailsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,
UICollectionViewDataSource,UICollectionViewDelegate, UITextViewDelegate>

//@property NSMutableArray* SharepointList;

//need get data from extend
@property(nonatomic) NSString* loginName;
@property(nonatomic) NSString* token;
@property(nonatomic) NSString* selectRightPropertyItemId;
//end
@property(nonatomic) NSIndexPath * selectRightPropertyTableIndexPath;
@property(nonatomic) NSIndexPath * selectLetInspectionIndexPath;
@property(nonatomic) NSIndexPath * selectLetRoomIndexPath;
@property(nonatomic) NSIndexPath * selectRightCollectionIndexPath;




//all inspections list. store all inspections list, Listitem
//ID,sl_datetime,
//sl_inspector/ID,sl_inspector/Title,sl_inspector/sl_accountname,sl_inspector/sl_emailaddress
//sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode
@property(nonatomic) NSMutableArray *inspectionsListArray;

//current and upcoming inspections dict
//top: current listitem
//bottom: bottom listitem
@property(nonatomic) NSMutableDictionary *rightPropertyListDic;

//key is propery Id, use to store property Resource and incidents
//inspectionslist
//----ID,sl_accountname, bowner, icon, sl_datetime
//contactowner
//contactemail
//ServerRelativeUrl
//image
//trytimes
@property(nonatomic) NSMutableDictionary *propertyDic;


//key is inspection Id, use to store inspection andincidents
//---icon: red
//----sl_status
@property(nonatomic) NSMutableDictionary *incidentOfInspectionDic;

//key is room Id, use to store room andincidents
@property(nonatomic)NSMutableDictionary *incidentOfRoomsDic;

//key is inspection Id, use to store rooms
//one inspection maybe have many rooms
//one room maybe have many pictures
//key insId
//value rooms array
//----key Id value roomId
//----key Title  value roomTitle
//----key ImagesArray value Array to store the images
//--------------------------key Id value File item Id
//--------------------------key ServerRelativeUrl vaule ServerRelativeUrl
//--------------------------key trytimes vaule trytimes
//--------------------------key image vaule image
@property(nonatomic) NSMutableDictionary *roomsOfInspectionDic;


//cammera Images
@property(nonatomic) NSMutableArray *commentImages;
@property(nonatomic) NSString *commentId;

@property(nonatomic) UIActivityIndicatorView* donwloadspinner;
@property(nonatomic) UIActivityIndicatorView* uploadspinner;



@property(nonatomic) ListClient *listClient;
/**/

-(void)didUpdateRightPropertyTableCell:(NSIndexPath *)indexpath image:(UIImage*)image;
-(void)setLeftInspectionTableCell:(InspectionListCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSString *)getSelectLeftInspectionItemId;
-(void)getRoomImageFileREST:(NSString *)path propertyId:(NSInteger)proId inspectionId:(NSInteger)insid roomIndex:(NSInteger)roomIndex imageIndex:(NSInteger)imageIndex;
@end

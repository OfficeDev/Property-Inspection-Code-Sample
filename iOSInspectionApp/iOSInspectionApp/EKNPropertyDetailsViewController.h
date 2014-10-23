//
//  EKNPropertyDetailsViewController.h
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
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
#import "CommentCollectionViewCell.h"


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
    CommentDpBtnTag,
    CommentPickerViewTag,
    
    CommentPhotoDetailPopViewTag,
    CommentPhotoDetailViewTag,
    CommentPhotoCloseViewTag,
};

@interface EKNPropertyDetailsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,
UICollectionViewDataSource,UICollectionViewDelegate, UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

//@property NSMutableArray* SharepointList;

//need get data from extend
@property(nonatomic) NSString* loginName;
@property(nonatomic) NSString* token;
@property(nonatomic) NSString* selectRightPropertyItemId;
@property(nonatomic) NSString* exchangetoken;
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
//key propery Id,value is property dict
//----key inspectionslist value nsarry(dic)
//------------ID,sl_accountname, bowner, icon, sl_datetime,sl_finalized
//----key contactowner value contactowner
//----key contactemail value contactemail
//----key imageID value imageID
//----key ServerRelativeUrl value ServerRelativeUrl
//----key image value image
//----key trytimesb value trytimes
//----key RoomsArray value rooms arrary(dic)
//--------key Id value roomid
//--------key Title value roomtitle
@property(nonatomic) NSMutableDictionary *propertyDic;


//key is propertyId,value is dic
//--key is inspectionid,value is dic
//------key icon, value red to flag the inspection list red/green iocn
//------key roomId(room1), value YES to flag the room list red/green iocn

@property(nonatomic) NSMutableDictionary *incidentOfInspectionDic;


//key is inspection Id, use to store rooms
//one inspection maybe have many rooms
//one room maybe have many pictures
//key insId value rooms dict
//----key roomId value ImagesArray(diC)
//--------------------------key Id value File item Id
//--------------------------key ServerRelativeUrl vaule ServerRelativeUrl
//--------------------------key trytimes vaule trytimes
//--------------------------key image vaule image

@property(nonatomic) NSMutableDictionary *roomsOfInspectionDic;


//cammera Images on comment pop up view
@property(nonatomic) NSMutableArray *commentViewImages;
//update/create comment item
@property(nonatomic) NSString *commentItemId;

//store the type filed value of the incident list
@property(nonatomic)NSMutableArray *incidentTypeArray;

@property(nonatomic) UIActivityIndicatorView* propertyViewSpinner;
@property(nonatomic) UIActivityIndicatorView* commentViewSpinner;



@property(nonatomic) ListClient *listClient;

@property(nonatomic) MFMailComposeViewController *mailController;
-(void)setDataExternal:(NSString *)pid loginName:(NSString *)loginName token:(NSString *)token emailtoken:(NSString *)exchangetoken;
@end

//
//  EKNRoomDetailsViewController.h
//  EdKeyNote
//
//  Created by Max on 10/9/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <office365-base-sdk/OAuthentication.h>
#import <office365-base-sdk/NSString+NSStringExtensions.h>
#import "EKN+UIImagePickerController.h"
#import "EKN+UIViewController.h"
#import "EKNCollectionViewCell.h"
#import "ContactOwnerCell.h"
#import "ListClient.h"
#import "ListItem.h"

@interface EKNRoomDetailsViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,
UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) NSString* token;
@property(nonatomic) NSString* propertyId;
@property(nonatomic) NSInteger selectInspetionIndex;
//key inspectionslist,inspectionslist is array
//key contactowner
//key contactemail
@property(nonatomic) NSDictionary *inspectionsDic;
//key is inspection Id, use to store rooms
//one inspection maybe have many rooms
//one room maybe have many pictures
@property(nonatomic) NSMutableDictionary *roomsOfInspectionDic;

@property(nonatomic) UIActivityIndicatorView* spinner;

@property(nonatomic) UITableView * inspectionLeftTableView;
@property(nonatomic) UITableView * inspectionMidTableView;
@property(nonatomic) UITableView * inspectionRightTableView;



@property(nonatomic) UIView *incidentCommentPopupView;
@property(nonatomic) UIView *commentPopupView;
@property(nonatomic) UIButton *incidentCommentCamera;
@property(nonatomic) UIButton *commentCamera;
@property(nonatomic) UIView *photoDetailPopupView;
@property(nonatomic) UIImageView *largePhotoView;

@property(nonatomic) UIImageView *rightLargePhotoView;
@property(nonatomic) UIView *rightTopView;
@property(nonatomic) UILabel *rightDateLabel;
@property(nonatomic) UILabel *rightAuthorLabel;
@property(nonatomic) UIButton *selectedImageButton;

@property(nonatomic) NSMutableArray *commentImages;
@property(nonatomic) NSMutableArray *incidentCommentImages;
@property(nonatomic) NSMutableArray *rightViewImages;
@property(nonatomic) NSMutableArray *largeCommentImages;
@property(nonatomic) NSMutableArray *largeIncidentCommentImages;
@property(nonatomic) NSMutableArray *largerRightViewImages;

@property(nonatomic) UICollectionView *commentCollection;
@property(nonatomic) UICollectionView *incidentCommentCollection;
@property(nonatomic) UICollectionView *rightImageCollection;

@property BOOL cameraIsAvailable;
@property BOOL isShowingComment;
@property BOOL isShowingIncident;
@property int testCount;
@property int selectedImageIndex;

-(void)initRoomsValue:(NSDictionary *)insDic propertyId:(NSString *)pid inspetionId:(NSInteger)insId token:(NSString *)tkn;

@end

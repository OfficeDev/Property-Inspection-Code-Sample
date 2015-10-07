
//
//  EKNOneNoteTableView
//  iOSRepairApp
//
//  Created by canviz on 9/3/15.
//  Copyright (c) 2015 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKNListClient.h"
#import "EKNListItem.h"
#import "EKNEKNGlobalInfo.h"
#import "EKNCollectionViewCell.h"
#import "EKNVideoService.h"
#import "SPVideoItem.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface EKNIncidentDetailView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property(nonatomic) UIView *detailRightDispatcher;
@property(nonatomic) UIView *detailRightInspector;
@property(nonatomic) UIView *detailRightAdd;

@property(nonatomic) UITextView *tabDispatcherComments;
@property(nonatomic) UITextView *tabInsptorComments;
@property(nonatomic) UITextView *tabComments;

@property(nonatomic) UICollectionView *commentCollection;
@property(nonatomic) UICollectionView *inspectorCommentCollection;

@property(nonatomic) NSString* token;
@property(nonatomic) EKNListClient *client;

@property(nonatomic) NSString* selectInspectionId;
@property(nonatomic) NSString* selectIncidentId;
@property(nonatomic) NSString* selectRoomId;

@property(nonatomic) NSMutableDictionary *roomInspectionPhotoDic;
@property(nonatomic) NSMutableDictionary *repairPhotoDic;

@property (nonatomic, assign) id <IncidentSubViewActionDelegate> actiondelegate;

@property(nonatomic) BOOL canEditComments;
@property(nonatomic) BOOL cameraIsAvailable;

-(id)intIncidentDetailView:(NSString *)token;
-(void)showIncidentDetailView:(NSString *)roomtitle incidentType:(NSString *)incidentType status:(NSString *)status incidentItem:(EKNListItem *)incidentItem
                 inspectionId:(NSString *)inspectionId incidentId:(NSString *)incidentId roomId:(NSString *)roomId;
-(void)afterUpdateRepairCompleted:(BOOL)canEdit;
@end



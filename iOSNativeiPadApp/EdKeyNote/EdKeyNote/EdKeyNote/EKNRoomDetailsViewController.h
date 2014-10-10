//
//  EKNRoomDetailsViewController.h
//  EdKeyNote
//
//  Created by Max on 10/9/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKN+UIImagePickerController.h"
#import "EKN+UIViewController.h"
#import "EKNCollectionViewCell.h"
@interface EKNRoomDetailsViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(retain,nonatomic) UIView *incidentCommentPopupView;
@property(retain,nonatomic) UIView *commentPopupView;
@property(retain,nonatomic) UIButton *incidentCommentCamera;
@property(retain,nonatomic) UIButton *commentCamera;
@property(retain,nonatomic) UIView *photoDetailPopupView;
@property(retain,nonatomic) UIImageView *largePhotoView;

@property(strong,nonatomic) NSMutableArray *commentImages;
@property(strong,nonatomic) NSMutableArray *incidentCommentImages;
@property(strong,nonatomic) NSMutableArray *largeCommentImages;
@property(strong,nonatomic) NSMutableArray *largeIncidentCommentImages;
@property(weak,nonatomic) UICollectionView *commentCollection;
@property(weak,nonatomic) UICollectionView *incidentCommentCollection;

@property BOOL cameraIsAvailable;
@property int commentImageCounter;
@property int incidentCommentImageCounter;
@property BOOL incidentCommentViewIsShow;

@end

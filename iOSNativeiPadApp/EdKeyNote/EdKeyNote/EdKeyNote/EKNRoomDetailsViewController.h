//
//  EKNRoomDetailsViewController.h
//  EdKeyNote
//
//  Created by Max on 10/9/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EKNRoomDetailsViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property(retain,nonatomic) UIView *incidentCommentPopupView;
@property(retain,nonatomic) UIView *commentPopupView;
@property(retain,nonatomic) UIButton *incidentCommentCamera;
@property(retain,nonatomic) UIButton *commentCamera;

@property BOOL cameraIsAvailable;
@property int commentImageCounter;
@property int incidentCommentImageCounter;
@property BOOL isIncidentCommentCamera;

@end

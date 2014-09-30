//
//  EKNIncidentDetailViewController.h
//  EdKeyNote
//
//  Created by Canviz on 9/28/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EKNIncidentDetailViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(assign,nonatomic)int *incidentId;
@property(assign,nonatomic)int *propertyId;
@property(assign,nonatomic)int *roomId;
@property(assign,nonatomic)int *inspectionId;

@property(retain, nonatomic)UIScrollView *scrollView;

@end

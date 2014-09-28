//
//  EKNLoginViewController.h
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EKNLoginViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(retain, nonatomic) IBOutlet UITextField *nameTxt;
@property(retain, nonatomic) IBOutlet UITextField *pwdTxt;


@end

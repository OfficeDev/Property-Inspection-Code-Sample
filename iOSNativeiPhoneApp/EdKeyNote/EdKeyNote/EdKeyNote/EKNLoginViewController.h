//
//  EKNLoginViewController.h
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <office365-base-sdk/Credentials.h>
#import <office365-base-sdk/LoginClient.h>
#import "EKNIncidentViewController.h"

@interface EKNLoginViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(retain, nonatomic) IBOutlet UITextField *nameTxt;
@property(retain, nonatomic) IBOutlet UITextField *pwdTxt;

@property (strong, nonatomic)NSString* authority;
@property (strong, nonatomic)NSString* redirectUriString;
@property (strong, nonatomic)NSString* resourceId;
@property (strong, nonatomic)NSString* clientId;
@property (strong, nonatomic)Credentials* credentials;
@property (strong, nonatomic)NSString* token;
@end

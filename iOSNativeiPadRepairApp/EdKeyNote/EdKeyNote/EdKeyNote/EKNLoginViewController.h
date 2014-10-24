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
#import "EKN+UIViewController.h"

@interface EKNLoginViewController : UIViewController

@property (strong, nonatomic)NSString* authority;
@property (strong, nonatomic)NSString* redirectUriString;
@property (strong, nonatomic)NSString* resourceId;
@property (strong, nonatomic)NSString* clientId;
@property (strong, nonatomic)NSString* demoSiteCollectionUrl;
@property (strong, nonatomic)NSString* dispatcherEmail;
@property (strong, nonatomic)Credentials* credentials;
@property (strong, nonatomic)NSString* token;

@property (retain) UIButton *login_bt;
@property (retain) UILabel *settings_lbl;

@property (strong, nonatomic)NSString* incidentId;

@end

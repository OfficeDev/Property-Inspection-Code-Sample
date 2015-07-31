//
//  EKNLoginViewController.h
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKN+UIViewController.h"
#import <ADALiOS/ADAuthenticationContext.h>
#import <ADALiOS/ADAuthenticationSettings.h>
#import <Foundation/Foundation.h>
#import <ADALiOS/ADAuthenticationParameters.h>
#import <ADALiOS/ADLogger.h>
#import <ADALiOS/ADInstanceDiscovery.h>
#import <office365_odata_base/office365_odata_base.h>

@interface EKNLoginViewController : UIViewController

@property (strong, nonatomic)NSString* authority;
@property (strong, nonatomic)NSString* redirectUriString;
@property (strong, nonatomic)NSString* demoSiteServiceResourceId;
@property (strong, nonatomic)NSString* clientId;
@property (strong, nonatomic)NSString* demoSiteCollectionUrl;
@property (strong, nonatomic)NSString* dispatcherEmail;

@property (strong, nonatomic)NSString* propertyId;


@property (nonatomic) UIButton *login_bt;
@property (nonatomic) UILabel *settings_lbl;

@end

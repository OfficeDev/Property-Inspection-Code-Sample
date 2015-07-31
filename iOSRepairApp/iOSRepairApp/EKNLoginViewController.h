//
//  EKNLoginViewController.h
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKN+UIViewController.h"
#import <Foundation/Foundation.h>
#import <ADALiOS/ADAuthenticationContext.h>
#import <ADALiOS/ADAuthenticationParameters.h>
#import <ADALiOS/ADAuthenticationSettings.h>
#import <ADALiOS/ADLogger.h>
#import <ADALiOS/ADInstanceDiscovery.h>
#import <office365_odata_base/office365_odata_base.h>

@interface EKNLoginViewController : UIViewController

@property (strong, nonatomic)NSString* authority;
@property (strong, nonatomic)NSString* redirectUriString;
@property (strong, nonatomic)NSString* demoSiteServiceResourceId;
@property (strong, nonatomic)NSString* clientId;
@property (strong, nonatomic)NSString* token;

@property (retain) UIButton *login_bt;
@property (retain) UILabel *settings_lbl;

@property (strong, nonatomic)NSString* incidentId;

-(void)clearCredentials;
-(void) getTokenWith :(BOOL) clearCache completionHandler:(void (^) (NSString *))completionBlock;

@end

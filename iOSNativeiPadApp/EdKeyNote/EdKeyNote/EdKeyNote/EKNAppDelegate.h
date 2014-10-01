//
//  EKNAppDelegate.h
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKNLoginViewController.h"

@interface EKNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) EKNLoginViewController *viewController;
@property (strong, nonatomic) UINavigationController *naviController;

@end

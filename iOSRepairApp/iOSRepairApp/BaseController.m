//
//  BaseController.m
//  iOSRepairApp
//
//  Created by Max on 10/28/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "BaseController.h"
#import "EKNLoginViewController.h"

@implementation BaseController

+(UIActivityIndicatorView*)getSpinner : (UIView*)view{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [view addSubview:spinner];
    spinner.hidesWhenStopped = YES;
    
    [spinner startAnimating];
    return spinner;
}

@end

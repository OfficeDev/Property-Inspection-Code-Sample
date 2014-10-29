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

+(void)getClient : (void (^) (MSSharePointClient* ))callback{
    
    EKNLoginViewController* loginController = [[EKNLoginViewController alloc] init];
    
    [loginController getTokenWith :true completionHandler:^(NSString *token) {
        
        MSDefaultDependencyResolver* resolver = [MSDefaultDependencyResolver alloc];
        MSOAuthCredentials* credentials = [MSOAuthCredentials alloc];
        [credentials addToken: token];
        
        MSCredentialsImpl* credentialsImpl = [MSCredentialsImpl alloc];
        
        [credentialsImpl setCredentials:credentials];
        [resolver setCredentialsFactory:credentialsImpl];
        
        callback([[MSSharePointClient alloc] initWitUrl:[@"https://techedairlift04.spoppe.com" stringByAppendingString:@"/_api/v1.0/me"] dependencyResolver:resolver]);
    }];
}

+(UIActivityIndicatorView*)getSpinner : (UIView*)view{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [view addSubview:spinner];
    spinner.hidesWhenStopped = YES;
    
    [spinner startAnimating];
    return spinner;
}

@end

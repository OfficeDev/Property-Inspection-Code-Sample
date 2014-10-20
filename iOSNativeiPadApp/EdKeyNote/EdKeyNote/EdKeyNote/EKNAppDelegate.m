//
//  EKNAppDelegate.m
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNAppDelegate.h"
#import "EKNPropertyDetailsViewController.h"

@implementation EKNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    
    self.window = [[UIWindow alloc] initWithFrame:
                   [[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.naviController = [[UINavigationController alloc]
                           initWithRootViewController:[[EKNLoginViewController alloc] init]];
    
    self.window.rootViewController = self.naviController;

    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

    NSString *low = [((NSString *)[url absoluteString]) lowercaseString];
    if([low hasPrefix:@"inspectionapp://"])
    {
        NSString *propertyId = [low substringFromIndex:(@"inspectionapp://").length-1];
        if([[NSScanner scannerWithString:propertyId] scanInt:nil])
        {
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setValue:propertyId forKey:@"propertyId"];
            [standardUserDefaults synchronize];
            if(self.naviController!=nil)
            {
                [self.naviController popToRootViewControllerAnimated:NO];
                EKNLoginViewController *login = [[EKNLoginViewController alloc] init];
                [self.naviController pushViewController:login animated:YES];
            }
        }
    }
    
    return  YES;
    
    // Check the calling application Bundle ID
    /*if ([sourceApplication isEqualToString:@"com.canviz.EdKeyNote"])
    {
        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
        NSLog(@"URL scheme:%@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
        
        return YES;
    }
    else
        return NO;*/
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;//important for uiimagepickercontroller
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

//
//  EKN+UIViewController.m
//  EdKeyNote
//
//  Created by canviz on 10/10/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKN+UIViewController.h"

@implementation UIViewController(EKN)
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
@end

//
//  EKN+NavigationController.m
//  EdKeyNote
//
//  Created by canviz on 10/10/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKN+NavigationController.h"

@implementation UINavigationController(EKN)
- (BOOL)shouldAutorotate {
    if (self.topViewController != nil)
        return [self.topViewController shouldAutorotate];
    else
        return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    if (self.topViewController != nil)
        return [self.topViewController supportedInterfaceOrientations];
    else
        return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.topViewController != nil)
        return [self.topViewController preferredInterfaceOrientationForPresentation];
    else
        return [super preferredInterfaceOrientationForPresentation];
}
@end

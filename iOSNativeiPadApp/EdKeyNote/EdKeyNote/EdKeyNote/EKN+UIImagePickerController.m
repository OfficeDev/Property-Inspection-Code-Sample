//
//  EKN+UIImagePickerController.m
//  EdKeyNote
//
//  Created by canviz on 10/10/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKN+UIImagePickerController.h"

@implementation UIImagePickerController(EKN)
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight;
}
@end

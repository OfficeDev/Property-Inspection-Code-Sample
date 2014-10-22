//
//  EKN+UIImagePickerController.h
//  EdKeyNote
//
//  Created by canviz on 10/10/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImagePickerController(EKN)
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
@end

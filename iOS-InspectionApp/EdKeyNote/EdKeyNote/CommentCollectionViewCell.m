//
//  CommentCollectionViewCell.m
//  EdKeyNote
//
//  Created by canviz on 10/16/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "CommentCollectionViewCell.h"

@implementation CommentCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CommentCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    return self;
}

@end

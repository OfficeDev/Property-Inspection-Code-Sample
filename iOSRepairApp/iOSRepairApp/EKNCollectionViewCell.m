//
//  EKNCollectionViewCell.m
//  EdKeyNote
//
//  Created by Max on 10/10/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNCollectionViewCell.h"

@implementation EKNCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"EKNCollectionViewCell" owner:self options:nil];
        
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

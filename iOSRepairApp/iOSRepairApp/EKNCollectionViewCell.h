//
//  EKNCollectionViewCell.h
//  EdKeyNote
//
//  Created by Max on 10/10/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EKNCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *collectionImage;
-(void)setImage:(UIImage *)image;
@end

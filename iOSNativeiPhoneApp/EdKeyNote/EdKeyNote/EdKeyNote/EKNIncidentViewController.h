//
//  EKNIncidentViewController.h
//  EdKeyNote
//
//  Created by Canviz on 9/28/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EKNIncidentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *incidentItems;
@property (retain, nonatomic) UITableView *incidentTableView;

@end

//
//  EKNIncidentViewController.m
//  EdKeyNote
//
//  Created by Canviz on 9/28/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNIncidentViewController.h"
#import "EKNIncidentDetailViewController.h"

@interface EKNIncidentViewController ()

@end

@implementation EKNIncidentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Incidents";
    self.incidentTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.incidentTableView.dataSource = self;
    self.incidentTableView.delegate = self;
    [self.view addSubview:self.incidentTableView];
    
    self.incidentItems = @[@"Incidents 1",
                           @"Incidents 2",
                           @"Incidents 3",
                           @"Incidents 4",
                           @"Incidents 5",
                           @"Incidents 6",
                           @"Incidents 7",
                           @"Incidents 8",
                           @"Incidents 9",
                           @"Incidents 10",
                           @"Incidents 11",
                           @"Incidents 12 incidents incidents incidents",
                           @"Incidents 13",
                           @"Incidents 14",
                           @"Incidents 15",];
    
}

- (void)loadIincidents
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.incidentItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    cell.textLabel.text = self.incidentItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectValue = self.incidentItems[indexPath.row];
    NSLog(@"You click on %@",selectValue);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EKNIncidentDetailViewController *detail = [[EKNIncidentDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ActorTableViewController.m
//  Movie Mania
//
//  Created by david on 11/13/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import "ActorTableViewController.h"

@interface ActorTableViewController ()
{
//    NSArray *actors;
}

@end

@implementation ActorTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *bgColor = [UIColor colorWithHue:0.902 saturation:0.761 brightness:0.527 alpha:1];
    self.view.backgroundColor = bgColor;
    
    [self animateTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animateTableView
{
    [UITableView beginAnimations:@"scrollAnimation" context:nil];
    [UITableView setAnimationDuration:3.0];
    [self.tableView setContentOffset:CGPointMake(0, 100)];
    [UITableView commitAnimations];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActorCell" forIndexPath:indexPath];
    
    NSString *actor = self.actors[indexPath.row];
    cell.textLabel.text = actor;
    
    return cell;
}

@end

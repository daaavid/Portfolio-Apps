//
//  ReviewsTableViewController.m
//  Movie Mania
//
//  Created by david on 11/13/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import "ReviewsTableViewController.h"

@interface ReviewsTableViewController ()

@end

@implementation ReviewsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *bgColor = [UIColor colorWithHue:0.902 saturation:0.761 brightness:0.527 alpha:1];
    self.view.backgroundColor = bgColor;
    
    [self animateTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    return self.reviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    NSString *review = self.reviews[indexPath.row];
    
    cell.textLabel.text = review;
    
    int row = (int)indexPath.row;

    if(row == 0)
    {
        cell.detailTextLabel.text = @"IMDB";
    }
    else if(row == 1)
    {
        cell.detailTextLabel.text = @"Metascore";
    }
    else if(row == 2)
    {
        cell.detailTextLabel.text = @"Rotten Tomatoes";
    }
    
    return cell;
}

@end

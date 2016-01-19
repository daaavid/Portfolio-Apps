//
//  GenreTableViewController.m
//  Movie Mania
//
//  Created by david on 11/14/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import "GenreTableViewController.h"

@interface GenreTableViewController ()

@end

@implementation GenreTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIColor *bgColor = [UIColor colorWithHue:0.902 saturation:0.761 brightness:0.527 alpha:1];
    self.view.backgroundColor = bgColor;
    
    [self animateTableView];
}

- (void)didReceiveMemoryWarning {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.genres.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenreCell" forIndexPath:indexPath];
    
    NSString *genre = self.genres[indexPath.row];
    cell.textLabel.text = genre;
    
    return cell;
}

@end

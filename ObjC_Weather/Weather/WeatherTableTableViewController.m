//
//  WeatherTableTableViewController.m
//  Forecaster
//
//  Created by david on 1/21/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "WeatherTableTableViewController.h"

@interface WeatherTableTableViewController ()

@end

@implementation WeatherTableTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self.editButtonItem setTintColor: [UIColor colorWithRed:0.007 green:0.58 blue:0.725 alpha:1]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.weeklyForecast count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForecastCell *cell = (ForecastCell *)[tableView dequeueReusableCellWithIdentifier:@"ForecastCell" forIndexPath:indexPath];
    
//    Location *location = (Location *)locationArr[indexPath.row];
//
//    cell.cityLabel.text = [NSString
//        stringWithFormat:@"%@, %@", location.city, location.state];
//    
//    if (location.weather)
//    {
//        cell.temperatureLabel.text = [NSString stringWithFormat:@"%@ °", [location.weather.temperature stringValue]];
//        cell.quickWeatherLabel.text = location.weather.summary;
//        //TODO: - assignWeatherImg
//    }

    [self setCellViewColor:cell row:indexPath.row];
    return cell;
}

- (void)setCellViewColor:(UITableViewCell *)cell row:(NSInteger)row;
{
    ForecastCell *forecastCell = (ForecastCell *)cell;
    NSArray *colors = [[NSArray alloc] init];
    
    //making sure that cells that are next to each other don't end up being the same color
    if (row % 2 == 0)
    {
        colors = @[
         [UIColor colorWithRed:0.13 green:0.13 blue:0.25 alpha:1],
         [UIColor colorWithRed:0.29 green:0.25 blue:0.45 alpha:1],
         [UIColor colorWithRed:1.00 green:0.78 blue:0.34 alpha:1],
         [UIColor colorWithRed:0.07 green:0.62 blue:0.64 alpha:1],
         [UIColor colorWithRed:0.0874 green:0.314 blue:0.4142 alpha:1.0],
         ];
    }
    else
    {
        colors = @[
         [UIColor colorWithRed:0.67 green:0.39 blue:0.45 alpha:1],
         [UIColor colorWithRed:0.09 green:0.75 blue:0.73 alpha:1],
         [UIColor colorWithRed:0.18 green:0.16 blue:0.16 alpha:1],
         [UIColor colorWithRed:0.94 green:0.36 blue:0.36 alpha:1],
         [UIColor colorWithRed:1.00 green:0.73 blue:0.29 alpha:1],
         ];
    }
    
    UIColor *color = colors[arc4random() % [colors count]];
    forecastCell.bgView.backgroundColor = color;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

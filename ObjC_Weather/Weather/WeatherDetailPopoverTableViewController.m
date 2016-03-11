//
//  WeatherDetailPopoverTableViewController.m
//  Weather
//
//  Created by david on 3/11/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "WeatherDetailPopoverTableViewController.h"
#import "ForecastCell.h"



@interface WeatherDetailPopoverTableViewController ()

@property (nonatomic, strong) NSArray *properties;

@end

@implementation WeatherDetailPopoverTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.properties count];
}

- (NSArray *)properties
{
    if (!_properties)
    {
        _properties = [NSArray array];
    }
    
    if (self.weather)
    {
        _properties = @[
                        @"Temperature",
                        @"Feels Like",
                        @"Humidity",
                        @"Wind Speed",
                        @"Chance of Rain",
                        @"Rain"
                        ];
    }
    
    return _properties;
}


- (NSString *)getValueFromPropertyString:(NSString *)property
{
    Weather *weather = self.weather;
    
    if ([property isEqualToString:@"Temperature"]) {
        return [NSString stringWithFormat:@"%@°", weather.temperature];
    }
    else if ([property isEqualToString:@"Feels Like"]) {
        return [NSString stringWithFormat:@"%@°", weather.apparentTemperature];
    }
    else if ([property isEqualToString:@"Humidity"]) {
        return [Weather getPercentString:weather.humidity];
    }
    else if ([property isEqualToString:@"Wind Speed"]) {
        return [NSString stringWithFormat:@"%.2f m/s", [weather.windSpeed doubleValue]];
    }
    else if ([property isEqualToString:@"Chance of Rain"]) {
        return [Weather getPercentString:weather.precipitationProbability];
    }
    else if ([property isEqualToString:@"Rain"]) {
        return [Weather getPrecipIntensityString:self.weather];
    }
    return @"";
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForecastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherDetailCell" forIndexPath:indexPath];
    
    NSString *property = self.properties[indexPath.row];
    
    cell.weatherImageView.image = nil;
    cell.weekdayLabel.text = property;
    cell.temperatureLabel.text = [self getValueFromPropertyString:property];
    
    cell.weekdayLabel.textColor = self.textColor;
    cell.temperatureLabel.textColor = self.textColor;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

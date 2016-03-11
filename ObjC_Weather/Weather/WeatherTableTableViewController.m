//
//  WeatherTableTableViewController.m
//  Forecaster
//
//  Created by david on 1/21/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "WeatherTableTableViewController.h"
#import "TimeOfDay.h"
#import "AnimationManager.h"
#import "Settings.h"
#import "WeatherDetailPopoverTableViewController.h"

typedef enum {
    Hourly,
    Daily
}ForecastIdentifier;

@interface WeatherTableTableViewController ()
<
UIPopoverPresentationControllerDelegate,
UIAdaptivePresentationControllerDelegate
>
{
    NSArray *weekdays;
    ForecastIdentifier forecastIdentifier;
    AnimationManager *animator;
    NSIndexPath *popoverIndexPath;
}

@property (nonatomic, strong) NSArray *hours;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation WeatherTableTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.segmentedControl setTintColor:[self setColor]];
    
    weekdays = [TimeOfDay getUpcomingDaysOfWeekFromToday];
    forecastIdentifier = Daily;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (forecastIdentifier == Daily)
    {
        return [weekdays count];
    }
    else
    {
        return [self.hours count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForecastCell *cell = (ForecastCell *)[tableView dequeueReusableCellWithIdentifier:@"ForecastCell" forIndexPath:indexPath];
    
    [cell.weekdayLabel setTextColor:[self setColor]];
    [cell.temperatureLabel setTextColor:[self setColor]];
    
    NSArray *forecast;
    
    if (forecastIdentifier == Daily)
    {
        NSString *weekdayStr = weekdays[indexPath.row];
        [cell.weekdayLabel setText:weekdayStr];
        
        if ([weekdayStr isEqualToString:[TimeOfDay getTodayString]])
        {
            [cell.temperatureLabel setText:[NSString stringWithFormat:@"%@°", self.weather.temperature]];
            
//            [cell.weekdayLabel setAlpha:1];
//            [cell.temperatureLabel setAlpha:1];
//            [cell.weatherImageView setAlpha:1];
        }
        
        forecast = [[NSArray alloc] initWithArray:self.weather.dailyForecast];
    }
    else
    {
        NSString *hour = self.hours[indexPath.row];
        [cell.weekdayLabel setText:hour];
        
        forecast = [[NSArray alloc] initWithArray:self.weather.hourlyForecast];
    }
    
    
    if ([forecast firstObject])
    {
        Weather *weather = forecast[indexPath.row];
        [cell.temperatureLabel setText:[NSString stringWithFormat:@"%@°", weather.temperature]];
        [cell.weatherImageView setImage:[UIImage imageNamed:weather.icon]];
        [cell.weatherImageView setTintColor:[self setColor]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (forecastIdentifier == Daily)
//    {
//        [self presentWeatherDetailPopover:indexPath];
//    }
//    else
//    {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }
    [self presentWeatherDetailPopover:indexPath];
}

- (void)presentWeatherDetailPopover:(NSIndexPath *)indexPath
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WeatherDetailPopoverTableViewController *controller = (WeatherDetailPopoverTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"WeatherDetailPopoverTableViewController"];
    
    Weather *weather;
    
    if (forecastIdentifier == Daily)
    {
        weather = self.weather.dailyForecast[indexPath.row];
    }
    else if (forecastIdentifier == Hourly)
    {
        weather = self.weather.hourlyForecast[indexPath.row];
    }
    
    controller.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover = controller.popoverPresentationController;
    
    controller.preferredContentSize = CGSizeMake(self.view.frame.size.width * .8, 36 * 6);
    controller.weather = weather;
    controller.textColor = [self setColor];
    
    popover.delegate = self;
    
    popover.sourceView = self.parentViewController.view;
    popover.sourceRect = CGRectMake(
                                    self.parentViewController.view.center.x,
                                    self.parentViewController.view.center.y,
                                    self.parentViewController.view.frame.size.height,
                                    self.parentViewController.view.frame.size.width
                                    );
    
    
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:controller animated:YES completion:nil];
    
    popoverIndexPath = indexPath;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    [self.tableView deselectRowAtIndexPath:popoverIndexPath animated:YES];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
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

- (UIColor *)setColor
{
    if ([TimeOfDay DayOrNight] == Day)
    {
        return [UIColor colorWithRed:0.17 green:0.45 blue:0.64 alpha:1];
    }
    else
    {
        return [UIColor colorWithRed:0.2 green:0.13 blue:0.51 alpha:1];
    }
}

#pragma mark: - computed stuff

- (NSArray *)hours
{
    if (self.weather)
    {
        NSMutableArray *hours = [[NSMutableArray alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        for (int index = 0; index <= 12; index++)
        {
            Weather *weather = self.weather.hourlyForecast[index];
            NSDateComponents *components = [calendar components:(NSCalendarUnitHour) fromDate:weather.date];
//            NSLog(@"%ld", (long)[components hour]);
            [hours addObject:[self getHourString:[components hour]]];
        }
        
        return hours;
    }
    return nil;
}

- (NSString *)getHourString:(NSInteger)hour
{
    NSString *suffix = @"am";
    
    if (hour > 12)
    {
        hour -= 12;
        suffix = @"pm";
    }
    else if (hour == 0)
    {
        hour = 12;
    }
    
    return [NSString stringWithFormat:@"%ld %@", (long)hour, suffix];
}

#pragma mark: - hourly/daily switcher

- (IBAction)segmentedControlDidChangeValue:(UISegmentedControl *)sender
{
    if (forecastIdentifier == Daily)
    {
        forecastIdentifier = Hourly;
    }
    else
    {
        forecastIdentifier = Daily;
    }
    
    [self.tableView reloadData];
}

@end

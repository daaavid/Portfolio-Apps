//
//  LocationSearchTableViewController.m
//  Weather
//
//  Created by david on 2/18/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "LocationSearchTableViewController.h"
#import "ViewManager.h"
#import "ForecastCell.h"

@interface LocationSearchTableViewController ()
<
DarkSkyBatchAPIProtocol
>
{
    ListMode listMode;
    APIController *apiController;
}

@end

@implementation LocationSearchTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchResults = [[NSMutableArray alloc] init];
    listMode = Saved;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    ForecastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    
    if ([self.searchResults count] > 0)
    {
//        BOOL current = NO;
        
        cell.weekdayLabel.textColor = [ViewManager setColorBasedOnTimeOfDay];
        cell.temperatureLabel.textColor = [ViewManager setColorBasedOnTimeOfDay];
        
        cell.weekdayLabel.text = @"";
        cell.temperatureLabel.text = @"";
        cell.weatherImageView.image = nil;
        
        Location *location = self.searchResults[indexPath.row];
        NSString *locationStr;
        

        
        if (listMode == Search)
        {
            locationStr = [NSString stringWithFormat:@"%@,%@", location.city, location.state];
            if (location.country)
            {
                locationStr = [NSString stringWithFormat:@"%@,%@,%@", location.city, location.state, location.country];
            }
            
            cell.weekdayLabel.text = locationStr;
        }
        else if (listMode == Saved)
        {
            locationStr = [NSString stringWithFormat:@"%@,%@", location.city, location.state];
        }
        
        
        if ([self location:self.currentLocation isEqualToLocation:location])
        {
            //            current = YES;
            cell.temperatureLabel.text = @"Current";
            cell.temperatureLabel.textColor = [UIColor lightGrayColor];
        }
        else if (location.weather)
        {
            cell.temperatureLabel.text = [NSString stringWithFormat:@"%@°", location.weather.temperature];
            cell.weatherImageView.image = [UIImage imageNamed:location.weather.icon];
            cell.weatherImageView.tintColor = [ViewManager setColorBasedOnTimeOfDay];
        }
        
        cell.weekdayLabel.text = locationStr;
        
    }
    
    return cell;
}

- (void)getWeatherForSavedLocations
{
    if (listMode == Saved)
    {
        apiController = [[APIController alloc] initWithDarkSkyBatchDelegate:self];
        [apiController searchForWeatherWithArray:self.searchResults];
    }
}

- (void)darkSkySearchDidComplete:(NSDictionary *)results locationDescription:(NSString *)description
{
    if (listMode == Saved)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (Location *location in self.searchResults)
            {
                NSString *locationDescription = [NSString stringWithFormat:@"%@,%@", location.city, location.state];
                //            NSString *locationDescription = [NSString stringWithFormat:@"%@, %@", location.lat, location.lng];
                //            NSString *savedLocationDescription = [NSString stringWithFormat:@"%lu", (unsigned long)[location hash]];
                if ([locationDescription isEqualToString:description])
                {
                    location.weather = [[Weather alloc] initWithResults:results];
                }
            }
            
            [self.tableView reloadData];
        });
    }
}

- (BOOL)location:(Location *)location isEqualToLocation:(Location *)otherLocation
{
    if (
        [location.city isEqualToString:otherLocation.city]
        && [location.state isEqualToString:otherLocation.state]
        )
    {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Location *selectedLocation = self.searchResults[indexPath.row];
    
    if (listMode == Search)
    {
        NSString *selectedResult = [NSString stringWithFormat:@"%@,%@,%@",
                                    selectedLocation.city, selectedLocation.state, selectedLocation.country];
        
        [self.delegate locationWasChosenFromResults:selectedResult];
    }
    else if (listMode == Saved)
    {
        [self.delegate locationWasChosenFromResults:selectedLocation];
    }
}

- (void)showResults:(NSArray *)results
{
//    NSLog(@"showResults");
    [self.searchResults addObjectsFromArray:results];
    
    if (listMode == Saved)
    {
        for (Location *location in results)
        {
            if ([location.city isEqualToString:self.currentLocation.city]
                && [location.state isEqualToString:self.currentLocation.state])
            {
                [self.searchResults removeObject:location];
            }
        }
        
        [self.searchResults insertObject:self.currentLocation atIndex:0];
        
        
        [self trimDuplicateLocations:self.searchResults];
        
        [self getWeatherForSavedLocations];
    }
    
    [self.tableView reloadData];
    
    [self.settingsViewController setContainerViewHeight:self.searchResults];
}

- (void)removeResults
{
    [self.searchResults removeAllObjects];
    [self.tableView reloadData];
}

- (void)listModeChanged:(NSInteger)selectedSegmentIndex
{
    [self.searchResults removeAllObjects];
    
    if (selectedSegmentIndex == 0)
    {
        listMode = Saved;
        [self getWeatherForSavedLocations];
//        [self.searchResults addObject:currentLocation];
    }
    else
    {
        listMode = Search;
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)trimDuplicateLocations:(NSArray *)locations
{
    NSMutableArray *trimmedLocations = [NSMutableArray array];
    
    NSMutableSet *citiesBuffer = [NSMutableSet set];
    NSMutableSet *statesBuffer = [NSMutableSet set];
    
    for (Location *location in locations)
    {
        if (
            ![citiesBuffer containsObject:location.city]
            && ![statesBuffer containsObject:location.state]
            ) {
            
            [citiesBuffer addObject:location.city];
            [statesBuffer addObject:location.state];
            
            [trimmedLocations addObject:location];
        }
    }

    NSLog(@"\ntrimmed locations: %@", trimmedLocations);
    return trimmedLocations;
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

//
//  LocationSearchTableViewController.m
//  Weather
//
//  Created by david on 2/18/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "LocationSearchTableViewController.h"
#import "ViewManager.h"

@interface LocationSearchTableViewController ()
{
    ListMode listMode;
}

@end

@implementation LocationSearchTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchResults = [[NSMutableArray alloc] init];
    listMode = Saved;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    
    if ([self.searchResults count] > 0)
    {
        cell.detailTextLabel.text = @"";
        
        Location *location = self.searchResults[indexPath.row];
        
        if (listMode == Search)
        {
            NSString *locationStr = [NSString stringWithFormat:@"%@,%@", location.city, location.state];
            if (location.country)
            {
                locationStr = [NSString stringWithFormat:@"%@,%@,%@", location.city, location.state, location.country];
            }
            
            cell.textLabel.text = locationStr;
        }
        else if (listMode == Saved)
        {
            NSString *locationStr = [NSString stringWithFormat:@"%@,%@", location.city, location.state];
            cell.textLabel.text = locationStr;
        }
        
        
        
        if (
            [location.city isEqualToString:self.currentLocation.city]
            && [location.state isEqualToString:self.currentLocation.state]
            )
        {
            cell.detailTextLabel.text = @"Current";
        }
        
        cell.textLabel.textColor = [ViewManager setColorBasedOnTimeOfDay];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (listMode == Search)
    {
        NSString *selectedResult = self.searchResults[indexPath.row];
        
        [self.delegate locationWasChosenFromResults:selectedResult];
    }
    else if (listMode == Saved)
    {
        Location *selectedLocation = self.searchResults[indexPath.row];
        
        [self.delegate locationWasChosenFromResults:selectedLocation];
    }
}

- (void)showResults:(NSArray *)results
{
//    NSLog(@"showResults");
    [self.searchResults addObjectsFromArray:results];
    [self.tableView reloadData];
    
    [self.settingsViewController setContainerViewHeight:results];
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
        
//        [self.searchResults addObject:currentLocation];
    }
    else
    {
        listMode = Search;
    }
    
    [self.tableView reloadData];
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

//
//  SettingsViewController.m
//  Weather
//
//  Created by david on 2/10/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewManager.h"
#import "LocationSearchTableViewController.h"
#import "APIController.h"

@interface SettingsViewController ()
{
    LocationSearchTableViewController *locationSearchTableViewController;
    APIController *apiController;
}

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    locationSearchTableViewController = [self.childViewControllers firstObject];
    apiController = [[APIController alloc] initWithGooglePlacesDelegate:locationSearchTableViewController];
    
    [ViewManager setBackgroundGradientToView:self.view];
    UITextField *searchField = (UITextField *)[self.searchBar valueForKey:@"_searchField"];
    [searchField setTextColor:[UIColor whiteColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)backButtonWasTapped:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
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

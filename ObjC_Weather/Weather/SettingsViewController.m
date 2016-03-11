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
#import "AnimationManager.h"

@interface SettingsViewController ()
<
UITextFieldDelegate,
AnimationDidCompleteProtocol,
LocationStringWasChosenProtocol,
GoogleMapsAPIProtocol,
LoadedLocationProtocol
>
{
    LocationSearchTableViewController *locationSearchTableViewController;
    APIController *apiController;
    AnimationManager *animator;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIView *containerContainerView;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    
    locationSearchTableViewController = [self.childViewControllers firstObject];
    locationSearchTableViewController.delegate = self;
    locationSearchTableViewController.settingsViewController = self;
    
    [ViewManager setBackgroundGradientToView:self.view];
    
    [ViewManager setViewCornerRadius:self.containerContainerView cornerRadius:4];
    
    [self setSearchBarTextColor:[UIColor whiteColor]];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    [self segmentedControlValueChanged:self.segmentedControl];
    
//    [self showSavedLocations];
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.delegate locationWasChosen:self.currentLocation];
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
    [self startSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

}

- (void)startSearch
{
    if (![self.searchBar.text isEqualToString:@""])
    {
        [self.searchBar setUserInteractionEnabled:NO];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        apiController = [[APIController alloc] initWithGooglePlacesDelegate:self];
        [apiController searchGooglePlacesFor:self.searchBar.text];
//        NSLog(@"%@", self.searchBar.text);
    }
}

- (void)googlePlacesSearchDidComplete:(NSArray *)results
{
    NSLog(@"googlePlacesSearchDidComplete");
    
    [self.searchBar setUserInteractionEnabled:YES];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [locationSearchTableViewController removeResults];
    
    if ([results firstObject])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *locations = [Location locationsFromGooglePlacesResults:results];
            [locationSearchTableViewController showResults:locations];
            
            
            
//            NSMutableArray *descriptions = [[NSMutableArray alloc] init];
//            
//            for (NSDictionary *prediction in results)
//            {
//                NSString *description = (NSString *)prediction[@"description"];
//                [descriptions addObject:description];
//            }
//            
//            [locationSearchTableViewController showResults:descriptions];
            
            //
            
//            [self setContainerViewHeight:results];
        });
    }
}

- (void)setContainerViewHeight:(NSArray *)results
{    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        double newHeight = [results count] * 44.0;
        
        if (newHeight > (self.view.frame.size.height - 88)) {
            newHeight = self.view.frame.size.height - 88;
        }
        
        animator = [[AnimationManager alloc] initWithDelegate:self];
        [animator
         animateTransform:self.containerContainerView
         width:self.containerContainerView.frame.size.width
         height:newHeight
         duration:0.25];
    });
}

- (void)animationDidComplete:(UIView *)view identifier:(AnimationIdentifier)identifier
{
    //
}

- (void)locationWasChosenFromResults:(id)location
{
    if ([location isKindOfClass:[NSString class]])
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        apiController = [[APIController alloc] initWithGoogleMapsDelegate:self];
        [apiController searchGoogleMapsFor:location];
    }
    else if ([location isKindOfClass:[Location class]])
    {
        self.currentLocation = location;
        [self.delegate dismissSettings];
    }
}

- (void)googleMapsSearchDidComplete:(Location *)location
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.currentLocation = location;
    [self.delegate dismissSettings];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text)
    {
        return true;
    }
    return false;
}

#pragma mark - Segmented Control

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
    [locationSearchTableViewController listModeChanged:sender.selectedSegmentIndex];
    
    if (sender.selectedSegmentIndex == 0)
    {
        self.searchBar.placeholder = @"";
        [self showSavedLocations];
    }
    else
    {
        self.searchBar.placeholder = @"Enter a city";
        [self startLocationSearch];
    }
}

- (void)showSavedLocations
{
    [self.searchBar resignFirstResponder];
    self.searchBar.userInteractionEnabled = NO;
    [self setSearchBarTextColor:[UIColor lightGrayColor]];
    
    locationSearchTableViewController.currentLocation = self.currentLocation;
    
    self.savedDataManager.delegate = self;
    [self.savedDataManager loadLocations];
}

- (void)startLocationSearch
{
    self.searchBar.userInteractionEnabled = YES;
    [self.searchBar becomeFirstResponder];
    [self setSearchBarTextColor:[UIColor whiteColor]];
    
    [self startSearch];
}

- (void)locationsWereLoaded:(Location *)currentLocation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [locationSearchTableViewController removeResults];
        [locationSearchTableViewController showResults:self.savedDataManager.savedLocations];
        
        NSLog(@"saved locations count: %lu", (unsigned long)[self.savedDataManager.savedLocations count]);
        
//        [self setContainerViewHeight:self.savedDataManager.savedLocations];
    });
}

#pragma mark - Buttons

- (IBAction)buttonTouchDown:(UIButton *)sender
{
    [animator animateTransform:sender widthScale:0.9 heightScale:0.9 duration:0.25];
}

- (IBAction)buttonTouchUpOutside:(UIButton *)sender
{
    [animator animateTransform:sender widthScale:1 heightScale:1 duration:0.15];
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [animator animateTransform:sender widthScale:1 heightScale:1 duration:0.15];
}

- (void)setSearchBarTextColor:(UIColor *)color
{
    UITextField *searchField = (UITextField *)[self.searchBar valueForKey:@"_searchField"];
    [searchField setTextColor:color];

//    self.searchBar.tintColor = [UIColor whiteColor];
    
    self.searchBar.tintColor = color;
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

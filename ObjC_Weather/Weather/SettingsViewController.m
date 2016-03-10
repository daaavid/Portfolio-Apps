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
GoogleMapsAPIProtocol
>
{
    LocationSearchTableViewController *locationSearchTableViewController;
    APIController *apiController;
    AnimationManager *animator;
}

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
    
    [ViewManager setBackgroundGradientToView:self.view];
    
    [ViewManager setViewCornerRadius:self.containerContainerView cornerRadius:4];
    
    animator = [[AnimationManager alloc] initWithDelegate:self];
    
    UITextField *searchField = (UITextField *)[self.searchBar valueForKey:@"_searchField"];
    [searchField setTextColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [animator animateTransform:self.containerContainerView width:self.containerContainerView.frame.size.width height:44.0 duration:0.25];
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (searchBar.text)
    {
        apiController = [[APIController alloc] initWithGooglePlacesDelegate:self];
        [apiController searchGooglePlacesFor:searchBar.text];
        NSLog(@"%@", searchBar.text);
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

}

- (void)googlePlacesSearchDidComplete:(NSArray *)results
{
    NSLog(@"googlePlacesSearchDidComplete");
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [locationSearchTableViewController removeResults];
    
    if ([results firstObject])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *descriptions = [[NSMutableArray alloc] init];
            
            for (NSDictionary *prediction in results)
            {
                NSString *description = (NSString *)prediction[@"description"];
                [descriptions addObject:description];
                
            }
            
            [locationSearchTableViewController showResults:descriptions];
            
            //
            
            [self setContainerViewHeight:results];
        });
    }
}

- (void)setContainerViewHeight:(NSArray *)results
{
    double newHeight = [results count] * 44.0;
    
    if (newHeight > (self.view.frame.size.height - 88)) {
        newHeight = self.view.frame.size.height - 88;
    }
    
    [animator animateTransform:self.containerContainerView width:self.containerContainerView.frame.size.width height:newHeight duration:0.25];
}

- (void)animationDidComplete:(UIView *)view identifier:(AnimationIdentifier)identifier
{
    //
}

- (void)locationStringWasChosen:(NSString *)location
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    apiController = [[APIController alloc] initWithGoogleMapsDelegate:self];
    [apiController searchGoogleMapsFor:location];
}

- (void)googleMapsSearchDidComplete:(Location *)location
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self.delegate locationWasChosen:location];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text)
    {
        return true;
    }
    return false;
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

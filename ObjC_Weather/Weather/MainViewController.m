//
//  MainViewController.m
//  Forecaster
//
//  Created by david on 1/21/16.
//  Copyright © 2016 david. All rights reserved.
//

/*
 
 //TODO:
 - activity spinner on containerBGView
 - soft shadows on mainInfoView labels
 - day each time forecast eg 8am 10am 12pm weather etc
 - weekly forecast in embedded tableview
 - weekly forecast as array of weather objects
 - everything else
 
*/

#import "MainViewController.h"
#import "SettingsViewController.h"
@import QuartzCore;

@interface MainViewController ()
<
UIPopoverPresentationControllerDelegate,
AnimationDidCompleteProtocol,
DarkSkyAPIProtocol,
LocationWasChosenProtocol,
LoadedLocationProtocol
>
{
    AnimationManager *animator;
    NSArray *overlayViews;
    NSArray *mainInfoViewLabels;
    
//    Weather *weather;
    
    CGRect originalWeatherFrame;
    BOOL transformed;
    BOOL refresh;
}

#pragma mark - views

//weekly forecast bottom container
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *containerBGView;

//star/weather overlays
@property (weak, nonatomic) IBOutlet UIView *overlayViewLeft;
@property (weak, nonatomic) IBOutlet UIView *overlayViewRight;

@property (weak, nonatomic) IBOutlet UIView *cloudOverlayViewLeft;
@property (weak, nonatomic) IBOutlet UIView *cloudOverlayViewRight;

@property (weak, nonatomic) IBOutlet UIView *starOverlayViewLeft;
@property (weak, nonatomic) IBOutlet UIView *starOverlayViewRight;

//main info view
@property (weak, nonatomic) IBOutlet UIView *mainInfoView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *degreeSymbolLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *quickWeatherLabel;
@property (nonatomic, weak) IBOutlet UIImageView *weatherImgView;

//button(s)
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

//other
@property (nonatomic, strong) APIController *apiController;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"viewDidLoad");
    
    if (!transformed)
    {
        originalWeatherFrame = self.mainInfoView.frame;
        [self performInitialSetup];
        transformed = YES;
    }
    
    [self managedSavedData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self performViewSetup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self refreshFavoriteButton];
    
    if (refresh)
    {
        _apiController = [[APIController alloc] initWithDarkSkyDelegate:self];
        [self.apiController searchForWeather:self.location];
    }
    refresh = NO;
    
    self.mainInfoView.frame = originalWeatherFrame;
    
    [self refreshFavorites];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowSettingsSegue"])
    {
        SettingsViewController *settingsViewController = (SettingsViewController *)[segue destinationViewController];
        settingsViewController.delegate = self;
        settingsViewController.currentLocation = self.location;
        settingsViewController.savedDataManager = self.savedDataManager;
        
//        NSLog(@"%@", self.savedDataManager.savedLocations);
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

#pragma mark - View Setup

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)performInitialSetup
{
    animator = [[AnimationManager alloc] initWithDelegate:self];
    
    [self.temperatureLabel setText:@""];
    [self.locationLabel setText:@""];
    [self.quickWeatherLabel setText:@""];
    
    overlayViews = @[
         self.overlayViewLeft,
         self.overlayViewRight,
         self.cloudOverlayViewLeft,
         self.cloudOverlayViewRight,
         self.starOverlayViewLeft,
         self.starOverlayViewRight,
         self.mainInfoView
         ];
    
    for (UIView *overlayView in overlayViews)
    {
        [overlayView setAlpha:0];
    }
    
    [ViewManager setLabelShadow:self.temperatureLabel];
    [ViewManager setLabelShadow:self.degreeSymbolLabel];
    [ViewManager setLabelShadow:self.quickWeatherLabel];
    [ViewManager setLabelShadow:self.locationLabel];
    
    [ViewManager setViewShadow:self.weatherImgView];
    
    [self.containerView setAlpha:0];
    [self.containerBGView setAlpha:0];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)performViewSetup
{
//    NSLog(@"performViewSetup");
    
    [self.containerView setAlpha:0];
    
    for (UIView *overlayView in overlayViews)
    {
        [overlayView setAlpha:0];
    }
    
    if ([TimeOfDay DayOrNight] == Day)
    {
        //clouds
        [self.cloudOverlayViewRight setAlpha:1];
        [self.cloudOverlayViewLeft setAlpha:1];
    }
    else
    {
        // stars
        [self.starOverlayViewRight setAlpha:1];
        [self.starOverlayViewLeft setAlpha:1];
        
        [ViewManager flipViews:@[self.starOverlayViewRight, self.starOverlayViewLeft] random:YES];
    }
    
    [ViewManager setBackgroundGradientToView:self.view];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });
    

    
//    NSLog(@"%f", left.frame.origin.x);
    
    [self setInitialBGViewProperties];
}

- (void)setInitialBGViewProperties
{
    UIView *bgView = self.containerBGView;
    [ViewManager setViewCornerRadius:bgView cornerRadius:bgView.frame.size.width / 2];
    [bgView setTransform:CGAffineTransformMakeScale(0.15, 0.15)];
    [bgView setAlpha:0];
}

- (void)setMainInfoViewWeatherLabels
{
    if (self.location.weather)
    {
        [animator slideToOrigin:self.mainInfoView fromPoint:self.mainInfoView.frame.origin.y + 30 identifier:SlideVertically];
        [self.temperatureLabel setText:[NSString stringWithFormat:@"%@", self.location.weather.temperature]];
        [self.locationLabel setText: [NSString stringWithFormat:@"%@,%@", self.location.city, self.location.state]];
        [self.quickWeatherLabel setText:[NSString stringWithFormat:@"%@", self.location.weather.summary]];
        
        NSString *imageName = [NSString stringWithFormat:@"%@-big", self.location.weather.icon];
        
        [self.weatherImgView setImage:[UIImage imageNamed:imageName]];
        [self.weatherImgView setTintColor:[UIColor whiteColor]];
    }
}

- (void)setWeeklyForecastTableView
{
    WeatherTableTableViewController *weatherTableVC =
        (WeatherTableTableViewController *)self.childViewControllers[0];
    
    if (self.location.weather && weatherTableVC)
    {
        weatherTableVC.weather = self.location.weather;
        [weatherTableVC.tableView flashScrollIndicators];
        [weatherTableVC.tableView reloadData];
    }
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
    
    if ([sender isEqual:self.favoriteButton])
    {
        if (!self.location.favorite)
        {
            self.location.favorite = YES;
        }
        else
        {
            self.location.favorite = NO;
        }

        [self.savedDataManager addOrRemoveLocation:self.location];
        [self refreshFavorites];
    }
}

- (void)refreshFavorites
{
    UIImage *favoriteImg;
    
    [self.savedDataManager saveLocations:self.location];
    
    if ([self.savedDataManager containsLocation:self.location])
    {
        favoriteImg = [UIImage imageNamed:@"favorite-fill"];
    }
    
//    if ([self.savedDataManager.savedLocations containsObject:self.location])
//    {
//
//    }
//    if (self.location.favorite)
//    {
//        favoriteImg = [UIImage imageNamed:@"favorite-fill"];
//    }
    else
    {
        favoriteImg = [UIImage imageNamed:@"favorite"];
    }
    
    [self.favoriteButton setImage:favoriteImg forState:UIControlStateNormal];
}

#pragma mark - Animation Completion Delegate

- (void)animationDidComplete:(UIView *)view identifier:(AnimationIdentifier)identifier;
{
    if (view == self.mainInfoView && identifier == SlideVertically)
    {
        [animator slideToOrigin:self.containerBGView fromPoint:self.containerBGView.frame.origin.y - 120 identifier:SlideVertically];
    }
    else if (view == self.containerBGView && identifier == SlideVertically)
    {
        //initial drop animation upon view load
        
        [animator animateCornerRadius:view from:view.layer.cornerRadius to:4 duration:0.25];   
        [animator animateTransform:view widthScale:1.45 heightScale:1 duration:0.25];
        
        UIView *left = self.overlayViewLeft;
        UIView *right = self.overlayViewRight;
        [animator fadeView:left identifier:FadeIn];
        [animator fadeView:right identifier:FadeIn];
        [animator slideToOrigin:left fromPoint:left.frame.origin.x - 60 identifier:SlideHorizontally];
        [animator slideToOrigin:right fromPoint:right.frame.origin.x + 60 identifier:SlideHorizontally];
    }
    else if (view == self.containerBGView && identifier == Transform)
    {
        //above animation completed, ready to view tableview data
        
        [animator fadeView:self.containerView identifier:FadeIn];
    }
}

#pragma mark - API Controller Completion Delegates

- (void)darkSkySearchDidComplete:(NSDictionary *)results location:(Location *)location
{
    self.location.weather = [[Weather alloc] initWithResults:results];
    [self setMainInfoViewWeatherLabels];
    [self setWeeklyForecastTableView];
    
    [self refreshFavorites];
}

- (void)locationWasChosen:(Location *)location
{
    self.location = location;
    refresh = YES;
}

- (void)dismissSettings
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)managedSavedData
{
    if (!self.savedDataManager)
    {
        _savedDataManager = [[SavedDataManager alloc] initWithDelegate:self];
    }
}

- (void)locationsWereLoaded:(Location *)currentLocation
{
    self.location = currentLocation;
    self.apiController = [[APIController alloc] initWithDarkSkyDelegate:self];
    [self.apiController searchForWeather:self.location];
    
    [self refreshFavorites];
}

@end

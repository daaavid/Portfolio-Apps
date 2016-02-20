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
@import QuartzCore;

@interface MainViewController ()
<UIPopoverPresentationControllerDelegate, AnimationDidCompleteProtocol, DarkSkyAPIProtocol>
{
    AnimationManager *animator;
    NSArray *overlayViews;
    NSArray *mainInfoViewLabels;
    
    Weather *weather;
    
    
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

#pragma mark - other properties

@property (nonatomic, strong) APIController *apiController;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    
    
    [self performInitialSetup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performViewSetup];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowLocationPopover"])
    {
//        HistoryTableViewController *historyVC = segue.destinationViewController;
//        UIPopoverPresentationController *popover = historyVC.popoverPresentationController;
//        popover.delegate = self;
//        historyVC.delegate = self;
//        
//        historyVC.history = searchHistory;
//        
//        historyVC.modalPresentationStyle = UIModalPresentationPopover;
//        float contentSize = searchHistory.count * 44;
//        
//        historyVC.preferredContentSize = CGSizeMake(200, contentSize);
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
}

- (void)performViewSetup
{
    NSLog(@"performViewSetup");
    
    [self.containerView setAlpha:0];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
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
    
    UIView *left = self.overlayViewLeft;
    UIView *right = self.overlayViewRight;
    [animator fadeView:left identifier:FadeIn];
    [animator fadeView:right identifier:FadeIn];
    [animator slideToOrigin:left fromPoint:left.frame.origin.x - 60 identifier:SlideHorizontally];
    [animator slideToOrigin:right fromPoint:right.frame.origin.x + 60 identifier:SlideHorizontally];
    
    [self setInitialBGViewProperties];
    
    
    
    Location *location = [[Location alloc] init];
    location.lat = @"28.5409840";
    location.lng = @"-81.3777390";
    [self.apiController searchForWeather:location];
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
    if (weather)
    {
        [animator slideToOrigin:self.mainInfoView fromPoint:self.mainInfoView.frame.origin.y + 30 identifier:SlideVertically];
        [self.temperatureLabel setText:[NSString stringWithFormat:@"%@", weather.temperature]];
        [self.locationLabel setText: [NSString stringWithFormat:@"Orlando, FL"]];
        [self.quickWeatherLabel setText:[NSString stringWithFormat:@"%@", weather.summary]];
        
        NSString *imageName = [NSString stringWithFormat:@"%@-big", weather.icon];
        
        [self.weatherImgView setImage:[UIImage imageNamed:imageName]];
        [self.weatherImgView setTintColor:[UIColor whiteColor]];
    }
}

- (void)setWeeklyForecastTableView
{
    WeatherTableTableViewController *weatherTableVC =
        (WeatherTableTableViewController *)self.childViewControllers[0];
    
    if (weather && weatherTableVC)
    {
        weatherTableVC.weather = weather;
        [weatherTableVC.tableView flashScrollIndicators];
        [weatherTableVC.tableView reloadData];
    }
}

#pragma mark - Lazy instantiations

- (APIController *)apiController
{
    if (!_apiController)
    {
        _apiController = [[APIController alloc] initWithDarkSkyDelegate:self];
    }
    return _apiController;
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
    weather = [[Weather alloc] initWithResults:results];
    [self setMainInfoViewWeatherLabels];
    [self setWeeklyForecastTableView];
}

- (void)googleLocationSearchDidComplete:(NSArray *)results
{
    
}

- (void)googlePlacesSearchDidComplete:(NSArray *)results
{
    
}

@end

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
 - everything else
 
*/

#import "MainViewController.h"
@import QuartzCore;

@interface MainViewController ()
<UIPopoverPresentationControllerDelegate, AnimationDidCompleteProtocol, APIControllerProtocol>
{
    AnimationManager *animator;
    APIController *apiController;
    NSArray *overlayViews;
    
    Weather *weatherToday;
}

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
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *quickWeatherLabel;

@end



@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performInitialSetup];
//    [animator slideToOrigin:self.containerBGView fromPoint:200 identifier:SlideVertically];
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
    apiController = [[APIController alloc] initWithDelegate:self];
    Location *location = [[Location alloc] init];
    location.lat = @"28.5409840";
    location.lng = @"81.3777390";
    [apiController searchForWeather:location];
    
    [self.temperatureLabel setText:@""];
    [self.locationLabel setText:@""];
    [self.quickWeatherLabel setText:@""];
    
    overlayViews = @[
         self.overlayViewLeft,
         self.overlayViewRight,
         self.cloudOverlayViewLeft,
         self.cloudOverlayViewRight,
         self.starOverlayViewLeft,
         self.starOverlayViewRight
         ];
    
    for (UIView *overlayView in overlayViews)
    {
        [overlayView setAlpha:0];
    }
}

- (void)performViewSetup
{
    [self.containerView setAlpha:0];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    for (UIView *overlayView in overlayViews)
    {
        [overlayView setAlpha:0];
    }
    
    BOOL isDay = true;//[TimeOfDay DayOrNight] == Day;
    NSArray *colors;
    
    if (isDay)
    {
        //a day sky
        colors = @[
           (id)[[UIColor colorWithRed:0 green:0.02 blue:0.15 alpha:1] CGColor],
           (id)[[UIColor colorWithRed:0.01 green:0.49 blue:0.7 alpha:1] CGColor],
           (id)[[UIColor colorWithRed:0 green:0.64 blue:0.6 alpha:1] CGColor]
           ];
        
        //with clouds
        [self.cloudOverlayViewRight setAlpha:1];
        [self.cloudOverlayViewLeft setAlpha:1];
    }
    else if (!isDay)
    {
        //a night sky
        colors = @[
          (id)[[UIColor colorWithRed:0 green:0.04 blue:0.08 alpha:1] CGColor],
          (id)[[UIColor colorWithRed:0 green:0.1 blue:0.2 alpha:1] CGColor],
          (id)[[UIColor colorWithRed:0 green:0.17 blue:0.33 alpha:1] CGColor]
          ];
        
        //with stars
        [self.starOverlayViewRight setAlpha:1];
        [self.starOverlayViewLeft setAlpha:1];
    }
    
    [ViewManager setViewGradient:self.view colors:colors];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *left = self.overlayViewLeft;
        UIView *right = self.overlayViewRight;
        [animator fadeView:left identifier:FadeIn];
        [animator fadeView:right identifier:FadeIn];
        [animator slideToOrigin:left fromPoint:left.frame.origin.x - 60 identifier:SlideHorizontally];
        [animator slideToOrigin:right fromPoint:right.frame.origin.x + 60 identifier:SlideHorizontally];
    });
    
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
    if (weatherToday)
    {
        [animator slideToOrigin:self.mainInfoView fromPoint:self.mainInfoView.frame.origin.y + 30 identifier:SlideVertically];
        [self.temperatureLabel setText:[NSString stringWithFormat:@"%@", weatherToday.temperature]];
        [self.locationLabel setText: [NSString stringWithFormat:@"Orlando, FL"]];
        [self.quickWeatherLabel setText:[NSString stringWithFormat:@"%@", weatherToday.summary]];
    }
}

- (void)setWeeklyForecastTableView
{
    WeatherTableTableViewController *weatherTableVC =
        (WeatherTableTableViewController *)self.childViewControllers[0];
    
    if (weatherToday && weatherTableVC)
    {
        
    }
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
    weatherToday = [[Weather alloc] initWithResults:results];
    [self setMainInfoViewWeatherLabels];
}

- (void)googleLocationSearchDidComplete:(NSArray *)results
{
    
}

- (void)googlePlacesSearchDidComplete:(NSArray *)results
{
    
}

@end

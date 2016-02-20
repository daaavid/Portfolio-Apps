//
//  WeatherTableTableViewController.h
//  Forecaster
//
//  Created by david on 1/21/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIController.h"
#import "Location.h"
#import "Weather.h"
#import "ForecastCell.h"

@interface WeatherTableTableViewController : UITableViewController

@property (nonatomic) Weather *weather;

@end

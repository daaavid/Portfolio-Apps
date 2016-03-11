//
//  WeatherDetailPopoverTableViewController.h
//  Weather
//
//  Created by david on 3/11/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface WeatherDetailPopoverTableViewController : UITableViewController

@property (nonatomic, strong) Weather *weather;
@property (nonatomic, strong) UIColor *textColor;

@end

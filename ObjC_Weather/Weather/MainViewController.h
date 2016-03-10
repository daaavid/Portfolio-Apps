//
//  MainViewController.h
//  Forecaster
//
//  Created by david on 1/21/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationManager.h"
#import "ViewManager.h"
#import "TimeOfDay.h"
#import "APIController.h"
#import "WeatherTableTableViewController.h"
#import "SavedDataManager.h"

@interface MainViewController : UIViewController

@property (nonatomic, strong) SavedDataManager *savedDataManager;
@property (nonatomic, strong) Location *location;

@end

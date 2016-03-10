//
//  SettingsViewController.h
//  Weather
//
//  Created by david on 2/10/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIController.h"

@protocol LocationWasChosenProtocol
- (void)locationWasChosen:(Location *)location;
@end

@interface SettingsViewController : UIViewController <UISearchBarDelegate, GooglePlacesAPIProtocol>

@property (nonatomic) id <LocationWasChosenProtocol> delegate;
@property (nonatomic) Location *currentLocation;

@end

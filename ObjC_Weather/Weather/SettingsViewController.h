//
//  SettingsViewController.h
//  Weather
//
//  Created by david on 2/10/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIController.h"
#import "SavedDataManager.h"

@protocol LocationWasChosenProtocol
- (void)locationWasChosen:(Location *)location;
- (void)dismissSettings;
@end

@interface SettingsViewController : UIViewController <UISearchBarDelegate, GooglePlacesAPIProtocol>

@property (nonatomic) id <LocationWasChosenProtocol> delegate;
@property (nonatomic) Location *currentLocation;
@property (nonatomic) SavedDataManager *savedDataManager;

- (void)setContainerViewHeight:(NSArray *)results;

@end

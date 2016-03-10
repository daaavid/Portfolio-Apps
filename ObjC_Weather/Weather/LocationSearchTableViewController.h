//
//  LocationSearchTableViewController.h
//  Weather
//
//  Created by david on 2/18/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIController.h"
#import "SettingsViewController.h"

typedef enum {
    Saved,
    Search
}ListMode;

@protocol LocationStringWasChosenProtocol
- (void)locationWasChosenFromResults:(id)location;
@end

@interface LocationSearchTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic) id <LocationStringWasChosenProtocol> delegate;
@property (nonatomic) SettingsViewController *settingsViewController;
@property (nonatomic) Location *currentLocation;

- (void)listModeChanged:(NSInteger)selectedSegmentIndex;
- (void)showResults:(NSArray *)results;
- (void)removeResults;

@end

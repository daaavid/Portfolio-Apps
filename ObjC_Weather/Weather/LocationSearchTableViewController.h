//
//  LocationSearchTableViewController.h
//  Weather
//
//  Created by david on 2/18/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIController.h"

@protocol LocationStringWasChosenProtocol
- (void)locationStringWasChosen:(NSString *)location;
@end

@interface LocationSearchTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic) id <LocationStringWasChosenProtocol> delegate;

- (void)showResults:(NSArray *)results;
- (void)removeResults;

@end

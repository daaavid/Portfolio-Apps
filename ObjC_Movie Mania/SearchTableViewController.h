//
//  SearchTableViewController.h
//  Movie Mania
//
//  Created by david on 11/12/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@protocol SearchProtocol

- (void)searchResultsWereFound:(NSArray *)results;

@end

@protocol HistoryProtocol

- (void)historySearchResultWasChosen:(Movie *)movie;

@end

@interface SearchTableViewController : UITableViewController <HistoryProtocol, SearchProtocol>

- (void)saveHistory;
- (void)loadHistory;

@end

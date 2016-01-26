//
//  HistoryTableViewController.h
//  Movie Mania
//
//  Created by david on 11/14/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewController.h"

@interface HistoryTableViewController : UITableViewController
@property (nonatomic) id <HistoryProtocol> delegate;
@property (nonatomic) NSArray *history;

@end

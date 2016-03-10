//
//  SavedDataManager.h
//  Weather
//
//  Created by david on 3/10/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface SavedDataManager : NSObject
{
//    SavedDataManager *savedDataManager;
}

@property (nonatomic, strong) NSMutableArray *savedLocations;

- (void)saveLocations;
- (BOOL)loadLocations;

- (void)addOrRemoveLocation:(Location *)location;

@end

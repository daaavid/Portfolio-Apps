//
//  SavedDataManager.h
//  Weather
//
//  Created by david on 3/10/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@protocol LoadedLocationProtocol
- (void)locationsWereLoaded:(Location *)currentLocation;
@end

@interface SavedDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *savedLocations;
@property (nonatomic, strong) Location *currentLocation;
@property (nonatomic) id <LoadedLocationProtocol> delegate;

- (instancetype)initWithDelegate:(id <LoadedLocationProtocol>)delegate;

- (void)saveLocations:(Location *)currentLocation;
- (void)loadLocations;
- (void)addOrRemoveLocation:(Location *)location;

@end

//
//  SavedDataManager.m
//  Weather
//
//  Created by david on 3/10/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "SavedDataManager.h"

@implementation SavedDataManager

- (instancetype)initWithDelegate:(id <LoadedLocationProtocol>)delegate;
{
    if (self = [super init])
    {
        _delegate = delegate;
        [self loadLocations];
    }
    return self;
}

- (void)saveLocations:(Location *)currentLocation
{
    NSData *savedLocationsData = [NSKeyedArchiver archivedDataWithRootObject:self.savedLocations];
    [[NSUserDefaults standardUserDefaults] setObject:savedLocationsData forKey:@"kSavedLocationsData"];
    
    NSData *savedCurrentLocationData = [NSKeyedArchiver archivedDataWithRootObject:currentLocation];
    [[NSUserDefaults standardUserDefaults] setObject:savedCurrentLocationData forKey:@"kSavedCurrentLocationData"];
}

- (void)loadLocations
{
    NSData *loadedLocationsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSavedLocationsData"];
    NSArray *loadedLocationsArray = [NSKeyedUnarchiver unarchiveObjectWithData:loadedLocationsData];
    
    if (loadedLocationsArray)
    {
        [self.savedLocations removeAllObjects];
        [self.savedLocations addObjectsFromArray:loadedLocationsArray];
    }
//    else
//    {
//        self.savedLocations = [NSMutableArray array];
//    }
    
    NSData *loadedCurrentLocationData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSavedCurrentLocationData"];
    Location *loadedCurrentLocation = [NSKeyedUnarchiver unarchiveObjectWithData:loadedCurrentLocationData];
    
    if (loadedCurrentLocation)
    {
        self.currentLocation = loadedCurrentLocation;
    }
    else
    {
        self.currentLocation = [[Location alloc] initSampleLocation];
    }
    
    self.savedLocations = [self trimDuplicateLocations];
    
    NSLog(@"loaded");
    
    [self.delegate locationsWereLoaded:self.currentLocation];
}

- (void)addOrRemoveLocation:(Location *)location
{
    if (location.favorite && ![self.savedLocations containsObject:location])
    {
        [self.savedLocations addObject:location];
    }
    else
    {
        NSMutableArray *trimmedLocations = [NSMutableArray array];
        
        for (Location *savedLocation in self.savedLocations)
        {
            if (
                ![location isEqual:savedLocation]
                || (
                    ![location.state isEqualToString:savedLocation.state]
                    && ![location.city isEqualToString:savedLocation.city]
                    )
                )
            {
                [trimmedLocations addObject:location];
            }
        }
        
        self.savedLocations = trimmedLocations;
    }
//    else if ([self.savedLocations containsObject:location])
//    {
//        [self.savedLocations removeObject:location];
//    }
//    else
//    {
//        
//        
//        NSMutableArray *trimmedLocations = [NSMutableArray array];
//        
//        for (Location *savedLocation in self.savedLocations)
//        {
//            if (![savedLocation.state isEqualToString:location.state] &&
//                ![savedLocation.city isEqualToString:location.state])
//            {
//                [trimmedLocations addObject:location];
//            }
//        }
//        
//        self.savedLocations = trimmedLocations;
//    }
    
    [self saveLocations:self.currentLocation];
    
    NSLog(@"\n%@", self.savedLocations);
}

- (NSMutableArray *)savedLocations
{
    if (!_savedLocations)
    {
        _savedLocations = [NSMutableArray array];
    }
    
    return _savedLocations;
}

- (NSMutableArray *)trimDuplicateLocations
{
    NSMutableArray *trimmedLocations = [NSMutableArray array];
    
    NSMutableSet *citiesBuffer = [NSMutableSet set];
    NSMutableSet *statesBuffer = [NSMutableSet set];
//    
//    
//    
//    NSString *cityBuffer = [NSString string];
//    NSString *stateBuffer = [NSString string];
    
    
    for (Location *location in self.savedLocations)
    {
        if (
            ![citiesBuffer containsObject:location.city]
            && ![statesBuffer containsObject:location.state]
            ) {
            
            [citiesBuffer addObject:location.city];
            [statesBuffer addObject:location.state];
            
            [trimmedLocations addObject:location];
        }
    }
//    
//    
//    for (Location *savedLocation in self.savedLocations)
//    {
//        
//        
//        
//        if (![savedLocation.state isEqualToString:stateBuffer] &&
//            ![savedLocation.city isEqualToString:cityBuffer])
//        {
//            NSLog(@"%@", savedLocation);
//            
//            NSLog(@"\n sv lc city: %@ \n sv lc state: %@", savedLocation.city, savedLocation.state);
//            
//            
//            [trimmedLocations addObject:savedLocation];
//            
//            cityBuffer = savedLocation.city;
//            stateBuffer = savedLocation.state;
//            
//            NSLog(@"\n bf lc city: %@ \n bf lc state: %@", cityBuffer, stateBuffer);
//        }
//    }
    
    NSLog(@"\ntrimmed locations: %@", trimmedLocations);
    return trimmedLocations;
}

- (BOOL)containsLocation:(Location *)location
{
    for (Location *savedLocation in self.savedLocations)
    {
        if ([savedLocation.city isEqualToString:location.city] && [savedLocation.state isEqualToString:location.state])
        {
            return YES;
        }
    }
    
    return NO;
}

@end

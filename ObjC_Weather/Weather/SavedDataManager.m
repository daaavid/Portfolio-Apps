//
//  SavedDataManager.m
//  Weather
//
//  Created by david on 3/10/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "SavedDataManager.h"

@implementation SavedDataManager

- (instancetype)init
{
    if (self = [super init])
    {
        [self loadLocations];
    }
    return self;
}

- (void)saveLocations
{
    NSData *savedLocationsData = [NSKeyedArchiver archivedDataWithRootObject:self.savedLocations];
    [[NSUserDefaults standardUserDefaults] setObject:savedLocationsData forKey:@"kSavedLocationsData"];
    
    NSData *savedCurrentLocationData = [NSKeyedArchiver archivedDataWithRootObject:self.savedLocations];
}

- (BOOL)loadLocations
{
    NSData *loadedLocationsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSavedLocationsData"];
    NSArray *loadedLocationsArray = [NSKeyedUnarchiver unarchiveObjectWithData:loadedLocationsData];
    
    if (loadedLocationsArray)
    {
        [self.savedLocations removeAllObjects];
        [self.savedLocations addObjectsFromArray:loadedLocationsArray];
        return YES;
    }
    else
    {
        self.savedLocations = [NSMutableArray array];
    }
    
    return NO;
}

- (void)addOrRemoveLocation:(Location *)location
{
    if (location.favorite && ![self.savedLocations containsObject:location])
    {
        [self.savedLocations addObject:location];
    }
//    else if ([self.savedLocations containsObject:location])
//    {
//        [self.savedLocations removeObject:location];
//    }
    else
    {
        NSMutableArray *trimmedLocations = [NSMutableArray array];
        
        for (Location *savedLocation in self.savedLocations)
        {
            if (![savedLocation.state isEqualToString:location.state] &&
                ![savedLocation.city isEqualToString:location.state])
            {
                [trimmedLocations addObject:location];
            }
        }
        
        self.savedLocations = trimmedLocations;
    }
    
    NSLog(@"%@", self.savedLocations);
}

@end

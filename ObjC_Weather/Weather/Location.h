//
//  Location.h
//  Forecaster
//
//  Created by david on 1/22/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

@interface Location : NSObject <NSCoding>

@property (nonatomic) NSString *lat;
@property (nonatomic) NSString *lng;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *country;
@property (nonatomic) Weather *weather;
@property (nonatomic) BOOL favorite;

- (instancetype)init:(NSString *)lat
                 lng:(NSString *)lng
                city:(NSString *)city
               state:(NSString *)state;

- (Location *)initSampleLocation;
+ (Location *)locationFromJSON:(NSArray *)results;
+ (NSArray *)locationsFromGooglePlacesResults:(NSArray *)results;

@end

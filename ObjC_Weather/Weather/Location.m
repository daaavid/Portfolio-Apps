//
//  Location.m
//  Forecaster
//
//  Created by david on 1/22/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)init:(NSString *)lat
                 lng:(NSString *)lng
                city:(NSString *)city
               state:(NSString *)state;
{
    if (self = [super init])
    {
        _lat   = lat;
        _lng   = lng;
        _city  = city;
        _state = state;
        _favorite = NO;
    }
    return self;
}

- (Location *)initSampleLocation
{
    Location *location = [[Location alloc] init];
    location.favorite = NO;
    location.lat = @"28.5409840";
    location.lng = @"-81.3777390";
    location.city = @"Orlando";
    location.state = @" FL";
    
    return location;
}

- (Location *)initWithCity:(NSString *)city andState:(NSString *)state andCountry:(NSString *)country;
{
    Location *location = [[Location alloc] init];
    location.city = city;
    location.state = state;
    location.country = country;
    
    return location;
}

+ (Location *)locationFromJSON:(NSArray *)results
{
    NSString *lat   = [[NSString alloc] init];
    NSString *lng   = [[NSString alloc] init];
    NSString *city  = [[NSString alloc] init];
    NSString *state = [[NSString alloc] init];
    
    if ([results firstObject])
    {
        NSDictionary *result = (NSDictionary *)[results firstObject];
        //really missing conditional binding right now
        //come back to me, if let
        if (result)
        {
            NSString *formattedAddress = (NSString *)[result objectForKey:@"formatted_address"];
            if (formattedAddress)
            {
                NSArray *addressComponents =
                [formattedAddress componentsSeparatedByString:@","];
                
                city = addressComponents[0];
//                state = [addressComponentsForCity[1] componentsSeparatedByString:@" "][1];
                state = addressComponents[1];
            }
            
            NSDictionary *geometry = (NSDictionary *)[result objectForKey:@"geometry"];
            if (geometry)
            {
                NSDictionary *latLng = (NSDictionary *)[geometry objectForKey:@"location"];
                if (latLng)
                {
                    lat = [(NSNumber *)[latLng objectForKey:@"lat"] stringValue];
                    lng = [(NSNumber *)[latLng objectForKey:@"lng"] stringValue];
                }
            }
        }
    }
    
    return [[Location alloc] init:lat lng:lng city:city state:state];
}

+ (NSArray *)locationsFromGooglePlacesResults:(NSArray *)results
{
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    for (NSDictionary *prediction in results)
    {
        NSString *description = (NSString *)prediction[@"description"];
        NSArray *components = [description componentsSeparatedByString:@","];
        
        NSString *city = components[0];
        NSString *state = components[1];
        NSString *country;
        
        if ([components count] > 2)
        {
            country = components[2];
        }
        
        Location *location = [[Location alloc] initWithCity:city andState:state andCountry:country];
        
        [locations addObject:location];
    }
    
    return locations;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _lat = [aDecoder decodeObjectForKey:@"lat"];
        _lng = [aDecoder decodeObjectForKey:@"lng"];
        _city = [aDecoder decodeObjectForKey:@"city"];
        _state = [aDecoder decodeObjectForKey:@"state"];
//        _favorite = [aDecoder decodeObjectForKey:@"favorite"];
        _favorite = [aDecoder decodeBoolForKey:@"favorite"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_lat forKey:@"lat"];
    [aCoder encodeObject:_lng forKey:@"lng"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_state forKey:@"state"];
    [aCoder encodeBool:_favorite forKey:@"favorite"];
}

@end

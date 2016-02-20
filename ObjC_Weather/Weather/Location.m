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
    }
    return self;
}

- (Location *)locationFromJSON:(NSArray *)results;
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
                NSArray *addressComponentsForCity =
                [formattedAddress componentsSeparatedByString:@" "];
                
                city = addressComponentsForCity[0];
                state = [addressComponentsForCity[1] componentsSeparatedByString:@" "][1];
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

@end

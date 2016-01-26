//
//  Weather.m
//  Forecaster
//
//  Created by david on 1/22/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "Weather.h"

@implementation Weather

- (instancetype)init:(NSNumber *)temperature
apparentTemperature     :(NSNumber *)apparentTemperature
summary                 :(NSString *)summary
icon                    :(NSString *)icon
precipitationProbability:(NSNumber *)precipitationProbability
precipitationIntensity  :(NSNumber *)precipitationIntensity
         windSpeed  :(NSNumber *)windSpeed
          humidity  :(NSNumber *)humidity;
{
    if (self = [super init])
    {
        _temperature                = temperature;
        _apparentTemperature        = apparentTemperature;
        _summary                    = summary;
        _icon                       = icon;
        _precipitationProbability   = precipitationProbability;
        _precipitationIntensity     = precipitationIntensity;
        _windSpeed                  = windSpeed;
        _humidity                   = humidity;
    }
    return self;
}

- (Weather *)initWithResults:(NSDictionary *)results;
{
    Weather *weather = [[Weather alloc] init];
    
    NSDictionary *currently = (NSDictionary *)results[@"currently"];
    if (currently)
    {
        NSNumber *temperature            = [self formattedTemperature: (NSNumber *)currently[@"temperature"]];
        NSNumber *apparentTemprature    = [self formattedTemperature: (NSNumber *)currently[@"apparentTemperature"]];
        
        NSString *summary       = (NSString *)currently[@"summary"];
        NSString *icon          = (NSString *)currently[@"icon"];
        NSNumber *precipProb    = (NSNumber *)currently[@"precipProbability"];
        NSNumber *precipIntens  = (NSNumber *)currently[@"precipIntensity"];
        NSNumber *windSpeed     = (NSNumber *)currently[@"windSpeed"];
        NSNumber *humidity      = (NSNumber *)currently[@"dewPoint"];
        
        weather = [[Weather alloc]
                   init:temperature
                   apparentTemperature:apparentTemprature
                   summary:summary
                   icon:icon
                   precipitationProbability:precipProb
                   precipitationIntensity:precipIntens
                   windSpeed:windSpeed
                   humidity:humidity
                   ];
    }
    
    
    return weather;
}

- (NSNumber *)formattedTemperature:(NSNumber *)temperature;
{
    NSArray *fullTemperature = [[temperature stringValue] componentsSeparatedByString:@"."];
    double firstNumber = [fullTemperature[0] doubleValue];
    if ([fullTemperature[1] doubleValue] > 50)
    {
        firstNumber += 1;
    }
    
    return [NSNumber numberWithDouble:firstNumber];
}

@end

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
         windSpeed      :(NSNumber *)windSpeed
          humidity      :(NSNumber *)humidity;
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
        weather = [self initWithDictionary:currently];
    }
    
    NSDictionary *daily = (NSDictionary *)results[@"daily"];
    if (daily)
    {
        weather.weeklyForecast = [[NSMutableArray alloc] init];
        NSArray *data = (NSArray *)daily[@"data"];
        for (NSDictionary *forecast in data)
        {
            Weather *weekday = [[Weather alloc] initWithDictionary:forecast];
            [weather.weeklyForecast addObject:weekday];
        }
    }
    
    return weather;
}

- (Weather *)initWithDictionary:(NSDictionary *)dictionary
{
    Weather *weather = [[Weather alloc] init];
    
    NSNumber *temperature;
    NSNumber *apparentTemperature;
    
    if (dictionary[@"temperature"] && dictionary[@"apparentTemperature"])
    {
        temperature         = [self formattedTemperature: (NSNumber *)dictionary[@"temperature"]];
        apparentTemperature = [self formattedTemperature: (NSNumber *)dictionary[@"apparentTemperature"]];
    }
    else
    {
        /*
         the daiy forecast dictionaries don't have "temperature" and "apparentTemperature" keys,
         so if that above if statement fails,
         that means we're currently parsing the weekly forecast (daily) dictionaries instead of todays (currently) dictionary
         */
        
        NSNumber *temperatureMin            = (NSNumber *)dictionary[@"temperatureMin"];
        NSNumber *temperatureMax            = (NSNumber *)dictionary[@"temperatureMax"];
        
        temperature                         = [self getAverageTemperatureFromMin:temperatureMin max:temperatureMax];
        
        NSNumber *apparentTemperatureMin    = (NSNumber *)dictionary[@"apparentTemperatureMin"];
        NSNumber *apparentTemperatureMax    = (NSNumber *)dictionary[@"apparentTemperatureMax"];
        
        apparentTemperature                 = [self getAverageTemperatureFromMin:apparentTemperatureMin max:apparentTemperatureMax];
    }
    
    NSString *summary       = (NSString *)dictionary[@"summary"];
    NSString *icon          = (NSString *)dictionary[@"icon"];
    NSNumber *precipProb    = (NSNumber *)dictionary[@"precipProbability"];
    NSNumber *precipIntens  = (NSNumber *)dictionary[@"precipIntensity"];
    NSNumber *windSpeed     = (NSNumber *)dictionary[@"windSpeed"];
    NSNumber *humidity      = (NSNumber *)dictionary[@"dewPoint"];
    
    weather = [[Weather alloc]
               init                     :temperature
               apparentTemperature      :apparentTemperature
               summary                  :summary
               icon                     :icon
               precipitationProbability :precipProb
               precipitationIntensity   :precipIntens
               windSpeed                :windSpeed
               humidity                 :humidity
               ];
    
    return weather;
}

- (NSNumber *)getAverageTemperatureFromMin:(NSNumber *)temperatureMin max:(NSNumber *)temperatureMax
{
    return [self formattedTemperature:
                             [NSNumber numberWithDouble:
                              (([temperatureMin doubleValue] + [temperatureMax doubleValue])/2)]];
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

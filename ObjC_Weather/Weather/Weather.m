//
//  Weather.m
//  Forecaster
//
//  Created by david on 1/22/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "Weather.h"

@implementation Weather

- (instancetype)init    :(NSNumber *)temperature
apparentTemperature     :(NSNumber *)apparentTemperature
summary                 :(NSString *)summary
icon                    :(NSString *)icon
precipitationProbability:(NSNumber *)precipitationProbability
precipitationIntensity  :(NSNumber *)precipitationIntensity
windSpeed               :(NSNumber *)windSpeed
humidity                :(NSNumber *)humidity
date                    :(NSDate *)date;
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
        _date                       = date;
    }
    return self;
}

///Initializes a master weather object with current weather and daily/hourly forecasts
- (Weather *)initWithResults:(NSDictionary *)results;
{
    Weather *weather = [[Weather alloc] init];
    
    NSDictionary *currently = (NSDictionary *)results[@"currently"];
    if (currently)
    {
        weather = [self initWithDictionary:currently];
    }
    
    NSDictionary *daily = (NSDictionary *)results[@"daily"];
    weather.dailyForecast = [[NSArray alloc] init];
    weather.dailyForecast = [self getForecastArrayFromDictionary:daily];

    NSDictionary *hourly = (NSDictionary *)results[@"hourly"];
    weather.hourlyForecast = [[NSArray alloc] init];
    weather.hourlyForecast = [self getForecastArrayFromDictionary:hourly];    

    return weather;
}

///Returns an array of weather objects (for weekly and hourly forecasts)
- (NSArray *)getForecastArrayFromDictionary:(NSDictionary *)dictionary
{
    NSArray *data = (NSArray *)dictionary[@"data"];
    
    if (data)
    {
        NSMutableArray *forecastArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *forecast in data)
        {
            Weather *weather = [[Weather alloc] initWithDictionary:forecast];
            [forecastArr addObject:weather];
        }
            
        return forecastArr;
    }
    
    return nil;
}

///Exactly what it says on the tin. Initializes a weather object from a provided dictionary argument. Ezpz.
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
         alright so the daiy forecast dictionaries don't have "temperature" and "apparentTemperature" keys,
         so if that above if statement fails,
         that means we're currently parsing the weekly/hourly forecast dictionaries instead of todays (currently) dictionary
         */
        
        NSNumber *temperatureMin            = (NSNumber *)dictionary[@"temperatureMin"];
        NSNumber *temperatureMax            = (NSNumber *)dictionary[@"temperatureMax"];
        
        temperature                         = [self getAverageTemperatureFromMin:temperatureMin max:temperatureMax];
        
        NSNumber *apparentTemperatureMin    = (NSNumber *)dictionary[@"apparentTemperatureMin"];
        NSNumber *apparentTemperatureMax    = (NSNumber *)dictionary[@"apparentTemperatureMax"];
        
        apparentTemperature                 = [self getAverageTemperatureFromMin:apparentTemperatureMin max:apparentTemperatureMax];
    }
    
    NSNumber *time          = (NSNumber *)dictionary[@"time"];
//    NSLog(@"%@", time);
    NSDate *date            = [[NSDate alloc] initWithTimeIntervalSince1970:[time doubleValue]];
    
//    NSLog(@"%@, %@", time, date);
    
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
               date                     :date
               ];
    
    return weather;
}

///For future dates, Darksky provides a temperature range instead of a single temperature value. This function just gets the formatted average of both numbers. Not very accurate, I guess, but it's for the sake of readability
- (NSNumber *)getAverageTemperatureFromMin:(NSNumber *)temperatureMin max:(NSNumber *)temperatureMax
{
    return [self formattedTemperature:
                             [NSNumber numberWithDouble:
                              (([temperatureMin doubleValue] + [temperatureMax doubleValue])/2)]];
}

///Rounds up temperature to the nearest whole number for readability purposes
- (NSNumber *)formattedTemperature:(NSNumber *)temperature;
{
    NSArray *fullTemperature = [[temperature stringValue] componentsSeparatedByString:@"."];
    
    if ([fullTemperature count] > 1)
    //Darksky drops the decimal if the temperature is a whole number (e.g. 77 instead of 77.00)
    {
        double firstNumber = [fullTemperature[0] doubleValue];
        if ([fullTemperature[1] doubleValue] > 50)
        {
            firstNumber += 1;
        }
        
        return [NSNumber numberWithDouble:firstNumber];
    }
    
    return temperature;
}

@end

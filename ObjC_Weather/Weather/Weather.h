//
//  Weather.h
//  Forecaster
//
//  Created by david on 1/22/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic) NSNumber *temperature;
@property (nonatomic) NSNumber *apparentTemperature;

@property (nonatomic) NSString *summary;
@property (nonatomic) NSString *icon;

@property (nonatomic) NSNumber *precipitationProbability;
@property (nonatomic) NSNumber *precipitationIntensity;

@property (nonatomic) NSNumber *windSpeed;

@property (nonatomic) NSNumber *humidity;

@property (nonatomic) NSDate *date;

//

@property (nonatomic) NSString *dailyForecastSummary;
@property (nonatomic) NSArray *dailyForecast;
@property (nonatomic) NSArray *hourlyForecast;

- (Weather *)initWithResults:(NSDictionary *)results;

@end

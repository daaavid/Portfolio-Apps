//
//  TimeOfDay.h
//  Forecaster
//
//  Created by david on 1/25/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Day,
    Night
}DayOrNightIdentifier;

@interface TimeOfDay : NSObject

+ (DayOrNightIdentifier)DayOrNight;
+ (NSArray *)getUpcomingDaysOfWeekFromToday;

@end

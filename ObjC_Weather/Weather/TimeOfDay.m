//
//  TimeOfDay.m
//  Forecaster
//
//  Created by david on 1/25/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "TimeOfDay.h"

@implementation TimeOfDay

+ (DayOrNightIdentifier)DayOrNight
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH.mm"];
    float currentTime = [[dateFormatter stringFromDate:[NSDate date]] floatValue];
    
    if (currentTime >= 18.00 || currentTime <= 6.00)
    {
        return Night;
    }
    else
    {
        return Day;
    }
}

@end

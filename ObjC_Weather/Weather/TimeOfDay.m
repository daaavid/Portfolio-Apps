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

+ (NSArray *)getUpcomingDaysOfWeekFromToday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger weekday = [[calendar components:NSCalendarUnitWeekday fromDate:[[NSDate alloc] init]] weekday];
    
    NSMutableArray *weekdays = [[NSMutableArray alloc] init];
    
    for (int loopFor = 7; loopFor > 0; loopFor--)
    {
        [weekdays addObject:[self assignDay:weekday]];
        weekday += 1;
    }
    
    return weekdays;
}

+ (NSString *)assignDay:(NSInteger)day
{
    if (day > 7)
    {
        day -= 7;
    }
    
    NSString *dayStr = [[NSString alloc] init];
    
    if (day == 1) {
        dayStr = @"Sunday";
    } else if (day == 2) {
        dayStr = @"Monday";
    } else if (day == 3) {
        dayStr = @"Tuesday";
    } else if (day == 4) {
        dayStr = @"Wednesday";
    } else if (day == 5) {
        dayStr = @"Thursday";
    } else if (day == 6) {
        dayStr = @"Friday";
    } else if (day == 7) {
        dayStr = @"Saturday";
    }
    
    return dayStr;
}

@end

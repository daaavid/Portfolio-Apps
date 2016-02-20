//
//  TimeOfDay.m
//  Forecaster
//
//  Created by david on 1/25/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "TimeOfDay.h"

@implementation TimeOfDay

///Determines if it's day or night using some VERY "PRECISE AND ACCURATE MEASUREMENTS"
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

///Returns an array of weekday strings starting from today
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

///Returns the weekday string value for today's date
+ (NSString *)getTodayString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger weekday = [[calendar components:NSCalendarUnitWeekday fromDate:[[NSDate alloc] init]] weekday];
    
    return [self assignDay:weekday];
}

///Returns a weekday when provided with a integer day of the week (1 == Sunday, 2 == Monday, etc)
+ (NSString *)assignDay:(NSInteger)day
{
    if (day > 7)
    {
        day -= 7;
    }
    
    NSString *dayStr = [[NSString alloc] init];
    
    //honestly not sure why this didn't work with a switch/case
    
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

+ (NSNumber *)getClosestNumber:(NSNumber *)number fromArray:(NSArray *)array
{
    int minDifference = 10;
    NSNumber *closestNum = [[NSNumber alloc] init];
    
    for (NSNumber *testNum in array)
    {
        int difference = [testNum intValue] - [number intValue];
        
        if (abs(difference) < minDifference)
        {
            minDifference = difference;
            closestNum = testNum;
        }
    }
    
    return closestNum;
}

@end

//
//  Settings.m
//  Weather
//
//  Created by david on 2/4/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "Settings.h"

@implementation Settings

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _hours = [NSNumber numberWithInt:12];
    }
    return self;
}

@end

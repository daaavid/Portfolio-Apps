//
//  Location.h
//  Forecaster
//
//  Created by david on 1/22/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

@interface Location : NSObject

@property (nonatomic) NSString *lat;
@property (nonatomic) NSString *lng;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) Weather *weather;

- (Location *)locationFromJSON:(NSArray *)results;

@end

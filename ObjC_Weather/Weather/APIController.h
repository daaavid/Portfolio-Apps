//
//  APIController.h
//  Forecaster
//
//  Created by david on 1/21/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

typedef enum {
    Zip,
    City
}LocationSearchIdentifier;

@protocol APIControllerProtocol

- (void)darkSkySearchDidComplete:(NSDictionary *)results location:(Location *)location;
- (void)googleLocationSearchDidComplete:(NSArray *)results;
- (void)googlePlacesSearchDidComplete:(NSArray *)results;

@end

@interface APIController : NSObject <NSURLSessionDelegate>

@property (nonatomic) id <APIControllerProtocol> delegate;
- (instancetype)initWithDelegate:(id <APIControllerProtocol>)delegate;

- (void)searchForLocation:(NSString *)searchTerm searchMethod:(NSString *)searchMethod;
- (void)searchForWeather:(Location *)location;

@end

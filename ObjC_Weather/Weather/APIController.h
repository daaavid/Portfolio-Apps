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

@protocol DarkSkyAPIProtocol
- (void)darkSkySearchDidComplete:(NSDictionary *)results location:(Location *)location;
@end

@protocol GooglePlacesAPIProtocol <NSObject>
- (void)googlePlacesSearchDidComplete:(NSArray *)results;
@end

@interface APIController : NSObject <NSURLSessionDelegate>

@property (nonatomic) id <DarkSkyAPIProtocol> darkSkyDelegate;
@property (nonatomic) id <GooglePlacesAPIProtocol> googlePlacesDelegate;

- (instancetype)initWithDarkSkyDelegate:(id <DarkSkyAPIProtocol>)delegate;
- (instancetype)initWithGooglePlacesDelegate:(id <GooglePlacesAPIProtocol>)delegate;


- (void)searchGooglePlacesFor:(NSString *)searchTerm;
- (void)searchForWeather:(Location *)location;

@end

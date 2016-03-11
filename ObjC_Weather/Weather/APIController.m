//
//  APIController.m
//  Forecaster
//
//  Created by david on 1/21/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "APIController.h"
#import "Location.h"
@import UIKit;

/*
 honestly would probably be better to make discrete API controllers for each task, but I wanted to cut out any duplicate code (probably at the cost of simplicity)
*/

@implementation APIController
{
    NSMutableData *receivedData;
    NSArray *locationsBuffer;
    Location *locationBuffer;
}

- (instancetype)initWithDarkSkyDelegate:(id <DarkSkyAPIProtocol>)delegate;
{
    if (self = [super init])
    {
        _darkSkyDelegate = delegate;
    }
    return self;
}

- (instancetype)initWithDarkSkyBatchDelegate:(id <DarkSkyBatchAPIProtocol>)delegate;
{
    if (self = [super init])
    {
        _darkSkyBatchDelegate = delegate;
    }
    return self;
}

- (instancetype)initWithGooglePlacesDelegate:(id <GooglePlacesAPIProtocol>)delegate;
{
    if (self = [super init])
    {
        _googlePlacesDelegate = delegate;
    }
    return self;
}

- (instancetype)initWithGoogleMapsDelegate:(id <GoogleMapsAPIProtocol>)delegate;
{
    if (self = [super init])
    {
        _googleMapsDelegate = delegate;
    }
    return self;
}

- (void)searchGooglePlacesFor:(NSString *)searchTerm
{
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *baseURLString = @"https://maps.googleapis.com/maps/api/place/autocomplete";
    NSString *apiKey = @"AIzaSyDTPgYOHM31jzVcZFV-wdg2RmdleSkAF-4";
    NSString *types = @"(cities)";
    
    NSString *fullURLString = [NSString stringWithFormat:@"%@/json?input=%@&types=%@&key=%@",
                               baseURLString,
                               searchTerm,
                               types,
                               apiKey];
    
//    NSLog(@"%@", fullURLString);
    
    [self beginTaskWithURLString:fullURLString andTaskDescription:@"GooglePlaces"];
    
}

- (void)searchGoogleMapsFor:(NSString *)searchTerm
{
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *baseURLString = @"https://maps.googleapis.com/maps/api/geocode";
    NSString *fullURLString = [NSString stringWithFormat:@"%@/json?address=%@&components=postal_code:&sensor=false",
                               baseURLString,
                               searchTerm];
    
    [self beginTaskWithURLString:fullURLString andTaskDescription:@"GoogleMaps"];
}

- (void)searchForWeather:(Location *)location
{
    NSString *apiKey = @"20e7ef512551da7f8d7ab6d2c9b4128c/";
    NSString *urlString = [NSString stringWithFormat:
                           @"https://api.forecast.io/forecast/%@%@,%@", apiKey, location.lat, location.lng];
    
    [self beginTaskWithURLString:urlString andTaskDescription:@"DarkSky"];
    
    NSLog(@"%@", urlString);
}

- (void)searchForWeatherWithArray:(NSArray *)locations
{
    locationsBuffer = [NSArray array];
    locationsBuffer = locations;
    
    for (Location *location in locations)
    {
        NSString *apiKey = @"20e7ef512551da7f8d7ab6d2c9b4128c/";
        NSString *urlString = [NSString stringWithFormat:
                               @"https://api.forecast.io/forecast/%@%@,%@", apiKey, location.lat, location.lng];
        
//        NSUInteger *locationDescription = [location hash];
        NSString *locationDescription = [NSString stringWithFormat:@"%@,%@", location.city, location.state];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            if (!error)
            {
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [self.darkSkyBatchDelegate darkSkySearchDidComplete:results locationDescription:locationDescription];
            }
        }];
        
        [task resume];
        
        
        
//        [self beginTaskWithURLString:urlString andTaskDescription:locationDescription];
    }
    //    NSLog(@"%@", urlString);
}

-(void)beginTaskWithURLString:(NSString *)urlString andTaskDescription:(NSString *)description
{
    NSURL *url = [NSURL URLWithString:urlString];
    if (url)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession
                                 sessionWithConfiguration:configuration
                                 delegate:self
                                 delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *task = [session dataTaskWithURL:url];
        
        //set task description here
        [task setTaskDescription:description];
        
        //start task
        [task resume];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    else
    {
        NSLog(@"invalid url %@",  urlString);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    if (!receivedData) //if haven't received data
    {
        receivedData = [[NSMutableData alloc] init];
        //initializing to store data
    }
    [receivedData appendData: data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (!error)
    {
        [self searchDidComplete:YES taskIdentifier:task.taskDescription];
        [task cancel];
    }
    else
    {
        //
    }
}

- (void)searchDidComplete:(BOOL)success taskIdentifier:(NSString *)identifier
{
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];
    
    if (results && success)
    {
        if ([identifier isEqualToString:@"DarkSky"])
        {
            [self.darkSkyDelegate darkSkySearchDidComplete:results location:locationBuffer];
        }
        else if ([identifier isEqualToString:@"GooglePlaces"])
        {
            NSArray *predictions = (NSArray *)results[@"predictions"];
            if ([predictions firstObject])
            {
                [self.googlePlacesDelegate googlePlacesSearchDidComplete:predictions];
            }
        }
        else if ([identifier isEqualToString:@"GoogleMaps"])
        {
            NSArray *resultsArray = (NSArray *)results[@"results"];
            if ([resultsArray firstObject])
            {
                Location *location = [self parseGoogleMapsResults:resultsArray];
                
                if (location)
                {
                    [self.googleMapsDelegate googleMapsSearchDidComplete:location];
                }
            }
        }
        else
        {
//            [self.darkSkyBatchDelegate darkSkySearchDidComplete:results locationDescription:identifier];
        }
    }
}

- (Location *)parseGoogleMapsResults:(NSArray *)results
{
    if ([results firstObject])
    {
        Location *location = [Location locationFromJSON:results];
        
//        NSLog(@"%@", location);
        
        return location;
    }
    return nil;
}

@end
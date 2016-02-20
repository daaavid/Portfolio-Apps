//
//  APIController.m
//  Forecaster
//
//  Created by david on 1/21/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "APIController.h"
@import UIKit;

@implementation APIController
{
    NSMutableData *receivedData;
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

- (instancetype)initWithGooglePlacesDelegate:(id <GooglePlacesAPIProtocol>)delegate;
{
    if (self = [super init])
    {
        _googlePlacesDelegate = delegate;
    }
    return self;
}

- (void)searchGooglePlacesFor:(NSString *)searchTerm
{
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *baseURLString = @"https://maps.googleapis.com/maps/api/place/autocomplete/";
    NSString *apiKey = @"AIzaSyDTPgYOHM31jzVcZFV-wdg2RmdleSkAF-4";
    NSString *types = @"(cities)";
    
    NSString *fullURLString = [NSString stringWithFormat:@"%@json?input=%@&types=%@&key=%@",
                               baseURLString,
                               searchTerm,
                               types,
                               apiKey];
    
    [self beginTaskWithURLString:fullURLString andTaskDescription:@"GooglePlaces"];
    
}

//- (void)searchGooglePlacesFor:(NSString *)searchTerm
//{
//    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    
//    NSString *baseURLString = @"https://maps.googleapis.com/maps/api/place/autocomplete";
//    NSString *apiKey = @"AIzaSyDTPgYOHM31jzVcZFV-wdg2RmdleSkAF-4";
//    NSString *argURLString = [NSString stringWithFormat:@"/json?input=%@&types=(cities)&key=%@", searchTerm, apiKey];
//    
//    NSString *fullURLString = [NSString stringWithFormat:@"%@%@", baseURLString, argURLString];
//    
//    [self beginTaskWithURLString:fullURLString andTaskDescription:@"GooglePlaces"];
//}

- (void)searchForWeather:(Location *)location
{
    NSString *apiKey = @"20e7ef512551da7f8d7ab6d2c9b4128c/";
    NSString *urlString = [NSString stringWithFormat:
                           @"https://api.forecast.io/forecast/%@%@,%@", apiKey, location.lat, location.lng];
    
    [self beginTaskWithURLString:urlString andTaskDescription:@"DarkSky"];
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
        
        [task setTaskDescription:description];
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
    }
}

@end
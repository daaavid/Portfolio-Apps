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
}

- (instancetype)initWithDelegate:(id <APIControllerProtocol>)delegate;
{
    if (self = [super init])
    {
        _delegate = delegate;
    }
    return self;
}

- (void)searchForLocation:(NSString *)searchTerm searchMethod:(NSString *)searchMethod;
{
    
}

- (void)searchForWeather:(Location *)location
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *urlString = [NSString stringWithFormat:
        @"https://api.forecast.io/forecast/20e7ef512551da7f8d7ab6d2c9b4128c/%@,%@", location.lat, location.lng];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession
                             sessionWithConfiguration:configuration
                             delegate:self
                             delegateQueue:[NSOperationQueue mainQueue]];
    

    NSURLSessionDataTask *task = [session dataTaskWithURL:url];
    [task setTaskDescription:@"DarkSky"];
    [task resume];
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
        [self.delegate darkSkySearchDidComplete:nil location:nil];
    }
}

- (void)searchDidComplete:(BOOL)success taskIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:@"DarkSky"])
    {
        if (success)
        {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];
            if (results)
            {
                [self.delegate darkSkySearchDidComplete:results location:nil];
            }
            else
            {
                [self.delegate darkSkySearchDidComplete:nil location:nil];
            }
        }
        else
        {
            
        }
    }
    else if ([identifier isEqualToString:@"Location"])
    {
        if (success)
        {
            
        }
        else
        {
            
        }
    }
    else if ([identifier isEqualToString:@"Places"])
    {
        if (success)
        {
            
        }
        else
        {
            
        }
    }
}

@end

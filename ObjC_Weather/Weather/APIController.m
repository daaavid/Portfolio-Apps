//
//  APIController.m
//  Forecaster
//
//  Created by david on 1/21/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "APIController.h"

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
    NSString *urlString = [NSString stringWithFormat:
        @"https://api.forecast.io/forecast/20e7ef512551da7f8d7ab6d2c9b4128c/%@,%@", location.lat, location.lng];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession
                             sessionWithConfiguration:configuration
                             delegate:self
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithURL:url] resume];
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
    if (!error)
    {
        printf("got here");
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];
        
        if (results)
        {
            [self.delegate darkSkySearchDidComplete:results location:nil];
        }
        else
        {
            [self.delegate darkSkySearchDidComplete:nil location:nil];
        }
        [task cancel];
    }
    else
    {
        [self.delegate darkSkySearchDidComplete:nil location:nil];
    }
}

@end

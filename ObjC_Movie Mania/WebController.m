//
//  WebController.m
//  Movie Mania
//
//  Created by david on 11/14/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import "WebController.h"

@implementation WebController
{
    NSMutableData *receivedData;
    NSDictionary *searchResults;
}

#pragma mark - movie search

- (void)search:(NSString *)selectedMovieTitle year:(NSString *)year;
{    
    NSString *searchTerm = selectedMovieTitle;
    NSString *formattedSearchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *urlString;
    if (year == nil)
    {
        urlString = [NSString stringWithFormat:@"https://www.omdbapi.com/?s=%@&y=&plot=short&r=json", formattedSearchTerm];
    }
    else
    {
        if ([year containsString:@"–"])
        {
            year = [year componentsSeparatedByString:@"–"][0];
        }
        
        urlString = [NSString
                     stringWithFormat:@"https://www.omdbapi.com/?t=%@&tomatoes=true&y=%@&plot=long&r=json", formattedSearchTerm, year];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration
                                                defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession
                             sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url];
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
        //initializing thing to store data
    }
    [receivedData appendData: data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //received all data or received error
    if (!error) //if there was no error
    {
        searchResults = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];
        
        NSArray *searchArr = searchResults[@"Search"];
        if (searchArr)
        {
            [self.searchdelegate searchResultsWereFound:searchArr];
        }
        else
        {
            [self.delegate searchWasCompleted: searchResults];
        }
        [task cancel];
    }
}

#pragma mark - image search

- (void)findImage:(NSURL *)imageURL
{
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(requestRemoteImage:)
                                        object:imageURL];
    [queue addOperation:operation];
}

- (void)requestRemoteImage:(NSURL *)imageURL
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    [self performSelectorOnMainThread:@selector(foundImage:)
                           withObject:image waitUntilDone:YES];
}

- (void)foundImage:(UIImage *)image
{
    [self.delegate imageWasFound:image];
    [self.posterdelegate imageWasFound:image];
}

@end
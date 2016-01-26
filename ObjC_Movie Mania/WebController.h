//
//  WebController.h
//  Movie Mania
//
//  Created by david on 11/14/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"
#import "PosterZoomViewController.h"
#import "SearchTableViewController.h"

@interface WebController : NSObject <NSURLSessionDelegate>

@property (nonatomic) id <SearchProtocol> searchdelegate;
@property (nonatomic) id <WebProtocol> delegate;
@property (nonatomic) id <ImageProtocol> posterdelegate;

- (void)search:(NSString *)selectedMovieTitle year:(NSString *)year;
- (void)findImage:(NSURL *)imageURL;

@end

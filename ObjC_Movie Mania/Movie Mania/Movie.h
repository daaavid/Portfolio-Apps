//
//  Movie.h
//  Movie Mania
//
//  Created by david on 11/13/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic) NSString *posterURL;
@property (nonatomic) NSString *title;

@property (nonatomic) NSString *year;
@property (nonatomic) NSString *rating;
@property (nonatomic) NSString *runtime;
@property (nonatomic) NSString *country;

@property (nonatomic) NSArray *genre;
@property (nonatomic) NSArray *actors;
@property (nonatomic) NSArray *ratings;

@property (nonatomic) NSString *plot;
@property (nonatomic) NSString *production;
@property (nonatomic) NSString *boxOffice;
@property (nonatomic) NSString *awards;
@property (nonatomic) NSString *consensus;

- (instancetype)initSearchResultsWithDictionary: (NSDictionary *)searchResults;
- (instancetype)initDetailWithDictionary: (NSDictionary *)movieDictionary;

@end

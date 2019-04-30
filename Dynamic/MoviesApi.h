//
//  MoviesApi.h
//  DynamicLibrary
//
//  Created by Praneeth,on 18/4/19.
//  Copyright © 2019 Praneeth Goli. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MoviesApi : NSObject <NSURLSessionDelegate>

- (id)initWithKey:(NSString*)apiKey;
-(NSArray*) getTop10Sorted:(NSString*)searchStr withYears:(NSArray*)years;

-(NSArray *)getMovies:(NSString*)searchStr withYears:(NSArray*)years;
-(NSArray *)getMovies:(NSString*)searchStr wihYear:(NSInteger)year;
- (NSDictionary *)makeRequest:(NSString*)searchStr wihYear:(NSInteger)year withPage:(NSInteger)page;


@property (nonatomic, retain) NSString *apiKey;

@end


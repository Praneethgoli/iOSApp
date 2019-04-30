//
//  MoviesApi.m
//  DynamicLibrary
//
//  Created by Praneeth,on 18/4/19.
//  Copyright © 2019 Praneeth Goli. All rights reserved.
//

#import "MoviesApi.h"
#include "static_lib.h"

@implementation MoviesApi
@synthesize apiKey;


- (id)initWithKey:(NSString*)apiKey {
    if (self = [super init]) {
        self.apiKey = [[NSString alloc] initWithString:apiKey];
    }
    return self;
}

-(NSArray*) getTop10Sorted:(NSString*)searchStr withYears:(NSArray*)years
{
    NSArray * movies_list = [self getMovies:searchStr withYears:years];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    MovieType  tobeSorted[movies_list.count];
    for(int i=0;i<movies_list.count;i++)
    {
        NSDictionary * movie = [movies_list objectAtIndex:i];
        NSNumber * movieId = [movie objectForKey:@"id"];
        NSNumber * rating = [movie objectForKey:@"vote_average"];
        //Store in Dictionary for lookpup
        [dict setObject:[movies_list objectAtIndex:i] forKey:movieId];
        
        NSInteger cMovieId = [movieId longLongValue];
        double cRating = [rating doubleValue];
        MovieType entry = { cMovieId,cRating};
        tobeSorted[i] = entry;
    }
    //Sort using Static Lib
    sortMovies(tobeSorted, (int)movies_list.count);
    
    unsigned long top10Len = MIN(movies_list.count, 10);
    NSMutableArray * sortedTop10 = [NSMutableArray array];
    for(int i=0;i< top10Len;i++)
    {
        NSLog(@"Finding %lld",tobeSorted[i].movie_id);
        NSNumber * movieId = [NSNumber numberWithLong:tobeSorted[i].movie_id];
        NSDictionary * movie = [dict objectForKey:movieId];
        if(movie != nil)
        {
           [sortedTop10 addObject:movie];
        }
        else{
            NSLog(@"Movie ID not found :%@",movieId);
        }
        
    }
    return  sortedTop10;
}
-(NSArray *)getMovies:(NSString*)searchStr withYears:(NSArray*)years{
    
    NSMutableArray * list = [NSMutableArray array];
    for(int i=0;i<years.count;i++)
    {
        NSNumber * year = [years objectAtIndex:i];
        NSArray * movies = [self getMovies:searchStr wihYear:[year integerValue]];
        [list addObjectsFromArray:movies];
    }
    return list;
}
- (NSArray *)getMovies:(NSString*)searchStr wihYear:(NSInteger)year
{
    
    NSDictionary * first = [self makeRequest:searchStr wihYear:year withPage:1];
    
    if(first == nil ||  [first valueForKey:@"results"] == nil)
    {
        return [NSArray array];
    }
    NSArray * first_list =[first valueForKey:@"results"];
    
    NSInteger totalPages =  [[first valueForKey:@"total_pages"] integerValue];
    //NSLog(@"Total page for the year %ld : %zd",year, totalPages);
    //NSLog(@"Results count for page :1 : %zd",first_list.count);

    //We will get maximum of 10 pages.
    if(totalPages > 10)
    {
        totalPages = 10;
    }
    if(first_list != nil && totalPages > 1)
    {
        NSMutableArray * full_list=  [NSMutableArray arrayWithArray:first_list];
        
        for(int i=2;i<=totalPages;i++)
        {
            NSDictionary * resp  = [self makeRequest:searchStr wihYear:year withPage:i];
            
            NSArray * results =[resp valueForKey:@"results"];
            //NSLog(@"Results count for page :%d : %zd",i,results.count);
            
            if(results == nil || results.count == 0)
            {
                break;
            }
            [full_list addObjectsFromArray:results];
        }
        //NSLog(@"##Records for the year :%ld : %zd",(long)year,full_list.count);

        return full_list;
    }
    
    //NSLog(@"##Records for the year :%ld : %zd",(long)year,first_list.count);
    
    return first_list;
}


- (NSDictionary *)makeRequest:(NSString*)searchStr wihYear:(NSInteger)year withPage:(NSInteger)page {
    
    __block NSException * exception = nil;
    __block NSDictionary * ret = [[NSMutableDictionary alloc] init];
    
    NSLog(@"Making Request %@ %zd %zd",searchStr,year,page);
    NSString * baseUrl = @"http://api.themoviedb.org/3/search/movie";
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(  NULL,(CFStringRef)searchStr,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
    
    NSString  * url = [NSString stringWithFormat:@"%@?api_key=%@&year=%zd&page=%zd&query=%@",baseUrl,apiKey,year,page,encodedString];
    NSLog(@"URL is : %@",url);
    dispatch_semaphore_t    sem;
    sem = dispatch_semaphore_create(0);

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if(error != nil)
        {
            exception = [NSException exceptionWithName:@"HTTP Error" reason:error.description userInfo:nil];
            dispatch_semaphore_signal(sem);

            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Status code :%ld",httpResponse.statusCode);
        //NSLog(@"data : %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            ret  = obj;
        }
        else{
            if(data != nil)
            {
                NSError *parseError = nil;
                NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                NSString * statusMessage = [obj valueForKey:@"status_message"];
                exception =  [NSException exceptionWithName:@"HTTP Error" reason:statusMessage userInfo:@{}] ;
            }
            else
            {
                exception =  [NSException exceptionWithName:@"HTTP Error" reason:@"Unknown Error" userInfo:@{}] ;

            }
            
        }
        dispatch_semaphore_signal(sem);

    }];
    [dataTask resume];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    //NSLog(@"Returning Request %@ %zd %zd",searchStr,year,page);

    if(exception != nil)
    {
        [exception raise];
    }
    return ret;
}
@end

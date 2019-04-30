//
//  KeyChainWrapper.h
//  MoviesApp
//
//  Created by Praneeth,on 20/4/19.
//  Copyright © 2019 Praneeth Goli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainWrapper : NSObject
+ (id)sharedInstance;
-(BOOL) insert:(NSString *)key value:(NSString *)value;
-(BOOL) insertOrUpdate:(NSString *)key value:(NSString *)value;
-(BOOL) remove: (NSString*)key;
-(NSString*) get:(NSString*)key;
@end

NS_ASSUME_NONNULL_END

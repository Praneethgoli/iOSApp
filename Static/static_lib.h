//
//  static_lib.h
//  StaticLibrary
//
//  Created by Praneeth,on 18/4/19.
//  Copyright © 2019 Praneeth Goli. All rights reserved.
//

#ifndef static_lib_h
#define static_lib_h
#include <stdio.h>

typedef struct
{
    long long int movie_id;
    double rating;
}MovieType;

void sortMovies(MovieType movies[],int len);

#endif /* static_lib_h */

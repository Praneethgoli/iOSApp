//
//  static_lib.c
//  StaticLibrary
//
//  Created by Praneeth,on 18/4/19.
//  Copyright © 2019 Praneeth Goli. All rights reserved.
//

#include "static_lib.h"

void swap(MovieType* a, MovieType* b)
{
    MovieType t = *a;
    *a = *b;
    *b = t;
}

int partition (MovieType arr[], int low, int high)
{
    MovieType pivot = arr[high];    // pivot
    int i = (low - 1);  // Index of smaller element
    
    for (int j = low; j <= high- 1; j++)
    {
        if (arr[j].rating >= pivot.rating)
        {
            i++;    // increment index of smaller element
            swap(&arr[i], &arr[j]);
        }
    }
    swap(&arr[i + 1], &arr[high]);
    return (i + 1);
}

void quickSort(MovieType arr[], int low, int high)
{
    if (low < high)
    {
        /* pi is partitioning index, arr[p] is now
         at right place */
        int pi = partition(arr, low, high);
        
   
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

void  sortMovies(MovieType movies[],int len)
{
    quickSort(movies, 0, len-1);
}

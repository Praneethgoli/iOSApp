//
//  ViewController.m
//  MoviesApp
//
//  Created by Praneeth,on 18/4/19.
//  Copyright © 2019 Praneeth Goli. All rights reserved.
//

#import "ViewController.h"
#import "MoviesApi.h"
#include "static_lib.h"
#include "CustomTableViewCell.h"
#include "SettingsViewController.h"
#include "KeyChainWrapper.h"

@implementation ViewController
@synthesize searchBox;
@synthesize mytableView;
@synthesize tableData;
@synthesize loadingController;
@synthesize  indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    [mytableView setDelegate:self];
    [mytableView setDataSource:self];
    tableData = [[NSArray alloc] init];
    mytableView.tableFooterView = [[UIView alloc] init] ;
    loadingController = [UIAlertController
                         alertControllerWithTitle:nil
                         message:@"Loading...\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.color = [UIColor blackColor];
    indicator.translatesAutoresizingMaskIntoConstraints=NO;
    [loadingController.view addSubview:indicator];
    NSDictionary * views = @{@"pending" : loadingController.view, @"indicator" : indicator};
    
    NSArray * constraintsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicator]-(20)-|" options:0 metrics:nil views:views];
    NSArray * constraintsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[indicator]|" options:0 metrics:nil views:views];
    NSArray * constraints = [constraintsVertical arrayByAddingObjectsFromArray:constraintsHorizontal];
    [loadingController.view addConstraints:constraints];
    [indicator setUserInteractionEnabled:NO];

    searchBox.delegate = self;
   
    
}

-(void) showLoading:(void (^)(void))completion
{
    [self presentViewController:loadingController animated:false completion:^{
        [self->indicator startAnimating];
        completion();
    }];
}
-(void) hideLoading:(void (^)(void))completion
{
    [indicator stopAnimating];
    [loadingController dismissViewControllerAnimated:false completion:completion];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *obj = [tableData objectAtIndex:indexPath.row];
    cell.movieTitle.text = [obj valueForKey:@"original_title"];
    cell.movieDate.text = [obj valueForKey:@"release_date"];
    NSNumber * rating = [obj valueForKey:@"vote_average"];
    double percentage = [rating doubleValue];
    cell.movieRating.text = [NSString stringWithFormat:@"%3.2f",percentage];
    
    NSString * imageUrl = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w154%@",[obj valueForKey:@"poster_path"]];

    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(backgroundQueue, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];

        // only update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(imageData != nil)
            {
                [cell.imageView setImage: [UIImage imageWithData:imageData]];
            }
        });
    });
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}

-(void) showMessage:(NSString *)title message:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];

}


-(void) searchMovies
{
    NSString * apiKey = [[KeyChainWrapper sharedInstance] get:@"API_KEY"];
    NSLog(@"Saved API Key = %@",apiKey);
    if(apiKey == nil || apiKey.length < 3)
    {
        [self showSettings];
        return;
    }
    
    
    if(searchBox.text.length == 0)
    {
        [self showMessage:@"Error" message:@"Please enter text"];
        return;
    }
    [self showLoading:^{
        
        @try {
            MoviesApi * api = [[MoviesApi alloc] initWithKey:apiKey];
            self->tableData = [api getTop10Sorted:self->searchBox.text withYears:@[@2017,@2018]];
            if(self->tableData == nil || self->tableData.count == 0)
            {
                [self hideLoading:^{
                    [self showMessage:@"Message" message:@"No Movies found"];
                }];
                
            }
            else{
                [self hideLoading:^{
                    [self->mytableView reloadData];
                }];
            }
        } @catch (NSException *exception) {
            [self hideLoading:^{
                [self showMessage:@"Error" message:exception.description];
            }];
            
        }
    }];
    
   
}
-(IBAction) serachButtonClicked:(id)sender
{
    [self searchMovies];
}
-(void) showSettings
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingsViewController* settingsController = [sb instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self presentViewController:settingsController animated:true completion:nil];

}
-(IBAction) settingsClicked:(id)sender
{
    [self showSettings];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == searchBox) {
        [textField resignFirstResponder];
        
        [self searchMovies];
        return NO;
    }
    return YES;
}

@end

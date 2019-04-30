//
//  ViewController.h
//  MoviesApp
//
//  Created by Praneeth,on 18/4/19.
//  Copyright © 2019 Praneeth Goli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextInputDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchBox;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *mytableView;

@property  UIAlertController *loadingController;
@property  UIActivityIndicatorView *indicator;

@property NSArray * tableData;


@end


//
//  CustomTableViewCell.h
//  MoviesApp
//
//  Created by Praneeth,on 19/4/19.
//  Copyright © 2019 Praneeth Goli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;

@property (weak, nonatomic) IBOutlet UILabel *movieRating;
@property (weak, nonatomic) IBOutlet UILabel *movieDate;


@end


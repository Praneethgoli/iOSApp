//
//  CustomTableViewCell.m
//  MoviesApp
//
//  Created by Praneeth,on 19/4/19.
//  Copyright © 2019 Praneeth Goli. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell
@synthesize  imageView;
@synthesize  movieTitle;
@synthesize movieDate;
@synthesize movieRating;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

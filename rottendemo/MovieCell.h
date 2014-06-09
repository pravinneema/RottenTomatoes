//
//  MovieCell.h
//  rottendemo
//
//  Created by Pravin Neema on 6/5/14.
//  Copyright (c) 2014 Pravin Neema. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLable;

@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end

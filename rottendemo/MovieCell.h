//
//  MovieCell.h
//  rottendemo
//
//  Created by Pravin Neema on 6/5/14.
//  Copyright (c) 2014 Pravin Neema. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (strong, nonatomic) NSDictionary * _movie;
@property (strong, nonatomic) NSMutableDictionary *staticImageDictionary;

-(void) setMovie:(NSDictionary *) movie;
@end

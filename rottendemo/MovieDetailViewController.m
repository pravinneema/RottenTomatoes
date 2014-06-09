//
//  MovieDetailViewController.m
//  rottendemo
//
//  Created by Pravin Neema on 6/8/14.
//  Copyright (c) 2014 Pravin Neema. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"


@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.title = @"Detail";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *posterUrl = [NSURL URLWithString:[self.movie valueForKeyPath:@"posters.original"]];
    [self.posterView setImageWithURL:posterUrl];
    
    self.titleLabel.text = self.movie[@"title"];
    self.title = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  MovieViewViewController.m
//  rottendemo
//
//  Created by Pravin Neema on 6/3/14.
//  Copyright (c) 2014 Pravin Neema. All rights reserved.
//

#import "MovieViewViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "MovieDetailViewController.h"

@interface MovieViewViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UIView *fixedTableFooterView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation MovieViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    self.tableView.rowHeight = 100;
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
}

-(void) loadData{
    self.errorLabel.hidden=true;
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=856vhx7bdp3w6g3f5snceash";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (connectionError)
        {
            NSLog(@"COULD NOT READ LOCAL CACHED DATA: %@", connectionError.localizedDescription);
            self.errorLabel.hidden=false;
            self.tableView.hidden = true;
        }
        else
        {
            self.movies = object[@"movies"];
            [self.tableView reloadData];
        }
        
    }];

}

- (void)stopRefresh
{
    NSLog(@"StopRefreshing");
    [self.refreshControl endRefreshing];
}

-(void) refresh:(id)sender{
    NSLog(@"Loading new data");
    [self loadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *movie = self.movies[indexPath.row];
    
//    NSLog(@"The select object is : %@", movie);
    
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    vc.movie = movie;
    
    [self.navigationController pushViewController:vc animated:YES];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.movieTitleLable.text = movie[@"title"];
    cell.synopsisLable.text = movie[@"synopsis"];

    NSDictionary *posters = movie[@"posters"];
    
    NSString *imageUrl = posters[@"thumbnail"];
    NSURL *url = [NSURL URLWithString:imageUrl];
    [cell.posterView setImageWithURL:url];
    
    cell.posterView.center = CGPointMake(100, 100);
    cell.posterView.alpha = 0.0;
    [UIView animateWithDuration:5.0 animations:^{
        cell.posterView.alpha = 1.0;
    }];
    
    
    return cell;
}

@end

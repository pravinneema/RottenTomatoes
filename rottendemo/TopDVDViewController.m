//
//  TopDVDViewController.m
//  rottendemo
//
//  Created by Pravin Neema on 6/9/14.
//  Copyright (c) 2014 Pravin Neema. All rights reserved.
//

#import "TopDVDViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

@interface TopDVDViewController ()
@property (weak, nonatomic) IBOutlet UITableView *TopDvdTableView;
@property (nonatomic, strong) NSArray *movies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TopDVDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Top Dvd";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.TopDvdTableView.delegate = self;
    self.TopDvdTableView.dataSource = self;
    
    [self loadData];
    
    [self.TopDvdTableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    self.TopDvdTableView.rowHeight = 100;
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 0, 0)];
    [self.TopDvdTableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.TopDvdTableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadData{
//    self.errorLabel.hidden=true;
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=856vhx7bdp3w6g3f5snceash";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (connectionError)
        {
            NSLog(@"COULD NOT READ LOCAL CACHED DATA: %@", connectionError.localizedDescription);
//            self.errorLabel.hidden=false;
            self.TopDvdTableView.hidden = true;
        }
        else
        {
            self.movies = object[@"movies"];
            [self.TopDvdTableView reloadData];
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

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSDictionary *movie = self.movies[indexPath.row];
//    
//    //    NSLog(@"The select object is : %@", movie);
//    
//    NSString *imageUrl = movie[@"posters"][@"original"];
//    NSURL *url = [NSURL URLWithString:imageUrl];
//    [self._detailMoviePoster setImageWithURL:url];
//    
//    self._detailMoviePoster.center = CGPointMake(100, 100);
//    self._detailMoviePoster.alpha = 0.0;
//    [UIView animateWithDuration:5.0 animations:^{
//        self._detailMoviePoster.alpha = 1.0;
//    }];
//    
//    self.title = movie[@"title"];
//    
//    self.detailSynopsisLabel.text = movie[@"synopsis"];
//    self.movieDetailTitle.text = movie[@"title"];
//    
//    [self animateView];
//}
//
//-(void) animateView {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.detailView.frame = CGRectMake(0, 0, 320, 600);
//    }];
//}


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

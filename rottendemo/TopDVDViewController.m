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
#import "MovieDetailViewController.h"

@interface TopDVDViewController ()
@property (weak, nonatomic) IBOutlet UITableView *TopDvdTableView;
@property (strong, nonatomic) NSMutableArray* movies;
@property (strong, nonatomic) NSMutableArray* filteredMovieData;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@property BOOL isFiltered;

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
    self.TopDvdTableView.rowHeight = 110;
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 0, 0)];
    [self.TopDvdTableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.TopDvdTableView addSubview:self.refreshControl];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.TopDvdTableView.frame.size.width, 44.0)];
    self.searchBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.delegate = self;
    self.TopDvdTableView.tableHeaderView = self.searchBar;
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
    [self.refreshControl endRefreshing];
}

-(void) refresh:(id)sender{
    [self loadData];
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int rowCount;
    if(self.isFiltered)
        rowCount = self.filteredMovieData.count;
    else
        rowCount = self.movies.count;
    
    return rowCount;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    vc.movie = movie;
    
    UITableViewCell* tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableViewCell setSelected:NO animated:YES]; // <-- setSelected instead of setHighlighted
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie;
    
    if(self.isFiltered)
        movie = self.filteredMovieData[indexPath.row];
    else
        movie = self.movies[indexPath.row];
    
    [cell setMovie:movie];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
    bgView.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = bgView;
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selected = NO;
    BOOL isSelectedPath =
    [indexPath compare:[tableView indexPathForSelectedRow]] == NSOrderedSame;
    cell.accessoryType = isSelectedPath ?
    UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    NSLog(@"Search Movies");
    
    if(searchText.length == 0)
    {
        self.isFiltered = FALSE;
    }
    else
    {
        self.filteredMovieData = [[NSMutableArray alloc] init];
        
        for (int i=0; i < [self.movies count]; i++) {
            NSString *movieTitle = self.movies[i][@"title"];
            NSRange range = [movieTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
            if(range.length)
            {
                [self.filteredMovieData addObject:self.movies[i]];
                self.isFiltered = true;
            }
        }
    }
    
    [self.TopDvdTableView reloadData];
    
    searchBar.showsCancelButton = YES;}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:TRUE];
}


@end

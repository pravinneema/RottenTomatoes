//
//  MovieViewViewController.m
//  rottendemo
//
//  Created by Pravin Neema on 6/3/14.
//  Copyright (c) 2014 Pravin Neema. All rights reserved.
//

#import "MovieViewViewController.h"
#import "MovieCell.h"
#import "MBProgressHUD.h"
#import "MovieDetailViewController.h"

@interface MovieViewViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* movies;
@property (strong, nonatomic) NSMutableArray* filteredMovieData;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UIView *fixedTableFooterView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL isFiltered;
@end

@implementation MovieViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Box Office";
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
    self.tableView.rowHeight = 110;
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44.0)];
    self.searchBar.delegate = self;
    self.searchBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.tableView.tableHeaderView = self.searchBar;
    
    
    self.tableView.tableHeaderView = self.searchBar;
}

-(void) loadData{
    self.errorLabel.hidden=true;
    
    NSString *url= @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=856vhx7bdp3w6g3f5snceash";
    
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
    [self.refreshControl endRefreshing];
}

-(void) refresh:(id)sender{
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    [self.view endEditing:true];
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
    
    [self.tableView reloadData];
    
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:TRUE];
}
@end

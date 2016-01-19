//
//  SearchTableViewController.m
//  Movie Mania
//
//  Created by david on 11/12/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import "SearchTableViewController.h"
#import "DetailViewController.h"
#import "HistoryTableViewController.h"
#import "WebController.h"

NSString *kHistoryKey = @"history";

@interface SearchTableViewController () <UISearchBarDelegate, UIPopoverPresentationControllerDelegate>
{
    NSMutableArray *searchResults;
    NSMutableArray *searchHistory;
    WebController *webController;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *historyButton;

@end

@implementation SearchTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHue:0.918 saturation:0.848 brightness:0.555 alpha:1];

    self.searchBar.delegate = self;
    
    UITextField *searchBarTextField = (UITextField *)[self.searchBar valueForKey:@"searchField"];
    searchBarTextField.textColor = [UIColor whiteColor];
    
    searchResults = [[NSMutableArray alloc] init];
    searchHistory = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self manageHistory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [searchResults removeAllObjects];
    [searchHistory removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    
    Movie *movie = searchResults[indexPath.row];
    
    cell.textLabel.text = movie.title;
    cell.detailTextLabel.text = movie.year;
    cell.backgroundColor = [UIColor colorWithHue:0.918 saturation:0.848 brightness:0.555 alpha:1];;

    return cell;
}

#pragma mark - search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self search];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self search];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchResults removeAllObjects];
    [self.tableView reloadData];
}

- (void)search
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    webController = [[WebController alloc] init];
    webController.searchdelegate = self;
    [webController search:self.searchBar.text year:nil];
}

- (void)searchResultsWereFound:(NSArray *)results;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [searchResults removeAllObjects];
    for(NSDictionary *result in results)
    {
        Movie *movie = [[Movie alloc] initSearchResultsWithDictionary:result];
        [searchResults addObject:movie];
    }
    [self.tableView reloadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowHistoryPopover"])
    {
        HistoryTableViewController *historyVC = segue.destinationViewController;
        UIPopoverPresentationController *popover = historyVC.popoverPresentationController;
        popover.delegate = self;
        historyVC.delegate = self;
        
        historyVC.history = searchHistory;
        
        historyVC.modalPresentationStyle = UIModalPresentationPopover;
        float contentSize = searchHistory.count * 44;
        
        historyVC.preferredContentSize = CGSizeMake(200, contentSize);
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

#pragma mark - Detail View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Movie *selectedMovie = searchResults[indexPath.row];
    
    [searchHistory insertObject:selectedMovie atIndex:0];
    
    [self makeDetailVC:selectedMovie];
}

- (void)historySearchResultWasChosen:(Movie *)movie;
{
    [self makeDetailVC:movie];
}

- (void)makeDetailVC:(Movie *)selectedMovie
{
    DetailViewController *detailVC = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    detailVC.selectedMovie = selectedMovie;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - search history management

- (void)manageHistory
{
    if (searchHistory.count > 0)
    {
        self.historyButton.enabled = YES;
        
        if (searchHistory.count > 5)
        {
            [searchHistory removeObjectAtIndex:4];
        }
    }
    else
    {
        self.historyButton.enabled = NO;
    }
}

- (void)saveHistory
{
    NSData *historyData = [NSKeyedArchiver archivedDataWithRootObject:searchHistory];
    [[NSUserDefaults standardUserDefaults] setObject:historyData forKey:kHistoryKey];
    NSLog(@"saved %@", searchHistory);
}

- (void)loadHistory
{
    NSData *data = (NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:kHistoryKey];
    NSArray *savedHistory = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (savedHistory)
    {
        [searchHistory removeAllObjects];
        [searchHistory addObjectsFromArray:savedHistory];
        NSLog(@"loaded %@", searchHistory);
    }
}


@end

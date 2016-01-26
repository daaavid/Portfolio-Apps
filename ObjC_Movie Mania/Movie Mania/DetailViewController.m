//
//  DetailViewController.m
//  Movie Mania
//
//  Created by david on 11/12/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import "DetailViewController.h"

#import "WebController.h"

#import "ActorTableViewController.h"
#import "ReviewsTableViewController.h"
#import "GenreTableViewController.h"
#import "PosterZoomViewController.h"

@interface DetailViewController () <UIPopoverPresentationControllerDelegate, UIScrollViewDelegate>
{
    NSDictionary *searchResults;    
    WebController *webController;
    Movie *movie;
}

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *fetchingResultsView;
@property (weak, nonatomic) IBOutlet UIView *posterBlurView;
@property (weak, nonatomic) IBOutlet UILabel *posterNALabel;

@property (weak, nonatomic) IBOutlet UIScrollView *background;
@property (weak, nonatomic) IBOutlet UIScrollView *foreground;

@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRuntimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieReleaseLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieCountryLabel;

@property (weak, nonatomic) IBOutlet UITextView *moviePlotTextView;
@property (weak, nonatomic) IBOutlet UILabel *movieProductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieBoxOfficeLabel;

@property (weak, nonatomic) IBOutlet UILabel *movieAwardsLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieConsensusTextView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self search];
    
    self.background.delegate = self;
    self.foreground.delegate = self;
    
    self.fetchingResultsView.hidden = NO;
    self.posterImage.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - search called in saerch view controller

-(void)search
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    webController = [[WebController alloc] init];
    webController.delegate = self;
    [webController search:self.selectedMovie.title year:self.selectedMovie.year];
}

#pragma mark - function called when web controller retrieves movie dictionary

- (void)searchWasCompleted:(NSDictionary *)results;
{
    searchResults = results;
    
    self.fetchingResultsView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self populateView];
}

#pragma mark - function called when web controller finds poster image for movie

- (void)imageWasFound:(UIImage *)image;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (image) //if we have an image. prevent crashes
    {
        self.posterImage.image = image;
        [self animatePosterImg];
        [self setupPosterTap];
    }
    else
    {
        self.posterNALabel.hidden = NO;
    }
}

- (void)animatePosterImg
{
    [UIView animateWithDuration:0.5 animations: ^
     {
         self.posterImage.hidden = NO;
         self.posterImage.alpha = 0;
         self.posterImage.alpha = 1;
     }];
}


#pragma mark - view population

- (void)populateView
{
    movie = [[Movie alloc] initDetailWithDictionary:searchResults];
    
    self.movieTitleLabel.text = movie.title;
    
    self.moviePlotTextView.text = movie.plot;
    self.moviePlotTextView.selectable = NO;
    
    self.movieRatingLabel.text = movie.rating;
    self.movieReleaseLabel.text = movie.year;
    self.movieRuntimeLabel.text = movie.runtime;
    
    NSString *formattedCountry = [NSString stringWithFormat:@"(%@)", movie.country];
    
    self.movieCountryLabel.text = formattedCountry;
    self.movieCountryLabel.selectable = NO;
    
    NSString *formattedBoxOffice = [movie.boxOffice stringByReplacingOccurrencesOfString:@"M" withString:@" Million."];
    
    self.movieBoxOfficeLabel.text = [NSString
                                     stringWithFormat:@"Box Office: %@", formattedBoxOffice];
    
    NSString *formattedProduction = [NSString
                                     stringWithFormat:@"%@.", movie.production];
    self.movieProductionLabel.text = formattedProduction;
    
    NSString *formattedAwards = [NSString
                                 stringWithFormat:@"Awards: %@", movie.awards];
    
    self.movieAwardsLabel.text = formattedAwards;
    
    NSString *formattedConsensus = [NSString
                                    stringWithFormat:@"Consensus: \n%@", movie.consensus];
    self.movieConsensusTextView.text = formattedConsensus;
    self.movieConsensusTextView.selectable = NO;
    
    if (movie.posterURL) //if we have a url for the image
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURL *url = [NSURL URLWithString:movie.posterURL];
        [webController findImage:url];
    }
    
    [self populateChildViews];
}

- (void)populateChildViews
{    
    //review embedded tableview
    ReviewsTableViewController *reviewVC = (ReviewsTableViewController *)self.childViewControllers[0];
    reviewVC.reviews = movie.ratings;
    [reviewVC.tableView reloadData];
    
    //genre embedded tableview
    GenreTableViewController *genreVC = (GenreTableViewController *)self.childViewControllers[1];
    genreVC.genres = movie.genre;
    [genreVC.tableView reloadData];
    
    //actor embedded tableview
    ActorTableViewController *actorVC = (ActorTableViewController *)self.childViewControllers[2];
    actorVC.actors = movie.actors;
    [actorVC.tableView reloadData];
}


- (void)setupPosterTap
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage)];
    tapGesture.numberOfTapsRequired = 1;
    //    tapGestureRecognizer.delegate = self;
    [self.posterImage addGestureRecognizer:tapGesture];
    self.posterImage.userInteractionEnabled = YES; // default is no for UIImageView
}

- (void)tappedImage
{
    [self performSegueWithIdentifier:@"zoomPopoverSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"zoomPopoverSegue"])
    {
        PosterZoomViewController *posterVC = segue.destinationViewController;
        UIPopoverPresentationController *popover = posterVC.popoverPresentationController;
        popover.delegate = self;
        
        posterVC.imageURL = movie.posterURL;
        
        UIColor *bgColor = [UIColor colorWithHue:0.902 saturation:0.761 brightness:0.527 alpha:1];
        posterVC.view.backgroundColor = bgColor;
        
        posterVC.modalPresentationStyle = UIModalPresentationPopover;
        posterVC.preferredContentSize = CGSizeMake(self.view.frame.size.width * .9, self.view.frame.size.height * .8);
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    double fgHeight = self.foreground.contentSize.height - CGRectGetHeight(self.foreground.bounds);
    double percentageScroll = self.foreground.contentOffset.y / fgHeight;
    double bgHeight = self.background.contentSize.height - CGRectGetHeight(self.background.bounds);
    
    self.background.contentOffset = CGPointMake(0, bgHeight * (percentageScroll * 1.5));
    
    CGPoint contentOffset = CGPointMake(0, bgHeight * (percentageScroll * 0.2));
    
    //review embedded tableview
    ReviewsTableViewController *reviewVC = (ReviewsTableViewController *)self.childViewControllers[0];
    
    //genre embedded tableview
    GenreTableViewController *genreVC = (GenreTableViewController *)self.childViewControllers[1];
    
    //actor embedded tableview
    ActorTableViewController *actorVC = (ActorTableViewController *)self.childViewControllers[2];
    
    reviewVC.tableView.contentOffset = contentOffset;
    genreVC.tableView.contentOffset = contentOffset;
    actorVC.tableView.contentOffset = contentOffset;
}

@end

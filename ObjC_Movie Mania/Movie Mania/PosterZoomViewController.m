//
//  PosterZoomViewController.m
//  Movie Mania
//
//  Created by david on 11/14/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import "PosterZoomViewController.h"
#import "WebController.h"

@interface PosterZoomViewController ()
{
    WebController *webController;
}

@end

@implementation PosterZoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    webController = [[WebController alloc] init];
    webController.posterdelegate = self;
    NSString *urlString = self.imageURL;
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"Searching within posterzoomVC");
    
    [webController findImage:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageWasFound:(UIImage *) image;
{
    self.posterImg.image = image;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

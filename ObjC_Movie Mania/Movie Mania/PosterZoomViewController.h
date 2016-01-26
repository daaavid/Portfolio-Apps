//
//  PosterZoomViewController.h
//  Movie Mania
//
//  Created by david on 11/14/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageProtocol

- (void)imageWasFound:(UIImage *) image;

@end

@interface PosterZoomViewController : UIViewController <ImageProtocol>

@property (weak, nonatomic) NSString *imageURL;
@property (weak, nonatomic) IBOutlet UIImageView *posterImg;

@end

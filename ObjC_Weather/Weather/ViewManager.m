//
//  ViewManager.m
//  Forecaster
//
//  Created by david on 1/25/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "ViewManager.h"

@implementation ViewManager

+ (void)setViewGradient:(UIView *)view colors:(NSArray *)colors
{
    view.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = colors;
    [view.layer insertSublayer:gradient atIndex:0];
}

+ (void)setViewCornerRadius:(UIView *)view cornerRadius:(CGFloat)cornerRadius
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = cornerRadius;
}

+ (void)setViewShadow:(UIView *)view
{
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowOpacity = 0.5;
}

+ (void)addActivitySpinner:(UIView *)view toFrame:(CGRect)frame
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setFrame:CGRectMake(0, 0, 40, 40)];
    [spinner setCenter: CGPointMake(view.center.x, 190)];
    [view addSubview:spinner];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinner startAnimating];
    });
}

@end

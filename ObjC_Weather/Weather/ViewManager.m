//
//  ViewManager.m
//  Forecaster
//
//  Created by david on 1/25/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "ViewManager.h"
#import "TimeOfDay.h"

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

+ (void)setLabelShadow:(UILabel *)label
{
    label.layer.masksToBounds = NO;
    label.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0, 2);
    label.layer.shadowOpacity = 0.5;
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

+ (void)flipViews:(NSArray *)views random:(BOOL)random
{
    BOOL flipView = YES;
    
    for (UIView *view in views)
    {
        if (random)
        {
            flipView = (0 == arc4random_uniform(1));
        }
        
        if (flipView)
        {
            [view setTransform:CGAffineTransformMakeScale(-1, 1)];
        }
    }
}

+ (void)setBackgroundGradientToView:(UIView *)view
{
    NSArray *colors;
    
    if ([TimeOfDay DayOrNight] == Day)
    {
        //a day sky
        //        colors = @[
        //           (id)[[UIColor colorWithRed:0 green:0.02 blue:0.15 alpha:1] CGColor],
        //           (id)[[UIColor colorWithRed:0.01 green:0.49 blue:0.7 alpha:1] CGColor],
        //           (id)[[UIColor colorWithRed:0 green:0.64 blue:0.6 alpha:1] CGColor]
        //           ];
        
        colors = @[
                   (id)[[UIColor colorWithRed:0.22 green:0.67 blue:0.69 alpha:1] CGColor],
                   (id)[[UIColor colorWithRed:0.17 green:0.45 blue:0.64 alpha:1] CGColor],
                   (id)[[UIColor colorWithRed:0.15 green:0.3 blue:0.6 alpha:1] CGColor]
                   ];
    }
    else
    {
        //a night sky
        //        colors = @[
        //          (id)[[UIColor colorWithRed:0 green:0.04 blue:0.08 alpha:1] CGColor],
        //          (id)[[UIColor colorWithRed:0 green:0.1 blue:0.2 alpha:1] CGColor],
        //          (id)[[UIColor colorWithRed:0 green:0.17 blue:0.33 alpha:1] CGColor]
        //          ];
        
        colors = @[
                   (id)[[UIColor colorWithRed:0.45 green:0.13 blue:0.54 alpha:1] CGColor],
                   (id)[[UIColor colorWithRed:0.2 green:0.13 blue:0.51 alpha:1] CGColor],
                   (id)[[UIColor colorWithRed:0.17 green:0.12 blue:0.51 alpha:1] CGColor]
                   ];
        
    }
    
    [self setViewGradient:view colors:colors];
}

+ (UIColor *)setColorBasedOnTimeOfDay
{
    if ([TimeOfDay DayOrNight] == Day)
    {
        return [UIColor colorWithRed:0.17 green:0.45 blue:0.64 alpha:1];
    }
    else
    {
        return [UIColor colorWithRed:0.2 green:0.13 blue:0.51 alpha:1];
    }
}

@end

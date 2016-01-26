//
//  AnimationManager.m
//  Forecaster
//
//  Created by david on 1/24/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "AnimationManager.h"

@implementation AnimationManager

- (instancetype)initWithDelegate:(id <AnimationDidCompleteProtocol>)delegate;
{
    if (self = [super init])
    {
        _delegate = delegate;
    }
    return self;
}

- (void)fadeView:(UIView *)view identifier:(AnimationIdentifier)identifier
{
    if (identifier == FadeIn)
    {
        [view setHidden:NO];
        
        [UIView animateWithDuration:0.25 animations:^{
            [view setAlpha:1];
        } completion:^(BOOL finished) {
            [self.delegate animationDidComplete:view identifier:FadeIn];
        }];
    }
    else if (identifier == FadeOut)
    {
        [UIView animateWithDuration:0.25 animations:^{
            [view setAlpha:0];
        } completion:^(BOOL finished) {
            
            [view setHidden:YES];
            [self.delegate animationDidComplete:view identifier:FadeOut];
        }];
    }
}

- (void)slideToOrigin:(UIView *)view
            fromPoint:(CGFloat)point
            identifier:(AnimationIdentifier)identifier
{
    CGRect originalFrame = view.frame;
    
    [view setAlpha:0];
    
    if (identifier == SlideHorizontally)
    {
        [view setFrame:CGRectMake(point, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
    }
    else if (identifier == SlideVertically)
    {
        [view setFrame:CGRectMake(view.frame.origin.x, point, view.frame.size.width, view.frame.size.height)];
    }
    
    [UIView animateWithDuration:0.35
            delay:0.15
            usingSpringWithDamping:0.7
            initialSpringVelocity:0.5
            options:UIViewAnimationOptionCurveEaseIn
            animations:^{
        
        //animations
        [view setAlpha:1];
        [view setFrame:originalFrame];
        
    } completion:^(BOOL finished) {
        
        [self.delegate animationDidComplete:view identifier:identifier];
        
    }];
}

- (void)animateCornerRadius:(UIView *)view from:(CGFloat)fromFloatValue to:(CGFloat)toFloatValue duration:(CGFloat)duration
{
    NSNumber *fromValue = [NSNumber numberWithFloat:fromFloatValue];
    NSNumber *toValue = [NSNumber numberWithFloat:toFloatValue];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    animation.toValue = toValue;
    animation.fromValue = fromValue;
    animation.duration = duration;
    [view.layer addAnimation:animation forKey:@"cornerRadius"];
    [view.layer setCornerRadius:[toValue floatValue]];
}

- (void)animateTransform:(UIView *)view
              widthScale:(CGFloat)widthScale
              heightScale:(CGFloat)heightScale
              duration:(CGFloat)duration
{
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        view.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        
    } completion:^(BOOL finished) {\
        [self.delegate animationDidComplete:view identifier: Transform];
    }];
}

@end

//
//  AnimationManager.h
//  Forecaster
//
//  Created by david on 1/24/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef enum {
    FadeIn,
    FadeOut,
    SlideVertically,
    SlideHorizontally,
    CornerRadius,
    Transform
}AnimationIdentifier;

@protocol AnimationDidCompleteProtocol
- (void)animationDidComplete:(UIView *)view identifier:(AnimationIdentifier)identifier;
@end

@interface AnimationManager : NSObject

@property (nonatomic) id <AnimationDidCompleteProtocol> delegate;
- (instancetype)initWithDelegate:(id <AnimationDidCompleteProtocol>)delegate;
- (void)fadeView:(UIView *)view identifier:(AnimationIdentifier)identifier;
- (void)slideToOrigin:(UIView *)view
            fromPoint:(CGFloat)point
           identifier:(AnimationIdentifier)identifier;
- (void)animateCornerRadius:(UIView *)view from:(CGFloat)fromFloatValue to:(CGFloat)toFloatValue duration:(CGFloat)duration;
- (void)animateTransform:(UIView *)view
              widthScale:(CGFloat)widthScale
             heightScale:(CGFloat)heightScale
                duration:(CGFloat)duration;

@end

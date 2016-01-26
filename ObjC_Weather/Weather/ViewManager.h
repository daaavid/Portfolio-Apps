//
//  ViewManager.h
//  Forecaster
//
//  Created by david on 1/25/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ViewManager : NSObject

+ (void)setViewGradient:(UIView *)view colors:(NSArray *)colors;
+ (void)setViewCornerRadius:(UIView *)view cornerRadius:(CGFloat)cornerRadius;
+ (void)setViewShadow:(UIView *)view;
+ (void)addActivitySpinner:(UIView *)view toFrame:(CGRect)frame;

@end

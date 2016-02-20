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

//+ (void)setViewGradient:(UIView *)view colors:(NSArray *)colors;
+ (void)setViewCornerRadius:(UIView *)view cornerRadius:(CGFloat)cornerRadius;
+ (void)setViewShadow:(UIView *)view;
+ (void)setLabelShadow:(UILabel *)label;
+ (void)addActivitySpinner:(UIView *)view toFrame:(CGRect)frame;
+ (void)flipViews:(NSArray *)views random:(BOOL)random;
+ (void)setBackgroundGradientToView:(UIView *)view;

@end

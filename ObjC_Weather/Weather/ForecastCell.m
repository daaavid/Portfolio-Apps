//
//  LocationCell.m
//  Forecaster
//
//  Created by david on 1/22/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "ForecastCell.h"

@implementation ForecastCell

- (void)awakeFromNib
{
    self.hasBeenAnimated = NO;
    self.bgView.layer.cornerRadius = 2;
    self.bgView.layer.masksToBounds = NO;
    
    [self addShadow:self.bgView];
}

- (void)addShadow:(UIView *)view
{
    view.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowOpacity = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

//
//  LocationCell.h
//  Forecaster
//
//  Created by david on 1/22/16.
//  Copyright © 2016 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *quickWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgShadowView;

@property (nonatomic) BOOL hasBeenAnimated;

@end

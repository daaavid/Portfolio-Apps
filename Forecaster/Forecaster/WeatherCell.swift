//
//  WeatherCell.swift
//  Forecaster
//
//  Created by david on 10/29/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var quickWeatherLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var img: UIImageView!
    var hasBeenAnimated = false
}

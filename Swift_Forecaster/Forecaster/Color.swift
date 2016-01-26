//
//  Color.swift
//  Forecaster
//
//  Created by david on 10/30/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import Foundation

class colorBasedOnTime
{
    func bgColorBasedOnTime(num: Float) -> [Float]
    {
        let time = Time()
        let hour: Int = time.hour()
        
        var colors = [Float]()
        
        switch hour
        {
        case 1...6:
            colors = colorAdd(0.2 + num)
        case 6...12:
            colors = colorAdd(0.4 + num)
        case 12...18:
            colors = colorAdd(0.2 + num)
        case 18...24:
            colors = colorAdd(0.0 + num)
        default: break
        }
        
        //        let color = UIColor(red: colors[0], green: colors[1], blue: colors[2], alpha: alpha)
        print(colors)
        return colors
    }
    
    func colorAdd(num: Float) -> [Float]
    {
        var colors = [Float]()
        for _ in 1...3
        {
            colors.append(num)
        }
        return colors
    }
}
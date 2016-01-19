//
//  Time.swift
//  Forecaster
//
//  Created by david on 10/30/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import Foundation

class Time
{
    func hour() -> Int
    {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let time = formatter.stringFromDate(NSDate())
        let ampm = time.componentsSeparatedByString(" ")[1]
        var hour = Int(time.componentsSeparatedByString(":")[0])!
        
        if ampm == "PM"
        {
            hour += 12
        }
        
        return hour
    }
}
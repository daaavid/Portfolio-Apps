//
//  Weather.swift
//  Forecaster
//
//  Created by david on 10/29/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import Foundation

class Weather
{
    let temp                : Int
    let apparentTemp        : Int
    
    let summary             : String
    var icon                : String
    
    let precipProbability   : Double
    let precipIntensity     : Double
    
    let windSpeed           : Double
    
    let humidity            : Double
    let visibility          : Double
    let cloudCover          : Double
    
    let weeksummary         : String
    
    let day0summary         : String
    let day1summary         : String
    let day2summary         : String
    let day3summary         : String
    let day4summary         : String
    let day5summary         : String
    let day6summary         : String
    
    let day0icon            : String
    let day1icon            : String
    let day2icon            : String
    let day3icon            : String
    let day4icon            : String
    let day5icon            : String
    let day6icon            : String
    
    let day0tempMin         : Int
    let day1tempMin         : Int
    let day2tempMin         : Int
    let day3tempMin         : Int
    let day4tempMin         : Int
    let day5tempMin         : Int
    let day6tempMin         : Int
    
    let day0tempMax         : Int
    let day1tempMax         : Int
    let day2tempMax         : Int
    let day3tempMax         : Int
    let day4tempMax         : Int
    let day5tempMax         : Int
    let day6tempMax         : Int
    
    init(
        summary             : String,
        icon                : String,
        precipIntensity     : Double,
        precipProbability   : Double,
        temperature         : Int,
        apparentTemp        : Int,
        humidity            : Double,
        windSpeed           : Double,
        visibility          : Double,
        cloudCover          : Double,
        
        weeksummary         : String,
            
        day0summary         : String,
        day1summary         : String,
        day2summary         : String,
        day3summary         : String,
        day4summary         : String,
        day5summary         : String,
        day6summary         : String,
            
        day0icon            : String,
        day1icon            : String,
        day2icon            : String,
        day3icon            : String,
        day4icon            : String,
        day5icon            : String,
        day6icon            : String,
            
        day0tempMin         : Int,
        day1tempMin         : Int,
        day2tempMin         : Int,
        day3tempMin         : Int,
        day4tempMin         : Int,
        day5tempMin         : Int,
        day6tempMin         : Int,
            
        day0tempMax         : Int,
        day1tempMax         : Int,
        day2tempMax         : Int,
        day3tempMax         : Int,
        day4tempMax         : Int,
        day5tempMax         : Int,
        day6tempMax         : Int
        )
    {
        self.summary            = summary
        self.icon               = icon
        self.precipIntensity    = precipIntensity
        self.precipProbability  = precipProbability
        self.temp               = temperature
        self.apparentTemp       = apparentTemp
        self.humidity           = humidity
        self.windSpeed          = windSpeed
        self.visibility         = visibility
        self.cloudCover         = cloudCover
        
        self.weeksummary        = weeksummary
        
        self.day0summary        = day0summary
        self.day0icon           = day0icon
        self.day0tempMin        = day0tempMin
        self.day0tempMax        = day0tempMax
        
        self.day1summary        = day1summary
        self.day1icon           = day1icon
        self.day1tempMin        = day1tempMin
        self.day1tempMax        = day1tempMax
        
        self.day2summary        = day2summary
        self.day2icon           = day2icon
        self.day2tempMin        = day2tempMin
        self.day2tempMax        = day2tempMax
        
        self.day3summary        = day3summary
        self.day3icon           = day3icon
        self.day3tempMin        = day3tempMin
        self.day3tempMax        = day3tempMax
        
        self.day4summary        = day4summary
        self.day4icon           = day4icon
        self.day4tempMin        = day4tempMin
        self.day4tempMax        = day4tempMax
        
        self.day5summary        = day5summary
        self.day5icon           = day5icon
        self.day5tempMin        = day5tempMin
        self.day5tempMax        = day5tempMax
        
        self.day6summary        = day6summary
        self.day6icon           = day6icon
        self.day6tempMin        = day6tempMin
        self.day6tempMax        = day6tempMax
    }
    
    static func weatherWithJSON(results: NSDictionary) -> Weather?
    {
        var weather: Weather!
        
        //currently
        
        let currently       = results["currently"]              as? NSDictionary ?? NSDictionary()
        
        let summary         = currently["summary"]              as? String ?? ""
        let icon            = currently["icon"]                 as? String ?? ""
        let precipIntensity = currently["precipIntensity"]      as? Double ?? 0.0
        let humid           = currently["dewPoint"]             as? Double ?? 0.0
        let windSpeed       = currently["windSpeed"]            as? Double ?? 0.0
        let visibility      = currently["visibility"]           as? Double ?? 0.0
        let cloudCover      = currently["cloudCover"]           as? Double ?? 0.0
        
        let apparentTemp    = tempAsInt(currently["apparentTemperature"] as? Double ?? 0.0)
        let temperature     = tempAsInt(currently["temperature"]         as? Double ?? 0.0)
        
        //daily
        
        if let daily           = results["daily"]                   as? NSDictionary
        {
            let weeksummary     = daily["summary"]                  as? String ?? ""
            
            let data            = daily["data"]                     as? NSArray ?? NSArray()
            
            let day0            = data[0]                           as? NSDictionary ?? NSDictionary()
            
            let precipProb      = day0["precipProbability"]         as? Double ?? 0.0 //<<
            
            let day0icon        = day0["icon"]                      as? String ?? ""
            let day0summary     = day0["summary"]                   as? String ?? ""
            
            let day0tempMin     = tempAsInt(day0["temperatureMin"]  as? Double ?? 0.0)
            let day0tempMax     = tempAsInt(day0["temperatureMin"]  as? Double ?? 0.0)
            
            
            
            let day1            = data[1]                           as? NSDictionary ?? NSDictionary()
            
            let day1icon        = day1["icon"]                      as? String ?? ""
            let day1summary     = day1["summary"]                   as? String ?? ""
            
            let day1tempMin     = tempAsInt(day1["temperatureMin"]  as? Double ?? 0.0)
            let day1tempMax     = tempAsInt(day1["temperatureMin"]  as? Double ?? 0.0)
            
            
            
            let day2            = data[2]                           as? NSDictionary ?? NSDictionary()
            
            let day2icon        = day2["icon"]                      as? String ?? ""
            let day2summary     = day2["summary"]                   as? String ?? ""
            
            let day2tempMin     = tempAsInt(day2["temperatureMin"]  as? Double ?? 0.0)
            let day2tempMax     = tempAsInt(day2["temperatureMin"]  as? Double ?? 0.0)
            
            
            
            let day3            = data[3]                           as? NSDictionary ?? NSDictionary()
            
            let day3icon        = day3["icon"]                      as? String ?? ""
            let day3summary     = day3["summary"]                   as? String ?? ""
            
            let day3tempMin     = tempAsInt(day3["temperatureMin"]  as? Double ?? 0.0)
            let day3tempMax     = tempAsInt(day3["temperatureMin"]  as? Double ?? 0.0)
            
            
            
            let day4            = data[4]                           as? NSDictionary ?? NSDictionary()
            
            let day4icon        = day4["icon"]                      as? String ?? ""
            let day4summary     = day4["summary"]                   as? String ?? ""
            
            let day4tempMin     = tempAsInt(day4["temperatureMin"]  as? Double ?? 0.0)
            let day4tempMax     = tempAsInt(day4["temperatureMin"]  as? Double ?? 0.0)
            
            
            
            let day5            = data[5]                           as? NSDictionary ?? NSDictionary()
            
            let day5icon        = day5["icon"]                      as? String ?? ""
            let day5summary     = day5["summary"]                   as? String ?? ""
            
            let day5tempMin     = tempAsInt(day5["temperatureMin"]  as? Double ?? 0.0)
            let day5tempMax     = tempAsInt(day5["temperatureMin"]  as? Double ?? 0.0)
            
            
            
            let day6            = data[6]                           as? NSDictionary ?? NSDictionary()
            
            let day6icon        = day6["icon"]                      as? String ?? ""
            let day6summary     = day6["summary"]                   as? String ?? ""
            
            let day6tempMin     = tempAsInt(day6["temperatureMin"]  as? Double ?? 0.0)
            let day6tempMax     = tempAsInt(day6["temperatureMin"]  as? Double ?? 0.0)
            
            
            
            weather = Weather(
                summary             : summary,
                icon                : icon,
                precipIntensity     : precipIntensity,
                precipProbability   : precipProb,
                temperature         : temperature,
                apparentTemp        : apparentTemp,
                humidity            : humid,
                windSpeed           : windSpeed,
                visibility          : visibility,
                cloudCover          : cloudCover,
                
                weeksummary         : weeksummary,
                day0summary         : day0summary,
                day1summary         : day1summary,
                day2summary         : day2summary,
                day3summary         : day3summary,
                day4summary         : day4summary,
                day5summary         : day5summary,
                day6summary         : day6summary,
                
                day0icon            : day0icon,
                day1icon            : day1icon,
                day2icon            : day2icon,
                day3icon            : day3icon,
                day4icon            : day4icon,
                day5icon            : day5icon,
                day6icon            : day6icon,
                
                day0tempMin         : day0tempMin,
                day1tempMin         : day1tempMin,
                day2tempMin         : day2tempMin,
                day3tempMin         : day3tempMin,
                day4tempMin         : day4tempMin,
                day5tempMin         : day5tempMin,
                day6tempMin         : day6tempMin,
                
                day0tempMax         : day0tempMax,
                day1tempMax         : day1tempMax,
                day2tempMax         : day2tempMax,
                day3tempMax         : day3tempMax,
                day4tempMax         : day4tempMax,
                day5tempMax         : day5tempMax,
                day6tempMax         : day6tempMax
            )
            
            return weather
        }
        else
        {
            return nil
        }

    }

    static func tempAsInt(temp: Double) -> Int
    {
        var fullTemp = String(temp).componentsSeparatedByString(".")
        var firstNum = Double(fullTemp[0])
        if Double(fullTemp[1]) > 50
        {
            firstNum! += 1
        }
        
        return Int(firstNum!)
    }
}


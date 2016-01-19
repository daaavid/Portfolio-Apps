//
//  Settings.swift
//  Philosophone
//
//  Created by david on 12/4/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import Foundation

let kHourKey = "Hour"
let kCategoriesKey = "Categories"
let kSoundKey = "Sound"

class Settings: NSObject, NSCoding
{
    var hour: Int
    var categories: [String]
    var sound: Bool
    
    init(hour: Int, categories: [String], sound: Bool)
    {
        self.hour = hour
        self.categories = categories
        self.sound = sound
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard
            let hour = decoder.decodeObjectForKey(kHourKey) as? Int,
            let categories = decoder.decodeObjectForKey(kCategoriesKey) as? [String],
            let sound = decoder.decodeObjectForKey(kSoundKey) as? Bool
        else
        {
            return nil
        }
        
        self.init(hour: hour, categories: categories, sound: sound)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.hour, forKey: kHourKey)
        coder.encodeObject(self.categories, forKey: kCategoriesKey)
        coder.encodeObject(self.sound, forKey: kSoundKey)
    }
}
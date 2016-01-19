//
//  TypewriterClack.swift
//  Philosophone
//
//  Created by david on 12/5/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import Foundation
import AVFoundation

class TypewriterClack
{
    func playSound(identifier: String)
    {
        if GLOBAL_SETTINGS?.sound == true
        {
            var soundURL = NSURL()
            let randomClack = String(Int(arc4random() % 25) + 1)
            
            switch identifier
            {
            case "soft"    : soundURL = NSBundle.mainBundle().URLForResource(randomClack, withExtension: "wav")!
            case "ding"    : soundURL = NSBundle.mainBundle().URLForResource("ding", withExtension: "wav")!
//            case "harsh"   : soundURL = NSBundle.mainBundle().URLForResource("typewriter_harsh", withExtension: "wav")!
            default        : soundURL = NSBundle.mainBundle().URLForResource(randomClack, withExtension: "wav")!
            }
            
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &soundID)
            AudioServicesPlaySystemSound(soundID);
        }
    }
}
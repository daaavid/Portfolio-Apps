//
//  UIViewExtensions.swift
//  Contacts
//
//  Created by david on 11/22/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

extension UIView
{
    //https://www.andrewcbancroft.com/2014/10/15/rotate-animation-in-swift/
    func rotate360Degrees(duration: CFTimeInterval = 0.3, completionDelegate: AnyObject? = nil)
    {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}

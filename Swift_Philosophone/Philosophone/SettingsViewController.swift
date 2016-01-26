//
//  SettingsViewController.swift
//  Philosophone
//
//  Created by david on 12/4/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

protocol QuoteDidCompleteTypingDelegate
{
    func enableGetQuoteButton()
}

class SettingsViewController: UIViewController, UIPopoverPresentationControllerDelegate, QuoteDidCompleteTypingDelegate
{
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var soundOnOffLabel: UILabel!
    @IBOutlet weak var typeQuoteAgainLabel: UILabel!
    @IBOutlet weak var getNewQuoteLabel: UILabel!

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    @IBOutlet weak var typeQuoteAgainButton: UIButton!
    @IBOutlet weak var getNewQuoteButton: UIButton!

    let sound = TypewriterClack()
    
    var delegate: SettingsChangedDelegate!
    
    var presses: Int!
    
    var hours = [
        6,
        8,
        10,
        12,
        14,
        16,
        18,
        20,
        22,
        24,
        0
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let mainVC = navigationController?.viewControllers[0] as! MainViewController
        delegate = mainVC
        
        presses = hours.indexOf(GLOBAL_SETTINGS!.hour)!
        print(presses)
        
        setHourLabel()
        
        setSoundLabel()
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        typeQuoteAgainLabel.alpha = 0
        getNewQuoteLabel.alpha = 0
        getNewQuoteButton.enabled = false
        typeQuoteAgainButton.enabled = true
        
        creditLabel.text = "Powered by api.theysaidso.com\nfreesound.org/people/soundslikewillem"
        
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "enableGetQuoteButton", userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        sound.playSound("ding")
    }
    
    @IBAction func categoriesButtonTapped(sender: UIButton)
    {
        sound.playSound("harsh")
        
        performSegueWithIdentifier("categoriesPopover", sender: nil)
    }

    @IBAction func hourButtonTapped(sender: UIButton)
    {
        presses = presses + 1
        
        if presses >= hours.count
        {
            presses = 0
        }
        
        GLOBAL_SETTINGS?.hour = hours[presses]

        setHourLabel()
        
        delegate.settingsDidChange()
        
        sound.playSound("harsh")
    }
    
    @IBAction func soundButtonTapped(sender: UIButton)
    {
        if soundOnOffLabel.text == "On"
        {
            soundOnOffLabel.text = "Off"
            GLOBAL_SETTINGS?.sound = false
        }
        else
        {
            soundOnOffLabel.text = "On"
            GLOBAL_SETTINGS?.sound = true
        }
        
        sound.playSound("harsh")
    }
    
    @IBAction func typeQuoteAgainButtonTapped(sender: UIButton)
    {
        typeQuoteAgainButton.enabled = false
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.typeQuoteAgainLabel.alpha = 1
        })
        
        delegate.typeQuoteAgain()
        
        sound.playSound("harsh")
    }
    
    @IBAction func getNewQuoteButtonTapped(sender: UIButton)
    {
        getNewQuoteButton.enabled = false
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.getNewQuoteLabel.alpha = 1
            self.creditLabel.alpha = 0
            self.warningLabel.alpha = 1
        })
        
        TODAY_QUOTE = nil
        
        delegate.typeQuoteAgain()
        
        sound.playSound("harsh")
    }
    
    
    func setHourLabel()
    {
        var hour = GLOBAL_SETTINGS!.hour
        
        var suffix = " A.M."
        
        if hour >= 12
        {
            suffix = " P.M."
            
            if hour == 24
            {
                suffix = " A.M."
            }
            
            if hour > 12
            {
                hour -= 12
            }
        }
        
        hourLabel.text = String(hour) + suffix
        
        if hour == 0
        {
            hourLabel.text = "Never"
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    
    func setSoundLabel()
    {
        switch GLOBAL_SETTINGS!.sound
        {
        case true   : soundOnOffLabel.text = "On"
        case false  : soundOnOffLabel.text = "Off"
        }
    }
    
    func enableGetQuoteButton()
    {
        print("enabled quote button")
        getNewQuoteButton.enabled = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "categoriesPopover"
        {
            let categoriesPopover = segue.destinationViewController as! CategoriesPopoverTableViewController
            categoriesPopover.popoverPresentationController?.delegate = self
            let contentHeight = 44.0 * CGFloat(categoriesPopover.categoriesDictionary.keys.count)
            categoriesPopover.preferredContentSize = CGSizeMake(200.0, contentHeight)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }
}

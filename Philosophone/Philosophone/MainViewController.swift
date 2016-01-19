//
//  ViewController.swift
//  Philosophone
//
//  Created by david on 12/4/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit
import AVFoundation

var GLOBAL_SETTINGS = Settings?()
var TODAY_QUOTE = Quote?()
var TOMORROW_QUOTE = Quote?()

var TEST_MODE = true //<<<<<<

var shouldPlayTypingSound = true

let kSettingsKey = "Settings"

protocol APIControllerProtocol
{
    func quoteWasFound(quoteDict: NSDictionary?)
}

protocol TypedCharacterTextDelegate
{
    func quoteFinishedTyping()
}

protocol SettingsChangedDelegate
{
    func settingsDidChange()
    func typeQuoteAgain()
}

class MainViewController: UIViewController, APIControllerProtocol, TypedCharacterTextDelegate, SettingsChangedDelegate
{
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var wordDivider: UILabel!
    
    @IBOutlet weak var notificationSetLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    var apiController: APIController?
    
    let sound = TypewriterClack()
    
    var shouldTypeQuote = true
    var getNewQuoteForToday = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        settingsButton.alpha = 0
        
        if TEST_MODE
        {
            makeTestQuote()
        }
        
        if GLOBAL_SETTINGS == nil
        {
            let categories = [
                "inspire",
                "management",
                "sports",
                "life",
                "funny",
                "love",
                "art"
            ]
            
            GLOBAL_SETTINGS = Settings(hour: 6, categories: categories, sound: true)
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        settingsButton.slideVerticallyToOriginAndSpin(0.75, fromPointY: settingsButton.frame.height * 2, spin: true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        shouldPlayTypingSound = true
        
        if shouldTypeQuote
        {
            quoteLabel.text = ""
            authorLabel.text = ""
            wordDivider.alpha = 0
            
            NSTimer.scheduledTimerWithTimeInterval(1.25, target: self, selector: "performSetup", userInfo: nil, repeats: false)
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        settingsButton.alpha = 0
        
        shouldPlayTypingSound = false
    }
    
    func makeTestQuote()
    {
        let quote = "The only thing necessary for the triumph of evil is for good men to do nothing."
        let author = "Edmund Burke"
        
        TODAY_QUOTE = Quote(quote: quote, author: author)
    }
    
    func performSetup()
    {
        quoteLabel.text = ""
        authorLabel.text = ""
        wordDivider.alpha = 0
        
        if TODAY_QUOTE != nil && shouldTypeQuote == true
        {
            let text = "“" + TODAY_QUOTE!.quote + "”"
            quoteLabel.typeText(text, interval: 0.035, delegate: self)
            
            shouldTypeQuote = false
        }
        else if TODAY_QUOTE == nil
        {
            getNewQuoteForToday = true
            
            apiController = APIController(delegate: self)
            apiController?.getQuote(GLOBAL_SETTINGS!.categories)
        }
        
        setNotification()
    }
    
    func quoteWasFound(quoteDict: NSDictionary?)
    {
        print("quote was found")
        
        if quoteDict != nil
        {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in

                if self.getNewQuoteForToday == false
                {
                    TOMORROW_QUOTE = Quote.quoteFromAPIResults(quoteDict!)
                    print(TOMORROW_QUOTE)
                    self.setNotification()
                }
                else
                {
                    TODAY_QUOTE = Quote.quoteFromAPIResults(quoteDict!)
                    print(TODAY_QUOTE)
                    self.getNewQuoteForToday = false
                    self.performSetup()
                }
            }
        }
        else
        {
            let errorMessage = "“Could not pull quote from server. Please try again later. Apologies.”"
            quoteLabel.typeText(errorMessage, interval: 0.035, delegate: nil)
        }
    }
    
    func quoteFinishedTyping()
    {
        if authorLabel.text == ""
        {
            wordDivider.appearWithFade(0.25)
            
            let global_queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
            dispatch_async(global_queue) { () -> Void in
                NSThread.sleepForTimeInterval(0.75)
                
                self.authorLabel.typeText(TODAY_QUOTE!.author, interval: 0.15, delegate: self)
            }
        }
        else if shouldPlayTypingSound
        {
            sound.playSound("ding")
        }
    }
    
    func setNotification()
    {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        if TOMORROW_QUOTE == nil
        {
            print("TOMORROW_QUOTE == nil")
            
            apiController = APIController(delegate: self)
            apiController?.getQuote(GLOBAL_SETTINGS!.categories)
        }
        else if GLOBAL_SETTINGS!.hour != 0
        {
                //new notification
                let newNotification = UILocalNotification()
                
                newNotification.alertBody = "\(TOMORROW_QUOTE!.quote) - \n\(TOMORROW_QUOTE!.author)\nTap to schedule tomorrow's quote."
                
                newNotification.alertTitle = "Philosophone"
            
                newNotification.timeZone = NSTimeZone.localTimeZone()
                newNotification.fireDate = notificationFireDate()
                newNotification.repeatInterval = .Day
                
                if TEST_MODE
                {
                    newNotification.fireDate = NSDate(timeInterval: 10, sinceDate: NSDate()) //<<<<<<<<<<<<<<<<<<<<<
                }
                
                print("notification scheduled \(newNotification) -- ")
                
                UIApplication.sharedApplication().scheduleLocalNotification(newNotification)
                
                if let count = UIApplication.sharedApplication().scheduledLocalNotifications?.count
                {
                    print("\(count) notification(s) scheduled")
                    print(newNotification.alertBody)
                    showNotificationSetLabel()
                }
        }
    }
    
    func notificationFireDate() -> NSDate?
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = NSDateComponents()
        components.hour = GLOBAL_SETTINGS!.hour
        components.timeZone = NSTimeZone.defaultTimeZone()
        
        let fireDate = calendar!.dateFromComponents(components)
        print(fireDate)
        return fireDate
    }
    
    func notificationPopped()
    {
        //clear out old quote and get a new one
        print("notificationPopped")
        
        TODAY_QUOTE = TOMORROW_QUOTE
        TOMORROW_QUOTE = nil
        
        shouldTypeQuote = true
        
        if view.window != nil
        {
            //if notification pops and window is in focus, perform setup after 1s delay
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "performSetup", userInfo: nil, repeats: false)
        }
    }
    
    func showNotificationSetLabel()
    {
        print("showNotificationSetLabel")
        self.notificationSetLabel.alpha = 0
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.notificationSetLabel.alpha = 1
            }) { (_) -> Void in
                UIView.animateWithDuration(0.5, delay: 3.0, options: [], animations: { () -> Void in
                    self.notificationSetLabel.alpha = 0
                    }, completion: nil)
        }
    }
    
    // // // // // MARK: - Settings
    
    // MARK: - Action Handlers
    
    @IBAction func settingsButtonTapped(sender: UIButton)
    {
        settingsButton.spin()
        
        sound.playSound("harsh")
        
        performSegueWithIdentifier("showSettingsSegue", sender: self)
    }
    
    @IBAction func settingsButtonPressedDown(sender: UIButton)
    {
        settingsButton.spin()
    }
    
    // MARK: - Settings Delegates
    
    func settingsDidChange()
    {
        setNotification()
    }
    
    func typeQuoteAgain()
    {
        shouldTypeQuote = true
    }
    
    // MARK: - Save, Load
    
    func saveSettings()
    {
        let data = NSKeyedArchiver.archivedDataWithRootObject(GLOBAL_SETTINGS!)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: kSettingsKey)
        
        print("saved settings: ", GLOBAL_SETTINGS!)
    }
    
    func loadSettings()
    {
        let standardUserDefaults = NSUserDefaults.standardUserDefaults()
        if let data = standardUserDefaults.objectForKey(kSettingsKey) as? NSData
        {
            if let savedSettings = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Settings
            {
                GLOBAL_SETTINGS = savedSettings
                print("loaded settings: ", savedSettings)
            }
        }
    }
}

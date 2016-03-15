//
//  WeekForecastTableViewController.swift
//  Forecaster
//
//  Created by david on 10/31/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

class WeekForecastTableViewController: UITableViewController
{
    var location = Location?()
    
    @IBOutlet var weekSummaryLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        weekSummaryLabel.text = location?.weather?.weeksummary

        view.backgroundColor = UIColor(red: 0.0, green: 0.65, blue: 0.86, alpha: 1.0)
        
        let sampleArray: NSMutableArray = [];
        
        for _ in sampleArray
        {
            
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ForecastCell", forIndexPath: indexPath) as! ForecastCell
        cell.backgroundColor = UIColor.clearColor()
        
        let day = getDayOfWeek()
        
        switch indexPath.row
        {
        case 0:
            assignWeatherImg(cell, icon: location!.weather!.day0icon, location: location!)
            cell.daySummaryLabel.text = location!.weather!.day0summary
            cell.tempMinLabel.text = String(location!.weather!.day0tempMin) + "°-"
            cell.tempMaxLabel.text = String(location!.weather!.day0tempMax) + "°"
            cell.dayLabel.text = "Today"
        case 1:
            assignWeatherImg(cell, icon: location!.weather!.day1icon, location: location!)
            cell.daySummaryLabel.text = location!.weather!.day1summary
            cell.tempMinLabel.text = String(location!.weather!.day1tempMin) + "°-"
            cell.tempMaxLabel.text = String(location!.weather!.day1tempMax) + "°"
            cell.dayLabel.text = assignDay(day + 1)
        case 2:
            assignWeatherImg(cell, icon: location!.weather!.day2icon, location: location!)
            cell.daySummaryLabel.text = location!.weather!.day2summary
            cell.tempMinLabel.text = String(location!.weather!.day2tempMin) + "°-"
            cell.tempMaxLabel.text = String(location!.weather!.day2tempMax) + "°"
            cell.dayLabel.text = assignDay(day + 2)
        case 3:
            assignWeatherImg(cell, icon: location!.weather!.day3icon, location: location!)
            cell.daySummaryLabel.text = location!.weather!.day3summary
            cell.tempMinLabel.text = String(location!.weather!.day3tempMin) + "°-"
            cell.tempMaxLabel.text = String(location!.weather!.day3tempMax) + "°"
            cell.dayLabel.text = assignDay(day + 3)
        case 4:
            assignWeatherImg(cell, icon: location!.weather!.day4icon, location: location!)
            cell.daySummaryLabel.text = location!.weather!.day4summary
            cell.tempMinLabel.text = String(location!.weather!.day4tempMin) + "°-"
            cell.tempMaxLabel.text = String(location!.weather!.day4tempMax) + "°"
            cell.dayLabel.text = assignDay(day + 4)
        case 5:
            assignWeatherImg(cell, icon: location!.weather!.day5icon, location: location!)
            cell.daySummaryLabel.text = location!.weather!.day5summary
            cell.tempMinLabel.text = String(location!.weather!.day5tempMin) + "°-"
            cell.tempMaxLabel.text = String(location!.weather!.day5tempMax) + "°"
            cell.dayLabel.text = assignDay(day + 5)
        case 6:
            assignWeatherImg(cell, icon: location!.weather!.day6icon, location: location!)
            cell.daySummaryLabel.text = location!.weather!.day6summary
            cell.tempMinLabel.text = String(location!.weather!.day6tempMin) + "°-"
            cell.tempMaxLabel.text = String(location!.weather!.day6tempMax) + "°"
            cell.dayLabel.text = assignDay(day + 6)
        default: break
        }
        
        return cell
    }
    
    func assignWeatherImg(cell: ForecastCell, icon: String, location: Location)
    {
        cell.img.image = UIImage(named: icon)
        animateWeatherImg(cell, location: location)
    }

    func animateWeatherImg(cell: ForecastCell, location: Location)
    {
        UIView.animateWithDuration(0.5, delay: 0.0, options: [], animations:
            {
                var img = cell.img.frame
                img.origin.x += img.size.width + 100
                
                cell.daySummaryLabel.frame = img
                cell.tempMinLabel.frame = img
                cell.tempMaxLabel.frame = img
                
                cell.img.frame = img
            }, completion: nil)
    }
    
    func getDayOfWeek() -> Int
    {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(NSCalendarUnit.Weekday, fromDate: NSDate())
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    func assignDay(var day: Int) -> String
    {
        if day > 7
        {
            day -= 7
        }
        
        var dayStr = ""
        switch day
        {
        case 1: dayStr = "Sunday"
        case 2: dayStr = "Monday"
        case 3: dayStr = "Tuesday"
        case 4: dayStr = "Wednesday"
        case 5: dayStr = "Thursday"
        case 6: dayStr = "Friday"
        case 7: dayStr = "Saturday"
        default: dayStr = "Everday"
        }
        
        return dayStr
    }
}

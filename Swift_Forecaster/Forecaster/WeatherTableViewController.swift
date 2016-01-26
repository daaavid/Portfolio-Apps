//
//  WeatherTableViewController.swift
//  Forecaster
//
//  Created by david on 10/29/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

let kLocationKey = "location"

protocol ZipPopViewControllerDelegate
{
    func zipWasChosen(zip: String, cc: String)
}

protocol DarkSkyAPIControllerProtocol
{
    func darkSkySearchWasCompleted(results: NSDictionary, location: Location)
    //    func darkSkySearchWasCompleted(results: NSDictionary)
}

protocol GoogleZipAPIControllerProtocol
{
    func googleSearchWasCompleted(results: NSArray)
}

class WeatherTableViewController: UITableViewController, ZipPopViewControllerDelegate, UIPopoverPresentationControllerDelegate, DarkSkyAPIControllerProtocol, GoogleZipAPIControllerProtocol
{
    var locationArr = [Location]()
    var googleAPI: GoogleZipAPIController!
    
//    var darkskyAPI: DarkSkyAPIController!
//    var weatherDetailVC: WeatherDetailViewController!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        editButtonItem().tintColor = UIColor(red:0.00, green:0.75, blue:1.00, alpha:1.0)
        editButtonItem()

        view.backgroundColor = UIColor(red: 0.0, green: 0.65, blue: 0.86, alpha: 1.0)

        if locationArr.count == 0
        {
            zipWasChosen(String(32801), cc: "zip")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationArr.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath) as! WeatherCell
        cell.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        
        let location = locationArr[indexPath.row]
        
        if location.city == ""
        {
            locationArr.removeAtIndex(indexPath.row)
            tableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        else if location.city != ""
        {
            cell.cityLabel.text = location.city + ", " + location.state
            cell.quickWeatherLabel.text = location.weather?.summary
            if location.weather?.temp != nil
            {
                cell.tempLabel.text = String(location.weather!.temp) + "°"
                assignWeatherImg(cell, icon: location.weather!.icon, location: location)
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let chosenLocation = locationArr[indexPath.row]
        
        let weatherDetailVC = storyboard?.instantiateViewControllerWithIdentifier("WeatherDetail") as! WeatherDetailViewController
        
        weatherDetailVC.location = chosenLocation
        
        navigationController?.pushViewController(weatherDetailVC, animated: true)
    }
    
    //MARK: - View
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "popover"
        {
            let popVC = segue.destinationViewController as! ZipPopViewController
            popVC.popoverPresentationController?.delegate = self
            popVC.delegate = self
            popVC.locationArr = self.locationArr
            
//            popVC.view.backgroundColor = UIColor.whiteColor()
            popVC.preferredContentSize = CGSizeMake(280, 100)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }
    
    //MARK: - Images and Animation
    
    func assignWeatherImg(cell: WeatherCell, icon: String, location: Location)
    {
        cell.img.image = UIImage(named: location.weather!.icon)
        animateWeatherImg(cell, location: location)
    }
    
    func animateWeatherImg(cell: WeatherCell, location: Location)
    {
        if location.imgHasBeenAnimated == false
        {
            UIView.animateWithDuration(0.5, delay: 0.0, options: [], animations:
                {
                    var img = cell.img.frame
                    img.origin.x += img.size.width + 100
                    
                    cell.quickWeatherLabel.frame = img
                    cell.tempLabel.frame = img
                    cell.img.frame = img
                }, completion: nil)
            location.imgHasBeenAnimated = true
        }
    }

    //MARK: - Private
    
    func zipWasChosen(zip: String, cc: String)
    {
        googleAPI = GoogleZipAPIController(delegate: self)
        print(zip, cc)
        googleAPI.search(zip, cc: cc)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    // MARK: - Search
    
    func googleSearchWasCompleted(results: NSArray)
    {
        dispatch_async(dispatch_get_main_queue(),
        {
            self.dismissViewControllerAnimated(true, completion: nil)

            let userLocation = Location.locationWithJSON(results)
            self.locationArr.append(userLocation)
                
            let darkSkyAPI = DarkSkyAPIController(delegate: self)
            darkSkyAPI.search(userLocation)
            self.tableView.reloadData()
        })
    }
    
    func darkSkySearchWasCompleted(results: NSDictionary, location: Location)
    {
        dispatch_async(dispatch_get_main_queue(),
        {
            if let weather = Weather.weatherWithJSON(results)
            {
                for city in self.locationArr
                {
                    if city.city == location.city
                    {
                        city.weather = weather
                    }
                }
            }
            
            self.tableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            locationArr.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func loadCityData() -> Bool
    {
        var rc = true
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(kLocationKey) as? NSData
        {
            if let savedLocations = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Location]
            {
                locationArr = savedLocations
                rc = false
                tableView.reloadData()
                
                let darkSkyAPI = DarkSkyAPIController(delegate: self)
                
                for location in locationArr
                {
                    darkSkyAPI.search(location)
                }
            }
        }
        return rc
    }
    
    func saveCityData()
    {
        let locationData = NSKeyedArchiver.archivedDataWithRootObject(locationArr)
        NSUserDefaults.standardUserDefaults().setObject(locationData, forKey: kLocationKey)
    }
}

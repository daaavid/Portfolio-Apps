//
//  ZipPopViewController.swift
//  Forecaster
//
//  Created by david on 10/29/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit
import CoreLocation

class ZipPopViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet var zipCitySegmentedControl: UISegmentedControl!
//    @IBOutlet weak var useCurrentLocButton: UIButton!
    @IBOutlet weak var goButton: UIButton!

    var delegate: ZipPopViewControllerDelegate?
    var edit = false
    var locationArr = [Location]()
    var alreadyAdded = false
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if zipTextField.text! == ""
        {
            zipTextField.becomeFirstResponder()
            zipTextField.addTarget(self, action:"startedEditing", forControlEvents:UIControlEvents.EditingChanged)
        }
        // Do any additional setup after loading the view.
        
        configureLocationManager()
        zipCitySegmentedControl.setEnabled(false, forSegmentAtIndex: 2)
//        useCurrentLocButton.enabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureLocationManager()
    {
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Denied && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Restricted
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined
            {
                locationManager.requestWhenInUseAuthorization()
            }
            else
            {
//                useCurrentLocButton.enabled = true
            zipCitySegmentedControl.setEnabled(true, forSegmentAtIndex: 2)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse
        {
//            useCurrentLocButton.enabled = true
            zipCitySegmentedControl.setEnabled(true, forSegmentAtIndex: 2)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print(error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last //last location in array
        geocoder.reverseGeocodeLocation(location!, completionHandler: {(placemark: [CLPlacemark]?, error: NSError?) -> Void in
            
            if error != nil
            {
                print(error?.localizedDescription)
            }
            else
            {
                self.locationManager.stopUpdatingLocation()
                let cityName = placemark?[0].locality
                print(cityName!)
                let zipCode = placemark?[0].postalCode
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                for location in self.locationArr
                {
                    if cityName == location.city
                    {
                        self.zipTextField.text = ""
                        self.zipTextField.placeholder = "Location already added"
                        self.goButton.enabled = true
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.alreadyAdded = true
                    }
                }
                
                if self.alreadyAdded == false
                {
                    self.search(zipCode!)
                }
            }
        })
    }
    
    func findLocationForZipCode(zipCode: String)
    {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        var rc = false
        if checkTextField(textField.text!)
        {
            search(textField.text!)
            rc = true
        }
        return rc
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        edit = true
    }
    
    func startedEditing()
    {
        if zipTextField.text!.characters.count == 1
        {
            if Int(zipTextField.text!) != nil
            {
                zipCitySegmentedControl.selectedSegmentIndex = 0
                changeKeyboard(0)
            }
            else
            {
                zipCitySegmentedControl.selectedSegmentIndex = 1
                changeKeyboard(1)
            }
        }
        else if zipTextField.text! == ""
        {
            setPlaceholderText()
        }
    }
    
    @IBAction func zipCitySegmentedControl(sender: UISegmentedControl)
    {
        goButton.enabled = true
        
        switch zipCitySegmentedControl.selectedSegmentIndex
        {
        case 0:
            changeKeyboard(0)
        case 1:
            changeKeyboard(1)
        case 2:
            zipTextField.resignFirstResponder()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            locationManager.startUpdatingLocation()
        default: break
        }
        
        setPlaceholderText()
    }
    
    func changeKeyboard(cc: Int)
    {
        switch cc
        {
        case 0:
            zipTextField.resignFirstResponder()
            zipTextField.keyboardType = UIKeyboardType.NumberPad
            zipTextField.becomeFirstResponder()
        case 1:
            zipTextField.resignFirstResponder()
            zipTextField.keyboardType = UIKeyboardType.ASCIICapable
            zipTextField.becomeFirstResponder()
        default: break
        }
    }
   
    @IBAction func goButton(sender: UIButton)
    {
        if checkTextField(zipTextField.text!)
        {
            search(zipTextField.text!)
        }
    }
    
    func checkTextField(text: String) -> Bool
    {
        var rc = false
        
        switch zipCitySegmentedControl.selectedSegmentIndex
        {
        case 0:
            if isZip(text){rc = true}
            else{setPlaceholderText()}
        case 1:
            if isAddress(text){rc = true}
            else{setPlaceholderText()}
        default: break
        }
        return rc
    }
    
    func isAddress(address: String) -> Bool
    {
        var rc = false
        
        let testAddress = address.componentsSeparatedByString(",")
        if testAddress.count == 2// && testAddress[1].componentsSeparatedByString(" ")[1].characters.count == 2
        {
            rc = true
        }
        return rc
    }
    
    func isZip(zip: String) -> Bool
    {
        var rc = false
        
        if zip.characters.count == 5 && Int(zip) > 00051
        {
            rc = true
        }
        
        return rc
    }
    
    func search(searchTerm: String)
    {
        for location in locationArr
        {
            if searchTerm == location.city || searchTerm.componentsSeparatedByString(",")[0] == location.city
            {
                zipTextField.text = ""
                zipTextField.placeholder = "Location already added"
                alreadyAdded = true
                goButton.enabled = true
            }
        }
        
        if alreadyAdded == false
        {
            zipTextField.enabled = false
            goButton.enabled = false
            
            var cc = ""
            switch zipCitySegmentedControl.selectedSegmentIndex
            {
            case 0: cc = "zip"
            case 1: cc = "city"
            case 2: cc = "zip"
            default: break
            }
            
            delegate?.zipWasChosen(searchTerm, cc: cc)
        }
        
        alreadyAdded = false
    }
    
    func setPlaceholderText()
    {
        switch zipCitySegmentedControl.selectedSegmentIndex
        {
        case 0:
            zipTextField.text = ""
            zipTextField.placeholder = "Enter Zip"

        case 1:
            zipTextField.text = ""
            zipTextField.placeholder = "Enter City, State"
        default: break
        }
    }
}

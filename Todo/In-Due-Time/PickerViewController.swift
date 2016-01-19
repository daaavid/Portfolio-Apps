//
//  PickerViewController.swift
//  In-Due-Time
//
//  Created by david on 10/21/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController
{
    @IBOutlet var picker: UIDatePicker!
    var delegate: PickerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        picker.minimumDate = NSDate()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        delegate?.dateWasChosen(picker.date)
    }
}

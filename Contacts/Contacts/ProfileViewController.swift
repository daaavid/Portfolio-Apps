//
//  ProfileViewController.swift
//  Contacts
//
//  Created by david on 11/20/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    @IBOutlet weak var familyButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var contact: Contact!
    let realm = try! Realm()
    
    var edit = false
    var newContact = false
    
    var allTextFields: [UITextField]!
    let textFieldBG = UIColor(red: 0.25, green: 0.7, blue: 0.71, alpha: 1)

    override func viewDidLoad()
    {
        super.viewDidLoad()

        allTextFields = [nameTextField, numberTextField, emailTextField, birthdayTextField]
    }
    
    func setContact()
    {
        if let _ = contact
        {
            if contact.name == youName
            {
                familyButton.hidden = true
            }

            print("found contact: ", contact.name)
            setTextFields(contact)
        }
        else
        {
            familyButton.hidden = true
            let contacts = realm.objects(Contact).filter("name == %@", youName)
            contact = contacts.first
            setTextFields(contact)
        }
        
        toggleTextFields()
    }
    
    //MARK: - TextFields
    
    func setTextFields(contact: Contact)
    {
        nameTextField.text = contact.name
        numberTextField.text = contact.number
        emailTextField.text = contact.email
        birthdayTextField.text = contact.birthday

        if contact.favorite
        {
            familyButton.setImage(UIImage(named: "redHeart"), forState: .Normal)
        }
    }
    
    func toggleTextFields()
    {
        for textField in allTextFields
        {
            textField.enabled = edit
            if edit
            {
                textField.borderStyle = .RoundedRect
                textField.backgroundColor = textFieldBG
            }
            else
            {
                textField.borderStyle = .None
                textField.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        var rc = false
        if textField.text != ""
        {
            switch textField
            {
            case nameTextField:
                numberTextField.becomeFirstResponder()
            case numberTextField:
                emailTextField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
                editButtonPressed(editButton)
            }
            rc = true
        }
        return rc
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        //http://stackoverflow.com/questions/27609104/xcode-swift-formatting-text-as-phone-number
        if textField == numberTextField
        {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            
            return false
        }
        else
        {
            return true
        }
    }

    //MARK: - Action Handlers
    
    @IBAction func phoneButtonPressed(sender: UIButton)
    {
        var number = numberTextField.text!.stringByReplacingOccurrencesOfString("(", withString: "")
        number = number.stringByReplacingOccurrencesOfString(")", withString: "")
        number = number.stringByReplacingOccurrencesOfString(" ", withString: "")
        number = number.stringByReplacingOccurrencesOfString("-", withString: "")
        let url = NSURL(string: "tel://\(number)")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func emailButtonPressed(sender: UIButton)
    {
        let url = NSURL(string: "mailto:\(emailTextField.text!)")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func familyButtonPressed(sender: UIButton)
    {
        try! realm.write({ () -> Void in
            self.contact.favorite = !self.contact.favorite
        })
        
        familyButton.rotate360Degrees()
        
        if contact.favorite
        {
            familyButton.setImage(UIImage(named: "redheart"), forState: .Normal)
        }
        else
        {
            familyButton.setImage(UIImage(named: "heart"), forState: .Normal)
        }
    }
    
    @IBAction func editButtonPressed(sender: UIButton)
    {
        editButton.rotate360Degrees()
        editContact()
    }
    
    //MARK: - Contact & Entry
    
    func editContact()
    {
        if newContact
        {
            self.familyButton.hidden = true
        }
        
        edit = !edit
        
        if edit
        {
            self.view.alpha = 0.8
            UIView.animateWithDuration(0.4) { () -> Void in
                self.view.alpha = 1
            }
            
            toggleTextFields()
            editButton.setImage(UIImage(named: "editing"), forState: .Normal)
            nameTextField.becomeFirstResponder()
        }
        else
        {
            if checkEntry()
            {
                self.view.alpha = 0.8
                UIView.animateWithDuration(0.4) { () -> Void in
                    self.view.alpha = 1
                }
                
                toggleTextFields()
                
                if !newContact
                {
                    try! realm.write({ () -> Void in
                        self.contact.name = self.nameTextField.text!
                        self.contact.number = self.numberTextField.text!
                        self.contact.email = self.emailTextField.text!
                        self.contact.birthday = self.birthdayTextField.text!
                        print("realmWrite: Edit")
                        self.validEntry()
                        
                        if firstContact
                        {
                            youName = self.nameTextField.text!
                            firstContact = false
                            
                            let mainVC = self.parentViewController as! MainViewController
                            mainVC.segmentedControl.hidden = false
                        }
                    })
                }
                else
                {
                    try! realm.write({ () -> Void in
                        let newContact = Contact()
                        
                        newContact.name = self.nameTextField.text!
                        newContact.number = self.numberTextField.text!
                        
                        if self.emailTextField.text != ""
                        {
                            newContact.email = self.emailTextField.text!
                        }
                        
                        if self.birthdayTextField.text != ""
                        {
                            newContact.birthday = self.birthdayTextField.text!
                        }
                        
                        self.realm.add(newContact)
                        self.validEntry()
                    })
                }
            }
            else
            {
                edit = !edit
            }
        }
    }
    
    func checkEntry() -> Bool
    {
        var rc = false
        let validator = Validator()
        var validEdit = [false, false, false, false]
        
        if validator.validate("name", string: nameTextField.text!)
        {
            validEdit[0] = true
        }
        else
        {
            invalidEntry(nameTextField)
        }
        
        if validator.validate("phone", string: numberTextField.text!)
        {
            validEdit[1] = true
        }
        else
        {
            invalidEntry(numberTextField)
        }
        
        if emailTextField.text == ""
        {
            validEdit[2] = true
        }
        else if validator.validate("email", string: emailTextField.text!)
        {
            validEdit[2] = true
        }
        else
        {
            invalidEntry(emailTextField)
        }
        
        if let formattedBirthday = self.birthdayTextField.text?
            .stringByReplacingOccurrencesOfString(".", withString: "/")
            .stringByReplacingOccurrencesOfString(" ", withString: "/")
        {
            self.birthdayTextField.text = formattedBirthday
        }
        
        if birthdayTextField.text == ""
        {
            validEdit[3] = true
        }
        else if validator.validate("birthday", string: birthdayTextField.text!)
        {
            validEdit[3] = true
        }
        else
        {
            invalidEntry(birthdayTextField)
        }
        
        if validEdit[0] && validEdit[1] && validEdit[2] && validEdit[3]
        {
            rc = true
        }
        return rc
    }
    
    func invalidEntry(textField: UITextField)
    {
        textField.backgroundColor = UIColor.redColor()
    }
    
    func validEntry()
    {
        editButton.setImage(UIImage(named: "edit"), forState: .Normal)
        for textField in allTextFields
        {
            textField.backgroundColor = UIColor.clearColor()
        }
    }
}

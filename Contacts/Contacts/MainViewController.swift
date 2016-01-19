//
//  ViewController.swift
//  Contacts
//
//  Created by david on 11/20/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit
import RealmSwift

protocol ContactsProtocol
{
    func profileWasChosen(chosenProfile: Contact)
    func profileWasChosenForDeletion(chosenProfile: Contact)
}

var youName = "David"
var firstContact = false
var contacts: Results <Contact>!

class MainViewController: UIViewController, UISearchBarDelegate, ContactsProtocol, UITextFieldDelegate
{
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var addContactButtonView: UIView!
    @IBOutlet weak var editContactButtonView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var navLabel: UILabel!
    
    let realm = try! Realm()
    var chosenContact: Contact?
    
    var currentCreateAction: UIAlertAction!
    var validName = false
    var newContact = false
    
    weak var currentViewController: UIViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        contacts = realm.objects(Contact).sorted("name")

        if contacts.first != nil
        {
            segmentChanged(segmentedControl)
        }
        else
        {
            firstContact = true
            segmentedControl.hidden = true
            addContact()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        manageChildContents(true)
    }
    
    //MARK: - Action Handlers
    
    @IBAction func segmentChanged(sender: UISegmentedControl)
    {
        sender.setTitle("You", forSegmentAtIndex: 2)
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            manageNavLabelAndSearchBar("Contacts")
            cycleViewController("Contacts")
        case 1:
            manageNavLabelAndSearchBar("Favorites")
            cycleViewController("Contacts")
        case 2:
            manageNavLabelAndSearchBar("Profile")
            cycleViewController("Profile")
        default: print("nothing to see here")
        }
    }
    
    @IBAction func addButtonTapped(sender: UIButton)
    {
        addContact()
    }
    
    //MARK: - Editing
    
    @IBAction func editButtonTapped(sender: UIButton)
    {
        if let contactsVC = self.childViewControllers[0] as? ContactsViewController
        {
            contactsVC.delegate = self
            let tableView = contactsVC.tableView
            
            let edit = !tableView.editing
            tableView.editing = edit
            
            let spinView = self.editContactButtonView
            spinView.rotate360Degrees()
            tableView.alpha = 0.4
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                tableView.alpha = 1
            })
        }
    }
    
    func profileWasChosenForDeletion(chosenProfile: Contact)
    {
        if chosenProfile.name != youName
        {
            try! realm.write { () -> Void in
                self.realm.delete(chosenProfile)
            }
        }
        editButtonTapped(editButton)
        cycleViewController("Contacts")
    }
    
    //MARK: - Child VCs and subviews
    
    func cycleViewController(identifier: String)
    {
        manageAddButtonView(identifier)

        let newVC = storyboard!.instantiateViewControllerWithIdentifier(identifier)
        newVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(newVC)
        
        addSubview(newVC.view, toView: containerView)

        newVC.view.alpha = 0
        UIView.animateWithDuration(0.4, animations:
        { () -> Void in
           
            newVC.view.alpha = 1
            if let currentVC = self.currentViewController
            {
                currentVC.view.alpha = 0
                currentVC.view.removeFromSuperview()
                currentVC.removeFromParentViewController()
            }
        } )

        currentViewController = newVC
        
        if !newContact
        {
            manageChildContents(false)
        }
    }
    
    func addSubview(subView: UIView, toView parentView: UIView)
    {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView
            .addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
                options: [], metrics: nil, views: viewBindingsDict))
        parentView
            .addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
                options: [], metrics: nil, views: viewBindingsDict))
    }
    
    //MARK: - Manage Content
    
    func profileWasChosen(chosenProfile: Contact)
    {
        print("profileWasChosen")
        chosenContact = chosenProfile
        segmentedControl.selectedSegmentIndex = 2
        segmentChanged(segmentedControl)
    }
    
    func manageChildContents(isSearch: Bool)
    {
        if let contactsVC = self.childViewControllers[0] as? ContactsViewController
        {
            contactsVC.delegate = self
            contactsVC.shownContacts.removeAll()
            switch segmentedControl.selectedSegmentIndex
            {
            case 0:
                //Contacts
                if isSearch
                {
                    for contact in contacts
                    {
                        if searchBar.text != "" && contact.name.lowercaseString.containsString(searchBar.text!.lowercaseString)
                        {
                            contactsVC.shownContacts.append(contact)
                        }
                        else if searchBar.text == ""
                        {
                            contactsVC.shownContacts.append(contact)
                        }
                    }
                }
                else
                {
                    for contact in contacts
                    {
                        contactsVC.shownContacts.append(contact)
                    }
                }
            case 1:
                //Favorites
                if isSearch
                {
                    for contact in contacts
                    {
                        if searchBar.text != "" && contact.favorite && contact.name.lowercaseString.containsString(searchBar.text!.lowercaseString)
                        {
                            contactsVC.shownContacts.append(contact)
                        }
                        else if searchBar.text == "" && contact.favorite
                        {
                            contactsVC.shownContacts.append(contact)
                        }
                    }
                }
                else
                {
                    for contact in contacts
                    {
                        if contact.favorite
                        {
                            contactsVC.shownContacts.append(contact)
                        }
                    }
                }
                default: print("wrong vc.")
            }
            
            contactsVC.tableView.reloadData()
        }
        else if let profileVC = self.childViewControllers[0] as? ProfileViewController
        {
            //this code sucks
            if let _ = chosenContact
            {
                profileVC.contact = chosenContact
                let title = chosenContact!.name.componentsSeparatedByString(" ")[0]
                if title != youName
                {
                    segmentedControl.setTitle(title, forSegmentAtIndex: 2)
                }
                profileVC.setContact()
            }
            else if !profileVC.newContact
            {
                let contacts = realm.objects(Contact).filter("name == %@", youName)
                profileVC.contact = contacts.first
                profileVC.setContact()
            }
            
            self.chosenContact = nil
        }
    }
    
    func manageAddButtonView(identifier: String)
    {
        if identifier != "Profile"
        {
            if addContactButtonView.hidden
            {
                self.addContactButtonView.hidden = false
                self.editContactButtonView.hidden = false
                
                self.addContactButtonView.alpha = 0
                self.editContactButtonView.alpha = 0
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.addContactButtonView.alpha = 1
                    self.editContactButtonView.alpha = 1
                } )
            }
        }
        else
        {
            self.addContactButtonView.hidden = true
            self.editContactButtonView.hidden = true
        }
    }
    
    func manageNavLabelAndSearchBar(text: String)
    {
        self.navLabel.text = text
        self.navLabel.alpha = 0
        self.navLabel.center.x -= self.navLabel.frame.width
        
        UIView.animateWithDuration(0.25) { () -> Void in
            self.navLabel.alpha = 1
            self.navLabel.center.x += self.navLabel.frame.width
        }

        searchBar.resignFirstResponder()
        let searchTextField = searchBar.valueForKey("searchField") as! UITextField
        
        if text == "Profile"
        {
            searchBar.text = ""
            searchBar.alpha = 0.8
            searchTextField.enabled = false
        }
        else
        {
            searchTextField.enabled = true
            searchBar.alpha = 1
        }
    }
    
    //MARK: - Add Friend
    
    func addContact()
    {
        newContact = true
        cycleViewController("Profile")
        if let profileVC = self.childViewControllers[0] as? ProfileViewController
        {
            profileVC.newContact = true
            profileVC.editContact()
            segmentedControl.selectedSegmentIndex = 2
            segmentedControl.setTitle("New", forSegmentAtIndex: 2)
        }
        newContact = false
     }
    
    
    //MARK: - Deprecated
    
    func ContactNameFieldDidChange(sender: UITextField)
    {
        /*
        let validator = Validator()
        if validator.validate("name", string: sender.text!)
        {
            validName = true
        }
        else
        {
            validName = false
        }
        */
    }

    /*
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        //http://stackoverflow.com/questions/27609104/xcode-swift-formatting-text-as-phone-number
        if textField == textField.viewWithTag(2) as! UITextField
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
            
            let validator = Validator()
            if validator.validate("phone", string: textField.text!) && validName
            {
                self.currentCreateAction.enabled = true
            }
            
            return false
        }
        else
        {
            print("else")

            return true
        }
    }
    */
    
    func alertController()
    {
        /*
        let alertController = UIAlertController(title: "Add Contact", message: "Add some info for this contact.", preferredStyle: .Alert)
        // .Alert and .ActionSheet
        currentCreateAction = UIAlertAction(title: "Create", style: .Default)
        { (action) -> Void in
        let newContact = Contact()
        let name = alertController.textFields?.first?.text
        let number = alertController.textFields?[1].text
        
        newContact.name = name!
        newContact.number = number!
        
        try! self.realm.write({ () -> Void in
        self.realm.add(newContact)
        self.cycleViewController("Contacts")
        self.validName = false
        })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.addAction(currentCreateAction)
        currentCreateAction.enabled = false
        
        alertController.addTextFieldWithConfigurationHandler{ (textField) -> Void in
        textField.placeholder = "Name"
        textField.tag = 1
        textField.addTarget(self, action: "ContactNameFieldDidChange:", forControlEvents: .EditingChanged)
        }
        
        alertController.addTextFieldWithConfigurationHandler{ (textField) -> Void in
        textField.placeholder = "Number"
        textField.tag = 2
        textField.delegate = self
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
        */
    }
}


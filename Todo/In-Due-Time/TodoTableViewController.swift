//
//  TodoTableViewController.swift
//  In-Due-Time
//
//  Created by david on 10/20/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit
import CoreData

@objc protocol PickerDelegate
{
    func dateWasChosen(date: NSDate)
}

let todoNotification = "notification"

class TodoTableViewController: UITableViewController, UITextFieldDelegate, PickerDelegate
{
    @IBOutlet weak var errorLabel: UILabel!

    var todoArray = [Todo]()
    var notifArray = [UILocalNotification]()
    
    let managedObjectContext = (UIApplication
        .sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let checkImg = UIImage(named: "checked.png")
    let uncheckImg = UIImage(named: "unchecked.png")
    var buttonIndex: NSIndexPath!
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        print("view appeared")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        load()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
//        NSNotificationCenter.defaultCenter().addObserverForName(todoNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
//            self.notificationPopped(notification.userInfo!)
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowPickerSegue"
        {
            let pickerVC = segue.destinationViewController as! PickerViewController
            pickerVC.delegate = self
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return todoArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodoCell", forIndexPath: indexPath) as! TodoCell
        
        errorLabel.text = ""
        cell.dateButton.setTitle("Set Due Date", forState: UIControlState.Normal)
        cell.dateButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)

        let todoItem = todoArray[indexPath.row]
        
        if todoItem.title == nil
        {
            cell.titleTextField.becomeFirstResponder()
            cell.checkbox.setImage(uncheckImg, forState: UIControlState.Normal)
            cell.titleTextField.text = ""
        }
        else
        {
            cell.titleTextField.text = todoItem.title
        }
        
        if todoItem.isDone == true
        {
            cell.checkbox.setImage(checkImg, forState: UIControlState.Normal)
            cell.backgroundColor = UIColor(red: 0.28, green: 0.20, blue: 0.52, alpha: 1)
            cell.titleTextField.textColor = UIColor.whiteColor()
            
            cell.dateButton.enabled = false
        }
        else
        {
            cell.checkbox.setImage(uncheckImg, forState: UIControlState.Normal)
            cell.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
            cell.titleTextField.textColor = UIColor.blackColor()
            
            cell.dateButton.enabled = true
        }
        
        if todoItem.date != nil
        {
            let formattedDate = todoItem.date!.nsDateShortStyleAsString()
            cell.dateButton.setTitle("Due By: " + formattedDate, forState: .Normal)
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let todoItem = todoArray[indexPath.row]

        if editingStyle == .Delete && todoItem.isDone == true
        {
            todoArray.removeAtIndex(indexPath.row)
            managedObjectContext.deleteObject(todoItem)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            saveContext()
        }
        else
        {
            errorLabel.text = "Check tasks before you delete them!"
        }
    }
    
    //MARK: - ACTION HANDLERS 3: REVENGE OF THE HANDLERS
    @IBAction func addTodo(sender: UIBarButtonItem)
    {
        let todoItem = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: managedObjectContext) as! Todo
        todoArray.append(todoItem)
        tableView.reloadData()
    }
   
    @IBAction func dateButtonPressed(sender: UIButton)
    {
        let contentView = sender.superview
        let cell = contentView?.superview as! TodoCell
        buttonIndex = tableView.indexPathForCell(cell)!
    }
    
    @IBAction func checkboxPressed(sender: UIButton)
    {
        let contentView = sender.superview
        let cell = contentView?.superview as! TodoCell
        let indexPath = tableView.indexPathForCell(cell)
        let todoItem = todoArray[indexPath!.row]
        
        todoItem.title = cell.titleTextField.text //just in case they don't press enter when they're typing in their todo and just immediately check it off
        
        if sender.currentImage == uncheckImg
        {
            cell.checkbox.setImage(checkImg, forState: UIControlState.Normal)
            todoItem.isDone = true
            todoItem.date = nil
//            cell.backgroundColor = UIColor.lightTextColor()
            cell.backgroundColor = UIColor(red:0.38, green:0.00, blue:0.02, alpha:1.0)
            cell.titleTextField.textColor = UIColor.whiteColor()
            
            removeNotification(todoItem)
        }
        else
        {
            cell.checkbox.setImage(uncheckImg, forState: UIControlState.Normal)
            todoItem.isDone = false
            cell.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
            cell.titleTextField.textColor = UIColor.blackColor()
        }

        tableView.reloadData()
        saveContext()
    }
    
    //MARK: - Delegates
    
    func dateWasChosen(date: NSDate)
    {
        print("date was chosen")
        
        let uuid = NSUUID().UUIDString
        let todo = todoArray[buttonIndex.row]
        todo.date = date
        todo.uuid = uuid
        
        setupNotification(todo, uuid: uuid)
        
        tableView.reloadData()
        saveContext()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField.text != ""
        {
            let contentView = textField.superview
            let cell = contentView?.superview as! TodoCell
            let indexPath = tableView.indexPathForCell(cell)
            let todoItem = todoArray[indexPath!.row]
            todoItem.title = textField.text
            textField.resignFirstResponder()
            saveContext()
            
            return true
        }
        
        return false
    }
    
    //MARK: - Private
    
    private func saveContext()
    {
        do {
            try managedObjectContext.save()
        }
        catch {
            let nserror = error as NSError
            NSLog(" WHOOPS SOMETHING WENT WRONG AHAHA \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    private func load()
    {
        let fetchRequest = NSFetchRequest(entityName: "Todo")
        do {
            let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Todo]
            todoArray = fetchResults!
        }
        catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }

    //MARK: - New Stuff
    
    func setupNotification(todo: Todo, uuid: String)
    {
        let todoNotif = UILocalNotification()
        let today = NSDate()
        
        if let interval = todo.date?.timeIntervalSinceDate(today)
        {
            print("\(interval - 50) seconds")
            todoNotif.fireDate = NSDate(timeInterval: interval - 50, sinceDate: today)
            todoNotif.timeZone = NSTimeZone.localTimeZone()
            todoNotif.alertAction = "Okay"
            todoNotif.alertBody = "Todo"
            
            let userInfo = ["objectUUID": uuid]
            todoNotif.userInfo = userInfo
            
            notifArray.append(todoNotif)
            
            UIApplication.sharedApplication().scheduleLocalNotification(todoNotif)
        }
    }
    
    func removeNotification(todo: Todo)
    {
        var index: Int?
        for notification in notifArray
        {
            if let uuid =  notification.userInfo!["objectUUID"] as? String
            {
                if uuid == todo.uuid
                {
                    index = notifArray.indexOf(notification)
                }
            }
        }
        
        if index != nil
        {
            let notificationToRemove = notifArray[index!]
            UIApplication.sharedApplication().cancelLocalNotification(notificationToRemove)
            
            notifArray.removeAtIndex(index!)
            print("notification removed")
        }
    }
    
    func notificationPopped(notifUUID: NSDictionary)
    {
        print("notification popped")
        if let uuid = notifUUID.valueForKey("objectUUID") as? String
        {
            print("if let uuid")
            var index: Int?
            for todo in todoArray
            {
                if todo.uuid == uuid
                {
                    index = todoArray.indexOf(todo)!
                }
            }
            
            if let _ = index
            {
                let visibleCells = tableView.visibleCells
                let cell = visibleCells[index!] as! TodoCell
                let todo = todoArray[index!]
                flashCell(cell, date: todo.date!)
            }
        }
    }
    
    func flashCell(cell: TodoCell, date: NSDate)
    {
        let bgBak = cell.backgroundColor
        cell.backgroundColor = UIColor.redColor()
        UIView.animateWithDuration(1.0, delay: 1.0, options: [], animations: { () -> Void in
            cell.backgroundColor = bgBak
            let formattedDate = date.nsDateShortStyleAsString()
            cell.dateButton.setTitle("DUE: \(formattedDate)", forState: .Normal)
            cell.dateButton.setTitleColor(UIColor.redColor(), forState: .Normal)
            
            }, completion: nil)
        
    }
}

extension NSDate
{
    func nsDateShortStyleAsString() -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        let formattedTime = formatter.stringFromDate(self)
        return formattedTime
    }
}

//180 653 job order number

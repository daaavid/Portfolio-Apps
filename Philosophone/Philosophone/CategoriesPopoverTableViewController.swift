//
//  CategoriesPopoverTableViewController.swift
//  Philosophone
//
//  Created by david on 12/4/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit
import AVFoundation

class CategoriesPopoverTableViewController: UITableViewController
{
    var categories: [String]!
    
    let categoriesDictionary = [
        "inspire"       : "Inspiration",
        "management"    : "Management",
        "sports"        : "Sports",
        "life"          : "Life",
        "funny"         : "Funny",
        "love"          : "Love",
        "art"           : "Art"
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        categories = [String](categoriesDictionary.keys)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
        
        let categoryStr = categories[indexPath.row]

        let categoryDescription = categoriesDictionary[categoryStr]

        cell.textLabel?.text = categoryDescription
        
        if GLOBAL_SETTINGS!.categories.contains(categoryStr)
        {
            cell.accessoryType = .Checkmark
        }
        else
        {
            cell.accessoryType = .None
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let sound = TypewriterClack()
        sound.playSound("soft")
        
        let category = categories[indexPath.row]
        
        if !GLOBAL_SETTINGS!.categories.contains(category)
        {
            print("appended category: \(category)")
            GLOBAL_SETTINGS?.categories.append(category)
        }
        else
        {
            if let index = GLOBAL_SETTINGS?.categories.indexOf(category)
            {
                print("removed category: \(category)")
                GLOBAL_SETTINGS?.categories.removeAtIndex(index)
            }
        }
        
        tableView.reloadData()
    }
}

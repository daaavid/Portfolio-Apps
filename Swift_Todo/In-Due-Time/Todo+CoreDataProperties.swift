//
//  Todo+CoreDataProperties.swift
//  In-Due-Time
//
//  Created by david on 12/1/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Todo {

    @NSManaged var date: NSDate?
    @NSManaged var isDone: NSNumber?
    @NSManaged var title: String?
    @NSManaged var uuid: String?

}

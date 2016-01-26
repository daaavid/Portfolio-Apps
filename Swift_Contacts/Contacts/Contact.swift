//
//  Contact.swift
//  Contacts
//
//  Created by david on 11/20/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import RealmSwift

class Contact: Object
{
    dynamic var name = ""
    dynamic var nickname = ""
    dynamic var number = ""
    dynamic var birthday = ""
    dynamic var email = ""
    dynamic var favorite = false
    
    let contacts = List<Contact>()
}
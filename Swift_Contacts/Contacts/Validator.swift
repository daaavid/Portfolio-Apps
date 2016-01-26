//
//  Validator.swift
//  Contacts
//
//  Created by david on 11/21/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import Foundation

class Validator
{
    func validate(var regEx: String, string: String) -> Bool
    {
        switch regEx
        {
        case "phone": regEx = "^\\(\\d{3}\\) \\d{3}-\\d{4}$"
        case "email": regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        case "name": regEx = "^[A-Za-z]{1,10}$"
        case "birthday": regEx = "^(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](19|20)\\d\\d$"
        default: print("unknown regEx: " + regEx)
        }
        
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        let result =  test.evaluateWithObject(string)
        return result
    }
}

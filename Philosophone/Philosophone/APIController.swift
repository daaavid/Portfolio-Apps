//
//  APIController.swift
//  Philosophone
//
//  Created by david on 12/4/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import Foundation

class APIController
{
    var delegate: APIControllerProtocol?
    
    init(delegate: APIControllerProtocol)
    {
        self.delegate = delegate
    }
    
    func getQuote(categories: [String])
    {
        let baseURL = "http://api.theysaidso.com/qod.json?category="
        var category = ""
        
        if categories.count > 1
        {
            let randomIndex = Int(arc4random() % UInt32(categories.count - 1))
            category = categories[randomIndex]
        }
        
        if let url = NSURL(string: (baseURL + category))
        {
            let session = NSURLSession.sharedSession()
            session.dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
                
                if data != nil
                {
                    if let dictionary = self.parseJSON(data!)
                    {
                        print(self.delegate)
                        self.delegate?.quoteWasFound(dictionary)
                    }
                }
                else
                {
                    print(error?.localizedDescription)
                    
                    self.delegate?.quoteWasFound(nil)
                }
                
            }).resume()
        }
        else
        {
            print("invalid url: \(baseURL + category)")
        }
        
    }
    
    func parseJSON(data: NSData) -> NSDictionary?
    {
        do
        {
            let dictionary: NSDictionary! = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
            print("parsed JSON")
            
            return dictionary
        }
        catch let error as NSError
        {
            print(error)
            return nil
        }
    }
}
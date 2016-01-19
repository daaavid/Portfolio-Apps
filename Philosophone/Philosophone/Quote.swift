//
//  Quote.swift
//  Philosophone
//
//  Created by david on 12/4/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import Foundation

class Quote
{
    let quote: String
    let author: String
    
    init(quote: String, author: String)
    {
        self.quote = quote
        self.author = author
    }
    
    static func quoteFromAPIResults(results: NSDictionary) -> Quote?
    {
        if let contents = results["contents"] as? NSDictionary
        {
            let quotesArr = contents["quotes"] as? [NSDictionary] ?? NSArray()
            let contentDict = quotesArr.firstObject as? NSDictionary ?? NSDictionary()
            
            let quote = contentDict["quote"] as? String ?? ""
            let author = contentDict["author"] as? String ?? "Unknown"
            
            let quoteObject = Quote(quote: quote, author: author)
            
            return quoteObject
        }
        else
        {
            print("quote could not be parsed")
            return nil
        }
    }
}
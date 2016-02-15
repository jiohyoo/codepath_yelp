//
//  SearchSettings.swift
//  Yelp
//
//  Created by Ji Oh Yoo on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SearchSettings: NSObject {
    var term: String!
    var categories: [String]!
    var deals: Bool!
    var sort: YelpSortMode!
    var distance: Int?
    
    override init() {
        self.term = ""
        self.deals = false
        self.sort = YelpSortMode.BestMatched
        self.distance = nil
        self.categories = [String]()
    }
    
    static var SORT: [(String, YelpSortMode)] = [
        ("Best Match", YelpSortMode.BestMatched),
        ("Distance", YelpSortMode.Distance),
        ("Rating", YelpSortMode.HighestRated),
    ]
    
    static var CATEGORIES: [[String:String]] = [
//        ["American, New": "newamerican"],
//        ["American, Traditional": "tradamerican"],
//        ["Cafes": "cafes"],
        ["name" : "American, Traditional", "code": "tradamerican"],
        ["name" : "Cafes", "code": "cafes"],
        ["name" : "Chicken Wings", "code": "chicken_wings"],
        ["name" : "Chinese", "code": "chinese"],
        ["name" : "French", "code": "french"],
        ["name" : "Italian", "code": "italian"],
        ["name" : "Japanese", "code": "japanese"],
        ["name" : "Korean", "code": "korean"],
        ["name" : "Pizza", "code": "pizza"],
    ]
    
    static var DISTANCES: [(String, Int?)] = [
        ("Best Match", nil),
        ("1 mile", 1600),
        ("2 mile", 3200),
        ("5 mile", 8000),
        ("10 mile", 16000),
        ("25 mile", 40000),
    ]
}

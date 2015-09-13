//
//  Poll.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/12/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class Survey: NSObject {
    
    // MARK: Instance Variables
    var id: String!
    var name: String!
    var created: NSDate!
    var parse: PFObject!
    
    // MARK: Convenience Methods
    convenience init(_ object: PFObject) {
        self.init()
        
        self.id = object.objectId
        self.name = object.objectForKey("name") as? String
        self.created = object.createdAt
        self.parse = object
    }
    
    // MARK: Class Methods
    class func fetch(id: String, callback: ((survey: Survey) -> Void)) {
        var object = PFObject(withoutDataWithClassName: "Survey", objectId: id)
        
        object.fetchInBackgroundWithBlock { (tempObject: PFObject?, error: NSError?) -> Void in            
            if let survey = tempObject {
                callback(survey: Survey(survey))
            } else {
                println(error)
            }
        }
    }
    
    // MARK: Instance Methods
    func getUrl(installation: Installation, callback: ((url: NSURL) -> Void)) {
        Config.sharedInstance { (config) -> Void in
            var url = "\(config.host)/surveys/\(self.id)/\(installation.id)"
            
            if let nsurl = NSURL(string: url) {
                callback(url: nsurl)
            }
        }
    }
    
    func createdDuration() -> String {
        let timeInterval = TTTTimeIntervalFormatter()
        let interval = NSDate().timeIntervalSinceDate(self.created)
        return timeInterval.stringForTimeInterval(-interval)
    }
}
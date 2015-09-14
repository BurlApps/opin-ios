//
//  Installation.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/12/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class Installation: NSObject {
    
    // MARK: Instance Variables
    var id: String!
    var parse: PFInstallation!
    
    // MARK: Convenience Methods
    convenience init(_ object: PFInstallation) {
        self.init()
        
        self.id = object.objectId
        self.parse = object
    }
    
    // MARK: Class Methods
    class func current() -> Installation {
        return Installation(PFInstallation.currentInstallation())
    }
    
    class func startup() -> Installation {
        var install = PFInstallation.currentInstallation()
        install.saveInBackground()
        return Installation(install)
    }
    
    // MARK: Instance Methods
    func setDeviceToken(token: NSData) {
        self.parse.setDeviceTokenFromData(token)
        self.parse.setObject(Global.appVersion(), forKey: "appVersionNumber")
        self.parse.setObject(Global.appBuildVersion(), forKey: "appVersionBuild")
        self.parse.saveInBackground()
    }
    
    func setBadge(badge: Int) {
        self.parse.badge = badge
        self.parse.saveInBackground()
    }
    
    func clearBadge() {
        if self.parse.badge != 0 {
            self.parse.badge = 0
            self.parse.saveInBackground()
        }
    }
    
    func addClassroom(code: String, callback: ((success: Bool) -> Void)) {
        var classroom = PFObject(className: "Class")
        var query = PFQuery(className: "Class")
        
        query.whereKey("code", equalTo: code)
        query.orderByDescending("createAt")
        
        query.getFirstObjectInBackgroundWithBlock { (tempClass: PFObject?, error: NSError?) -> Void in
            if tempClass != nil && error == nil {
                var relation = tempClass?.relationForKey("students")
        
                relation?.addObject(self.parse)
                tempClass?.saveInBackground()
                callback(success: true)
            } else {
                callback(success: false)
            }
        }
    }
    
    func getSurveys(callback: ((surveys: [Survey]) -> Void)) {
        var surveys: [Survey] = []
        var query = self.parse.relationForKey("surveys").query()
        
        query?.whereKey("state", equalTo: 1)
        
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects as! [PFObject] {
                    var survey = Survey(object)
                    surveys.append(survey)
                }
                
                callback(surveys: surveys)
            } else {
                println(error)
                callback(surveys: [])
            }
        })
        
    }
}
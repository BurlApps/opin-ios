//
//  Installation.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/12/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class Installation: NSObject {
    
    // MARK: Instance Variables
    var parse: PFInstallation!
    
    // MARK: Convenience Methods
    convenience init(_ object: PFInstallation) {
        self.init()
        
        self.parse = object
    }
    
    // MARK: Class Methods
    class func current() -> Installation {
        return Installation(PFInstallation.currentInstallation())
    }
    
    // MARK: Instance Methods
    func setDeviceToken(token: NSData) {
        self.parse.setDeviceTokenFromData(token)
        self.parse.setObject(Global.appVersion(), forKey: "appVersionNumber")
        self.parse.setObject(Global.appBuildVersion(), forKey: "appVersionBuild")
        self.parse.saveInBackground()
    }
    
    func clearBadge() {
        if self.parse.badge != 0 {
            self.parse.badge = 0
            self.parse.saveInBackground()
        }
    }
}
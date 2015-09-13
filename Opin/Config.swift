//
//  Config.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/12/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

var updating = false

class Config: NSObject {
    
    // MARK: Instance Variables
    var host: String!
    var parse: PFConfig!
    
    // MARK: Convenience Methods
    convenience init(_ object: PFConfig) {
        self.init()

        self.host = object["host"] as? String
        self.parse = object
    }
    
    // MARK: Class Methods
    class func sharedInstance(callback: ((config: Config) -> Void)!) {
        let config = PFConfig.currentConfig()
        
        if !updating && config["host"] != nil {
            callback?(config: Config(config))
        } else {
            Config.update(callback)
        }
    }
    
    class func update(callback: ((config: Config) -> Void)!) {
        updating = true
        
        PFConfig.getConfigInBackgroundWithBlock { (config: PFConfig?, error: NSError?) -> Void in
            updating = false
            
            if config != nil {
                callback?(config: Config(config!))
            } else {
                callback?(config: Config(PFConfig.currentConfig()))
            }
        }
    }
}
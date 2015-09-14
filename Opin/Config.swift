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
    var loaderBackground: UIColor!
    var loaderPrimary: UIColor!
    var parse: PFConfig!
    
    // MARK: Convenience Methods
    convenience init(_ object: PFConfig) {
        self.init()

        self.host = object["host"] as? String
        self.parse = object
        
        if var background = object["loaderBackground"] as? [CGFloat] {
            let red = background[0]/255
            let green = background[1]/255
            let blue = background[2]/255
            
            self.loaderBackground = UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
        
        if var primary = object["loaderPrimary"] as? [CGFloat] {
            let red = primary[0]/255
            let green = primary[1]/255
            let blue = primary[2]/255
            
            self.loaderPrimary = UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
    }
    
    // MARK: Class Methods
    class func sharedInstance(callback: ((config: Config) -> Void)!) {
        let config = PFConfig.currentConfig()
        
        if !updating && config.objectForKey("host") != nil {
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
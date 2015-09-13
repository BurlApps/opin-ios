//
//  Global.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/12/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class Global {
    
    // MARK: Instance Variables
    static var pagesController: PagesController!
    
    // MARK: Class Methods
    class func appBuildVersion() -> String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        let version = infoDictionary["CFBundleShortVersionString"] as! NSString
        let build = infoDictionary[kCFBundleVersionKey] as! NSString
        
        return "\(version) - \(build)"
    }
    
    class func appVersion() -> String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        
        return infoDictionary["CFBundleShortVersionString"] as! String
    }
    
    class func slideToController(index: Int, animated: Bool, direction: UIPageViewControllerNavigationDirection) {
        if self.pagesController != nil {
            self.pagesController.setActiveChildController(index, animated: animated, gotToRoot: true, direction: direction)
        }
    }
    
    class func lockPageView() {
        if self.pagesController != nil {
            self.pagesController.lockPageView()
        }
    }
    
    class func unlockPageView() {
        if self.pagesController != nil {
            self.pagesController.unlockPageView()
        }
    }
    
    class func showSurvey(surveyID: String) {
        if self.pagesController != nil {
            Survey.fetch(surveyID, callback: self.pagesController.showSurvey)
        }
    }
}
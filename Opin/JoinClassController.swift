//
//  JoinClassController.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/12/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class JoinClassController: UIViewController, UIAlertViewDelegate {

    // Instance Variables
    private var installation = Installation.current()
    private var notifications = Notifications()
    private var heroBorder: UIView!
    
    // MARK: IBOutlets
    @IBOutlet weak var codeInput: UITextField!
    @IBOutlet weak var heroView: UIView!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add Bottom Border To Nav Bar
        if self.heroBorder == nil {
            self.heroBorder = UIView(frame: CGRectMake(0, heroView.frame.height-1, heroView.frame.width, 1))
            heroBorder.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.heroView.addSubview(heroBorder)
        }
    }
    
    @IBAction func arrowPressed(sender: UIBarButtonItem) {
        Global.slideToController(1, animated: true, direction: .Forward)
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        if(NSString(string: self.codeInput.text).length == 0) {
            return self.showFailedAlert()
        }
        
        let charactersToRemove = NSCharacterSet.alphanumericCharacterSet().invertedSet
        let code = "".join(self.codeInput.text.componentsSeparatedByCharactersInSet(charactersToRemove)).lowercaseString
        
        self.installation.addClassroom(code, callback: { (success) -> Void in
            if success {
                self.codeInput.text = ""
                var message = "We found your classroom and have added you to the roster."
                
                if !self.notifications.enabled {
                    message = "\(message) Please enable notifications so your teacher can send you surveys."
                }
                
                UIAlertView(title: "You Have Joined The Class!", message: message, delegate: self,
                    cancelButtonTitle: "Thanks :)").show()
            } else {
                self.showFailedAlert()
            }
        })
    }
    
    // MARK: Instance Methods
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            Global.slideToController(1, animated: true, direction: .Forward)
            self.notifications.register()
        }
    }
    
    func showFailedAlert() {
        UIAlertView(title: "Invalid Classroom Code", message: "We were not able to find your classroom. Please ask your teacher for the code again.", delegate: nil, cancelButtonTitle: "I Will Ask My Teacher").show()
    }
}

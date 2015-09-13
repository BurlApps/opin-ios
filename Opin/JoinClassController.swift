//
//  JoinClassController.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/12/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class JoinClassController: UIViewController {

    // Instance Variables
    private var notifications = Notifications()
    
    // MARK: IBOutlets
    @IBOutlet weak var codeInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        if(!self.notifications.enabled) {
            self.notifications.register()
        }
        
        self.performSegueWithIdentifier("joinedSegue", sender: self)
    }
}

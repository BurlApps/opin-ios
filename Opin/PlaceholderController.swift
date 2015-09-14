//
//  PlaceholderController.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/13/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class PlaceholderController: UIViewController {

    @IBOutlet weak var thumbImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red:0.98, green:1, blue:1, alpha:1)
        self.thumbImage.tintColor = UIColor(red:0.18, green:0.34, blue:0.45, alpha:0.5)
    }
}

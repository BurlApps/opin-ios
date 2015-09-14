//
//  SurveyController.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/13/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class SurveyController: UIViewController, UIWebViewDelegate {

    // MARK: Instance Variables
    var url: NSURL!
    
    // MARK: IBOutlets
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        Config.sharedInstance { (config) -> Void in
            self.view.backgroundColor = config.loaderBackground
            self.webview.backgroundColor = config.loaderBackground
            self.loadingLabel.textColor = config.loaderPrimary
            self.loadingLabel.backgroundColor = config.loaderBackground
        }
        
        self.webview.delegate = self
        self.webview.loadRequest(NSURLRequest(URL: url))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    // MARK: UIWebViewDelegate Methods
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingLabel.hidden = true
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.URL?.scheme == "callback" {
            var page = Global.pagesController.currentPage
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                Global.slideToController(page, animated: false, direction: .Forward)
            })
            
            return false
        }

        return true
    }
}

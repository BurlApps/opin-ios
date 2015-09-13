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
        
        self.webview.delegate = self
        self.webview.loadRequest(NSURLRequest(URL: url))
    }
    
    // MARK: UIWebViewDelegate Methods
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingLabel.hidden = true
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.URL?.scheme == "callback" {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                Global.slideToController(Global.pagesController.currentPage, animated: false, direction: .Forward)
            })
            
            return false
        }

        return true
    }
}

//
//  HomeController.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/12/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class PagesController: UIPageViewController, UIAlertViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    // MARK: Instance Variables
    var controllers = Dictionary<Int, PageController>()
    var currentPage = 0
    private var config: Config!
    private let pages = 2
    private let startPage = 0
    private var scrollView: UIScrollView!
    private var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Global
        Global.pagesController = self
        
        // Create Page View Controller
        self.view.backgroundColor = UIColor.clearColor()
        self.dataSource = self
        self.delegate = self
        
        for controller in self.view.subviews {
            if let scrollView = controller as? UIScrollView {
                self.scrollView = scrollView
                self.scrollView.delegate = self
            }
        }
        
        // Create Controllers
        for index in 0...self.pages {
            var page: PageController!
            
            switch(index) {
                case 0: page = self.storyBoard.instantiateViewControllerWithIdentifier("JoinClassController") as? PageController
                default: page = self.storyBoard.instantiateViewControllerWithIdentifier("PollsTableController") as? PageController
            }
            
            page?.view.frame = self.view.frame
            page?.pageIndex = index
            self.controllers[index] = page
        }
        
        self.didMoveToParentViewController(self)
        
        // Check Notifications
        var notifications = Notifications()
        
        if(notifications.enabled) {
            notifications.register()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure Status Bar
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        // Remove Text From Back Button
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-1000, -1000),
            forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set Start Page
        self.setActiveChildController(self.startPage, animated: false, gotToRoot: true, direction: .Forward)
    }
    
    // MARK: Instance Methods
    func lockPageView() {
        self.scrollView.scrollEnabled = false
    }
    
    func unlockPageView() {
        self.scrollView.scrollEnabled = true
    }
    
    func showSurvey(survey: Survey) {
        var controller: SurveyController = (self.storyBoard.instantiateViewControllerWithIdentifier("SurveyController") as? SurveyController)!
        
        survey.getUrl(Installation.current(), callback: { (url) -> Void in
            controller.url = url
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func setActiveChildController(index: Int, animated: Bool, gotToRoot: Bool, direction: UIPageViewControllerNavigationDirection) {
        self.setViewControllers([self.viewControllerAtIndex(index)],
            direction: direction, animated: animated, completion: { (success: Bool) -> Void in
                if gotToRoot {
                    self.viewControllerAtIndex(self.currentPage).popToRootViewControllerAnimated(true)
                }
                
                self.currentPage = index
        })
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.setActiveChildController(index, animated: false, gotToRoot: gotToRoot, direction: .Forward)
        })
    }
    
    func viewControllerAtIndex(index: Int) -> PageController! {
        if self.pages == 0 || index >= self.pages {
            return nil
        }
        
        return self.controllers[index]
    }
    
    // MARK: Page View Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        if completed {
            self.currentPage = (pageViewController.viewControllers.last as! PageController).pageIndex
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageController).pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        return self.viewControllerAtIndex(index - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageController).pageIndex
        
        if index == NSNotFound || index >= self.pages {
            return nil
        }
        
        return self.viewControllerAtIndex(index + 1)
    }
    
    // MARK: UIScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.currentPage == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0)
        } else if self.currentPage == (self.pages - 1) && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0)
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.currentPage == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width {
            targetContentOffset.memory.x = scrollView.bounds.size.width
            targetContentOffset.memory.y = 0
        } else if self.currentPage == (self.pages - 1) && scrollView.contentOffset.x >= scrollView.bounds.size.width {
            targetContentOffset.memory.x = scrollView.bounds.size.width
            targetContentOffset.memory.y = 0
        }
    }
}
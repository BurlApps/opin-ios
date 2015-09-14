//
//  PollsTableController.swift
//  Opin
//
//  Created by Brian Vallelunga on 9/12/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class PollsTableController: UITableViewController {
    
    // MARK: Instance Variables
    var surveyUrl: NSURL!
    private var installation = Installation.current()
    private var surveys: [Survey] = []
    private var cellIdentifier = "cell"
    
    // MARK: IBOutlets
    @IBOutlet var placeholderView: UIView!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Placeholder
        self.placeholderView.frame = self.view.frame
        
        // Create Text Shadow
        var shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.05)
        shadow.shadowOffset = CGSizeMake(0, 2);
        
        // Add Bottom Border To Nav Bar
        if let frame = self.navigationController?.navigationBar.frame {
            var navBorder = UIView(frame: CGRectMake(0, frame.height-1, frame.width, 1))
            navBorder.backgroundColor = UIColor(white: 0, alpha: 0.2)
            self.navigationController?.navigationBar.addSubview(navBorder)
        }
        
        // Configure Navigation Bar
        self.navigationController?.navigationBar.shadowImage = UIImage.new()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.07, green:0.58, blue:0.96, alpha:1)
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        
        if let font = UIFont(name: "HelveticaNeue-Bold", size: 22) {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: font,
                NSShadowAttributeName: shadow
            ]
        }
        
        // Add Refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: Selector("reloadSurveys"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load Surveys
        self.reloadSurveys()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "surveySegue" {
            let viewController = segue.destinationViewController as! SurveyController
            viewController.url = self.surveyUrl
        }
    }

    @IBAction func addClassPressed(sender: UIBarButtonItem) {
        Global.slideToController(0, animated: true, direction: .Reverse)
    }
    
    // MARK: Instance Methods
    func reloadSurveys() {
        self.installation.getSurveys { (surveys) -> Void in
            self.surveys = surveys
            self.installation.setBadge(surveys.count)
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // UITableViewController Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(self.surveys.isEmpty) {
            self.tableView.backgroundView = self.placeholderView
            self.tableView.separatorStyle = .None
            return 0
        }
        
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .SingleLine;
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.surveys.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var survey = self.surveys[indexPath.row]
        
        survey.getUrl(self.installation, callback: { (url) -> Void in
            self.surveyUrl = url
            self.performSegueWithIdentifier("surveySegue", sender: self)
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var survey = self.surveys[indexPath.row]
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: self.cellIdentifier)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell.textLabel?.text = survey.name
        cell.detailTextLabel?.text = survey.createdDuration()
        
        return cell
    }

}

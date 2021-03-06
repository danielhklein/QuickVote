//
//  VoteResultTableViewController.swift
//  kleindaniel-hw4
//
//  Created by DK on 9/29/15.
//  Copyright © 2015 Daniel H Klein. All rights reserved.
//

import UIKit
import CoreData

class VoteResultTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellId: String = "voteCell"
    var tableView: UITableView = UITableView()
    var votingData = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.frame = CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height);
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
        self.view.addSubview(self.tableView)
    }
    
    //retrieve CoreData information
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Candidate")
        
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            votingData = results
        } else {
            print("Could not fetch")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init(title:String, preferredContentSize:CGSize) {
        self.init()
        self.preferredContentSize = preferredContentSize
        self.title = title
        self.modalPresentationStyle = UIModalPresentationStyle.Popover
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }


    //number of rows in table equals the number of entries in CoreData
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.votingData.count
    }
    
    //retrieve data for each candidate, display their full name and the number of votes for the candidate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath)
        let index: Int = indexPath.row
        let candidate = votingData[index]
        let first = candidate.valueForKey("firstName") as! String
        let last = candidate.valueForKey("lastName") as! String
        let votes = candidate.valueForKey("count") as! Int
        cell.textLabel?.text = "\(first) \(last)   Votes: \(votes)"
        return cell
    }
}

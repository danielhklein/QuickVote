//
//  ShowTableViewController.swift
//  kleindaniel-hw4
//
//  Created by DK on 9/28/15.
//  Copyright © 2015 Daniel H Klein. All rights reserved.
//

import UIKit
import CoreData

class ShowTableViewController: UITableViewController {
    
    var votingData = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    //number of rows in table equals the number of entries in CoreData
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return votingData.count
    }

    //retrieve data for each candidate, display their full name
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellid", forIndexPath: indexPath)
        let index: Int = indexPath.row
        let candidate = votingData[index]
        let first = candidate.valueForKey("firstName") as! String
        let last = candidate.valueForKey("lastName") as! String
        let state = candidate.valueForKey("state") as! String
        cell.textLabel?.text = "\(first) \(last)"
        cell.detailTextLabel?.text = state
        return cell
    }

    //send index of selected candidate to detail view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailSegue") {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destinationViewController as! DetailViewController
                controller.row = indexPath.row
                controller.votingData = self.votingData
            }
        }
    }
    

}

//
//  DetailViewController.swift
//  kleindaniel-hw4
//
//  Created by DK on 9/28/15.
//  Copyright © 2015 Daniel H Klein. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var row: Int = -1
    var votingData = [NSManagedObject]()

    @IBOutlet weak var firstNameOutlet: UILabel!
    
    @IBOutlet weak var lastNameOutlet: UILabel!
    
    @IBOutlet weak var stateOutlet: UILabel!
    
    @IBOutlet weak var partyOutlet: UILabel!
    
    @IBOutlet weak var votesOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let candidate = votingData[row]
        firstNameOutlet.text = candidate.valueForKey("firstName") as? String
        lastNameOutlet.text = candidate.valueForKey("lastName") as? String
        stateOutlet.text = candidate.valueForKey("state") as? String
        partyOutlet.text = candidate.valueForKey("party") as? String
        let votes = candidate.valueForKey("count") as! Int
        votesOutlet.text = "\(votes)"
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
}

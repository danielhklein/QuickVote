//
//  AddViewController.swift
//  kleindaniel-hw4
//
//  Created by DK on 9/28/15.
//  Copyright © 2015 Daniel H Klein. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    
    var partyChoice: String = "Democrat"
    
    var votingData = [NSManagedObject]()
    
    @IBOutlet weak var firstNameOutlet: UITextField!
    
    @IBOutlet weak var lastNameOutlet: UITextField!
    
    @IBOutlet weak var stateOutlet: UITextField!
    
    @IBOutlet weak var partyController: UISegmentedControl!
    
    @IBOutlet weak var saveOutlet: UILabel!
    
    @IBAction func partyAction(sender: UISegmentedControl) {
        switch partyController.selectedSegmentIndex
        {
        case 0:
            partyChoice = "Democrat"
        case 1:
            partyChoice = "Republican"
        default:
            break
        }
    }
    
    @IBAction func saveAction(sender: UIButton) {
        if (entriesFilled()) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entityForName("Candidate", inManagedObjectContext: managedContext)
            let candidate = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            candidate.setValue(firstNameOutlet.text!, forKey: "firstName")
            candidate.setValue(lastNameOutlet.text!, forKey: "lastName")
            candidate.setValue(stateOutlet.text!, forKey: "state")
            candidate.setValue(partyChoice, forKey: "party")
            candidate.setValue(0, forKey: "count")
            
            saveOutlet.text = "Candidate Saved!"
            firstNameOutlet.text = ""
            lastNameOutlet.text = ""
            stateOutlet.text = ""
            
            // Commit the changes.
            do {
                try managedContext.save()
            } catch {
                // what to do if an error occurs?
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            // Add the new entity to our array of managed objects
            votingData.append(candidate)
        }
        else {
            let alertController:UIAlertController = UIAlertController(title: "Improper Input", message: "Please fill out all fields", preferredStyle: .ActionSheet)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func entriesFilled() -> Bool {
        if (firstNameOutlet.text != "" && lastNameOutlet.text != "" && stateOutlet.text != "") {
            return true
        }
        return false
    }
}


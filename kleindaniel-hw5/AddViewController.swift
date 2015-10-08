//
//  AddViewController.swift
//  kleindaniel-hw4
//
//  Created by DK on 9/28/15.
//  Copyright © 2015 Daniel H Klein. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, DataModelProtocol {
    
    var partyChoice: String = "Democrat"
    
    var votingData = [NSManagedObject]()
    
    @IBOutlet weak var firstNameOutlet: UITextField!
    
    @IBOutlet weak var lastNameOutlet: UITextField!
    
    @IBOutlet weak var stateOutlet: UITextField!
    
    @IBOutlet weak var partyController: UISegmentedControl!
    
    func notify(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alertController:UIAlertController = UIAlertController(title: "New Candidate", message: message, preferredStyle: .ActionSheet)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //changes value of partyChoice based on slider
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
    
    //saves information on new candidate
    @IBAction func saveAction(sender: UIButton) {
        if (entriesFilled()) {
            //set up CoreData for save
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entityForName("Candidate", inManagedObjectContext: managedContext)
            let candidate = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            
            //save values
            candidate.setValue(firstNameOutlet.text!, forKey: "firstName")
            candidate.setValue(lastNameOutlet.text!, forKey: "lastName")
            candidate.setValue(stateOutlet.text!, forKey: "state")
            candidate.setValue(partyChoice, forKey: "party")
            candidate.setValue(0, forKey: "count")
            
            //reset fields
            firstNameOutlet.text = ""
            lastNameOutlet.text = ""
            stateOutlet.text = ""
            self.firstNameOutlet.becomeFirstResponder()
            
            // Commit the changes
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            // Add the new entity to our array of managed objects
            votingData.append(candidate)
            
            //alert that candidate was added
            let alertController:UIAlertController = UIAlertController(title: "Candidate Added!", message: "\(firstNameOutlet.text!) \(lastNameOutlet.text!) added to the list of candidates.", preferredStyle: .ActionSheet)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            //popup error if fields are not filled out
            dispatch_sync(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                let alertController:UIAlertController = UIAlertController(title: "Improper Input", message: "Please fill out all fields", preferredStyle: .ActionSheet)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in }
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //import CoreData info
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
    
    //verify no fields are blank
    func entriesFilled() -> Bool {
        if (firstNameOutlet.text != "" && lastNameOutlet.text != "" && stateOutlet.text != "") {
            return true
        }
        return false
    }
}


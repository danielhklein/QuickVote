//
//  ViewController.swift
//  kleindaniel-hw4
//
//  Created by DK on 9/28/15.
//  Copyright © 2015 Daniel H Klein. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var voteOutlet: UIButton!
    
    @IBOutlet weak var showVotesOutlet: UIButton!
    
    @IBAction func voteAction(sender: AnyObject) {
        let popoverController = VotePopoverViewController()
        popoverController.presentPopover(sourceController: self, sourceView: self.voteOutlet, sourceRect: self.voteOutlet.bounds)
    }
    
    @IBAction func showVotesAction(sender: AnyObject) {
        let popoverController = VoteResultPopoverViewController()
        popoverController.presentPopover(sourceController: self, sourceView: self.showVotesOutlet, sourceRect: self.showVotesOutlet.bounds)
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: (238/255), green: (238/255), blue: (238/255), alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


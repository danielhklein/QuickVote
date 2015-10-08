//
//  VotePopoverViewController.swift
//  kleindaniel-hw4
//
//  Created by DK on 9/28/15.
//  Copyright © 2015 Daniel H Klein. All rights reserved.
//

import UIKit

class VoteResultPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var voteController: VoteResultTableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //create and run table view to be presented within the popover controller
    func presentPopover(sourceController sourceController:UIViewController, sourceView:UIView, sourceRect:CGRect) {
        self.voteController = VoteResultTableViewController(title: "Results", preferredContentSize: CGSize(width: 300, height: 200))
        self.voteController?.view
        self.voteController?.tableView.layoutIfNeeded()
        let popoverMenuViewController = self.voteController!.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sourceView
        popoverMenuViewController?.sourceRect = sourceRect
        sourceController.presentViewController(self.voteController!, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}

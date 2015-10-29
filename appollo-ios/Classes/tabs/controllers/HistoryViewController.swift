//
//  HistoryTabBarController.swift
//  appollo-ios
//
//  Created by Student on 10/28/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

    var shoppingHistory: [ShoppingCart]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingHistory = ShoppingCart.query(["closed": 1]) as! [ShoppingCart]
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? HistoryTableViewCell {
            let index = tableView.indexPathForCell(cell)!
            if let vc = segue.destinationViewController as? ShoppingCartTableViewController {
                vc.configure(shoppingHistory[index.item], readOnly: true)
            }
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        // add the action button you want to show when swiping on tableView's cell , in this case add the delete button.
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action , indexPath) -> Void in
            
            let item = self.shoppingHistory[indexPath.item]
            self.shoppingHistory.removeAtIndex(indexPath.item)

            item.delete()
            item.save()
//            backgroundThread(0, background: { () -> Void in
//
//            })
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        })
        
        // You can set its properties like normal button
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cartCell") as! HistoryTableViewCell
        cell.configure(shoppingHistory[indexPath.item])
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingHistory.count
    }

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
}

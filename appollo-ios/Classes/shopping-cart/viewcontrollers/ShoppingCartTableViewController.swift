//
//  CarrinhoTableViewController.swift
//  appollo-ios
//
//  Created by Student on 10/23/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import UIKit

class ShoppingCartTableViewController: UITableViewController {

    @IBOutlet var totalCountProducts: UILabel!
    @IBOutlet var totalSum: UILabel!
    
    var readOnly: Bool = false
    var shoppingCart: ShoppingCart!
    var shoppingCartItem: ShoppingCartItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        if !readOnly {
            let openedCarts = ShoppingCart.query(["closed": 0]) as! [ShoppingCart]
            shoppingCart = openedCarts[0]
            self.tableView.reloadData()
        }
        self.updateTotalTitle()
    }
    
    func updateTotalTitle() {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        
        let total = shoppingCart.total()
        let totalFormatted = formatter.stringFromNumber(total)
        
        // print("Total: \(total) - formatted: \(totalFormatted)")
        
        totalSum.text = totalFormatted
        totalCountProducts.text = "\(shoppingCart.items!.count) products"
        
        self.navigationItem.title = totalFormatted
    }

    func configure(cart: ShoppingCart, readOnly: Bool = false) {
        self.shoppingCart = cart
        self.readOnly = readOnly
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return shoppingCart != nil && shoppingCart.items != nil ? shoppingCart.items!.count : 0
        }
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ShoppingCartTableViewCell
            cell.configure(shoppingCart.items![indexPath.item] as! ShoppingCartItem)

            return cell
        }
        
        return UITableViewCell()
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        // add the action button you want to show when swiping on tableView's cell , in this case add the delete button.
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action , indexPath) -> Void in

            let item = self.shoppingCart.items![indexPath.item] as! ShoppingCartItem
            
            let mutableSet = self.shoppingCart.items?.mutableCopy() as! NSMutableOrderedSet
            mutableSet.removeObjectAtIndex(indexPath.item)
            self.shoppingCart.items = mutableSet

            backgroundThread(0, background: { () -> Void in
                item.delete()
                self.shoppingCart.save()
            })
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            self.updateTotalTitle()
        })
        
        // You can set its properties like normal button
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destinationViewController as? AddProductViewController {
            vc.shoppingCart = shoppingCart
        }
    }
    
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
    }

}

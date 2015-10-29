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
            fetchOpenedCart()
            self.tableView.reloadData()
        }
        self.updateTotalTitle()
    }
    
    @IBAction func actionButtonTouch(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Checkout cart", style: UIAlertActionStyle.Default, handler: { (action) in
            self.checkoutCart()
        }))
        alert.addAction(UIAlertAction(title: "Clear products", style: UIAlertActionStyle.Destructive, handler: { (action) in
            for item in self.shoppingCart.items!.array as! [ShoppingCartItem] {
                item.delete()
                item.save()
            }
            self.shoppingCart.items = NSOrderedSet()
            self.shoppingCart.save()
            self.updateTotalTitle()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkoutCart() {
        let alert = UIAlertController(title: "Where are you?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField: UITextField) in
            textField.placeholder = "Supermarket name"
        })
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            let textField = alert.textFields![0]
            self.shoppingCart.local = textField.text
            self.shoppingCart.closed = 1
            self.shoppingCart.dateCreated = NSDate()
            self.shoppingCart.save()
            self.fetchOpenedCart()
            self.updateTotalTitle()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fetchOpenedCart() {
        let openedCarts = ShoppingCart.query(["closed": 0]) as! [ShoppingCart]
        if openedCarts.count > 0 {
            shoppingCart = openedCarts[0]
        } else {
            shoppingCart = ShoppingCart.create() as! ShoppingCart
        }
        self.tableView.reloadData()
    }
    
    func updateTotalTitle() {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        
        let total = shoppingCart.total()
        let totalFormatted = formatter.stringFromNumber(total)
        
        // print("Total: \(total) - formatted: \(totalFormatted)")
        
        totalSum.text = totalFormatted
        totalCountProducts.text = {
            switch (shoppingCart.items!.count) {
                case 0: return "No products"
                case 1: return "\(shoppingCart.items!.count) product"
                default: return "\(shoppingCart.items!.count) products"
            }
        }()
        
        if readOnly {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            formatter.locale = NSLocale(localeIdentifier: "pt_BR")
            self.navigationItem.title = formatter.stringFromDate(shoppingCart.dateCreated)
        } else {
            if let btn = self.navigationItem.leftBarButtonItem {
                btn.enabled = (shoppingCart.items!.count == 0 ? false : true)
            }
            self.navigationItem.title = totalFormatted
        }
        
    }

    func configure(cart: ShoppingCart, readOnly: Bool = false) {
        self.shoppingCart = cart
        self.readOnly = readOnly
        if readOnly {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
        }
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

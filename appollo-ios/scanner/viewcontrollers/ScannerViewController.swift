//
//  ScannerViewController.swift
//  appollo-ios
//
//  Created by Student on 10/29/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import UIKit

class ScannerViewController: UIViewController {

	@IBOutlet weak var barCodeView: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerForNotification()

        // Do any additional setup after loading the view.
//		let barCodeScanner = (self.storyboard?.instantiateViewControllerWithIdentifier("ScannerBarCodeViewController")) as! ScannerBarCodeViewController
//
//		barCodeScanner.tapHandler = { point in
//			print(point)
//		}
//		
//		barCodeScanner.barcodesHandler = { barcodes in
//			for barcode in barcodes {
//				print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
//				self.barCodeView.text = barcode.stringValue
//				barCodeScanner.dismissViewControllerAnimated(true, completion: nil)
//			}
//		}
//		
//		self.presentViewController(barCodeScanner, animated: true, completion: nil)
    }

    func startScan() {
        let barCodeScanner = (self.storyboard?.instantiateViewControllerWithIdentifier("ScannerPriceTagViewController")) as! ScannerPriceTagViewController
        self.presentViewController(barCodeScanner, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerForNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReadPriceLabel:", name: kDidReadPriceLabelNotification, object: nil)
        
    }
    
    func didReadPriceLabel(notification: NSNotification) {
        let price = notification.userInfo!["price"] as! Double
        
        barCodeView.text = "\(price)"
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

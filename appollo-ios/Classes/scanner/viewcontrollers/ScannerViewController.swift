//
//  ScannerViewController.swift
//  appollo-ios
//
//  Created by Student on 10/29/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, ProductDelegate {

	@IBOutlet weak var barCodeView: UILabel!
	@IBOutlet weak var productImageView: UIImageView!
	
	var service = ProductService()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerForNotification()

		service.delegate = self
        // Do any additional setup after loading the view.
    }

    func startScan() {
        let barCodeScanner = (self.storyboard?.instantiateViewControllerWithIdentifier("ScannerBarCodeViewController")) as! ScannerBarCodeViewController
        
        self.presentViewController(barCodeScanner, animated: true, completion: nil)
    }
    
    func startScanPrice() {
        let barCodeScanner = (self.storyboard?.instantiateViewControllerWithIdentifier("ScannerPriceTagViewController")) as! ScannerPriceTagViewController
        self.presentViewController(barCodeScanner, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerForNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReadPriceLabel:", name: kDidReadPriceLabelNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReadBarcode:", name: kDidReadBarCodeNotification, object: nil)
        
    }
    
    func didReadBarcode(notification: NSNotification) {
        let barcodes = notification.userInfo!["barcodes"] as! [AVMetadataMachineReadableCodeObject]
		
		// Adds a status below the circle
		KVNProgress.showWithStatus("Buscando")
		
        // search in the database for this product
		service.findByBarcode(barcodes[0])
        
        // if has a recent price for this supermarket ask teh user if the price is uptodate
        
        // if the price is not uptodate
		//self.startScanPrice()
        
    }
    
    func didReadPriceLabel(notification: NSNotification) {
        let price = notification.userInfo!["price"] as! Double
        barCodeView.text = "\(price)"
		
		// ir para a tela de inclusao com o campos preenchidos
		
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
	
	// MARK: Product Delegate
	
	func didFoundProduct(product: Product?) {
		
		barCodeView.text = "Nenhum Produto Encontrado"
		productImageView.image = nil
		
		if let prd = product {
			if let img = prd.image {
				productImageView.image = UIImage(data: img)
			} else {
				print("sem imagem cadastrada")
			}
			barCodeView.text = prd.name
		}
		KVNProgress.dismiss()

		//		print(product)
		
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

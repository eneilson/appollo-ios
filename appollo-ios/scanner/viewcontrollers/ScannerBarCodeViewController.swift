//
//  ScannerBarCodeViewController.swift
//  appollo-ios
//
//  Created by Student on 10/29/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import UIKit

class ScannerBarCodeViewController: RSCodeReaderViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.focusMarkLayer.strokeColor = UIColor.blackColor().CGColor
		
		self.cornersLayer.strokeColor = UIColor.redColor().CGColor
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

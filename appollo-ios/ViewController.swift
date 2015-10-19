//
//  ViewController.swift
//  appollo-ios
//
//  Created by Student on 10/19/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnpushed(sender: AnyObject) {
        textView.text = "teste"
    }

}


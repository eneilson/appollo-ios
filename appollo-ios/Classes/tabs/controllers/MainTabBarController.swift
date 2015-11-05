//
//  MainTabBarController.swift
//  appollo-ios
//
//  Created by Francisco Ramos da Silva on 10/28/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    var button: UIButton = UIButton()
    
    var isHighLighted:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        //println("aaa")
        let middleImage:UIImage = UIImage(named: "Barcode Scanner")!.imageWithRenderingMode(.AlwaysTemplate)
        let highlightedMiddleImage:UIImage = UIImage(named: "Barcode Scanner")!.imageWithRenderingMode(.AlwaysTemplate)
        
        addCenterButtonWithImage(middleImage, highlightImage: highlightedMiddleImage)
        
        //changeTabToMiddleTab(button)
        
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if !(viewController is ScannerBarCodeViewController) {
            button.userInteractionEnabled = true
            button.highlighted = false
            button.selected = false
            isHighLighted = false
        } else {
            button.userInteractionEnabled = false
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if  self.selectedViewController == viewController {
            return false
        }
        
        return true
    }
    
    func addCenterButtonWithImage(buttonImage: UIImage, highlightImage:UIImage?) {
        
        let frame = CGRectMake(0.0, 0.0, 70, 70)
        button = UIButton(frame: frame)
        
        button.setImage(buttonImage, forState: .Normal)
        button.setImage(highlightImage, forState: .Highlighted)

        button.backgroundColor = UIColor(hex: SaveThePiggyApperance.mainColor)
        button.contentMode = .ScaleAspectFit
        button.tintColor = UIColor.whiteColor()
        
        button.layer.cornerRadius = button.frame.size.width / 2
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: "changeTabToMiddleTab:", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        
        self.button.addConstraint(NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: 70))
        self.button.addConstraint(NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 70))
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .BottomMargin, multiplier: 1, constant: 1))
    }
    
    
    func changeTabToMiddleTab(sender:UIButton) {

        let selectedIndex = Int(self.viewControllers!.count/2)
        self.selectedIndex = selectedIndex
        self.selectedViewController = (self.viewControllers as [AnyObject]?)?[selectedIndex] as? UIViewController
        
        (self.selectedViewController as! ScannerViewController).startScan()
        
        dispatch_async(dispatch_get_main_queue(), {
            
            if self.isHighLighted == false{
                sender.highlighted = true;
                self.isHighLighted = true
            }else{
                sender.highlighted = false;
                self.isHighLighted = false
            }
        });
        
        sender.userInteractionEnabled = false
        
    }
}

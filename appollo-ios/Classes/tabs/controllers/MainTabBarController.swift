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
//        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
//        button.setBackgroundImage(highlightImage, forState: UIControlState.Highlighted)
        button.contentMode = .ScaleAspectFit
        
//        UIButton.appearanceWhenContainedInInstancesOfClasses([UITabBar)).tintColor = UIColor.whiteColor()
        button.tintColor = UIColor.whiteColor()
        
        let heightDifference:CGFloat = buttonImage.size.height - self.tabBar.frame.size.height
        if heightDifference < 0 {
            button.center = self.tabBar.center;
        } else {
            var center: CGPoint = self.tabBar.center;
            center.y = center.y - heightDifference / 2.0;
            button.center = center;
        }
        
        button.layer.cornerRadius = button.frame.size.width / 2
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: "changeTabToMiddleTab:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
    }
    
    
    func changeTabToMiddleTab(sender:UIButton) {

        let selectedIndex = Int(self.viewControllers!.count/2)
        self.selectedIndex = selectedIndex
        self.selectedViewController = (self.viewControllers as [AnyObject]?)?[selectedIndex] as? UIViewController
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

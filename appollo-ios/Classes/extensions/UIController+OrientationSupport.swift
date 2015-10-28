//
//  UIController+OrientationSupport.swift
//  appollo-ios
//
//  Created by Francisco Ramos da Silva on 10/28/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    public override func shouldAutorotate() -> Bool {
        return visibleViewController?.shouldAutorotate() ?? false
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let vc = visibleViewController {
            if !(vc is UIAlertController) {
                return vc.supportedInterfaceOrientations()
            }
        }
        return super.supportedInterfaceOrientations()
    }
    
}

extension UITabBarController {
    
    public override func shouldAutorotate() -> Bool {
        return selectedViewController?.shouldAutorotate() ?? false
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let vc = selectedViewController {
            return vc.supportedInterfaceOrientations()
        }
        return super.supportedInterfaceOrientations()
    }
    
}
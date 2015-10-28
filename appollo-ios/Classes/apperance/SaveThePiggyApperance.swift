//
//  SaveThePiggyApperance.swift
//  appollo-ios
//
//  Created by Francisco Ramos da Silva on 10/28/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation

class SaveThePiggyApperance {

    static var mainColor = 0xc64d44
    
    class func apply() {
        
        let tabBar = UITabBar.appearance()
        //let tabBarItem = UITabBarItem.appearance()
        
//        let backgroundColor: UIColor = UIColor(hex: 0xF0AD4E) // #f0ad4e ou #ec971f
    
        tabBar.tintColor = UIColor(hex: mainColor)
//        tabBar.backgroundImage = SaveThePiggyApperance.imageFromColor(backgroundColor, forSize: CGSizeMake(320, 49), withCornerRadius: 0)
        // tabBar.selectedImageTintColor = UIColor.whiteColor()
        // tabBar.shadowImage = nil
        // tabBar.selectionIndicatorImage = SaveThePiggyApperance.imageFromColor(UIColor(red: 26 / 255.0, green: 163 / 255.0, blue: 133 / 255.0, alpha: 1), forSize: CGSizeMake(64, 49), withCornerRadius: 0)
        
//        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
//        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(hex: 0xF0E1A7)], forState: .Normal)
        
        let navBar = UINavigationBar.appearance()
        
        navBar.barStyle = UIBarStyle.Default
        navBar.tintColor = UIColor(hex: mainColor)
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(hex: mainColor)]
        
        UIBarButtonItem.appearance().tintColor = UIColor(hex: mainColor)
        UIButton.appearance().tintColor = UIColor(hex: mainColor)
        
        UIStepper.appearance().tintColor = UIColor(hex: mainColor)
        
    }
    
    class func imageFromColor(color: UIColor, forSize size: CGSize, withCornerRadius radius: CGFloat) -> UIImage {
        let rect: CGRect = CGRectMake(0, 0, size.width, size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIGraphicsBeginImageContext(size)
        
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        image.drawInRect(rect)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
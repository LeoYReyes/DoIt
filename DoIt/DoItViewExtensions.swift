//
//  DoItViewExtensions.swift
//  DoIt
//
//  Created by Leo Reyes on 3/22/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit

extension UIView {
    
    func setDefaultBackground() {
        self.backgroundColor = UIColor.clearColor()
        
        // RGB values for UIColors are between 0 and 1
        let redTop = CGFloat(57.0 / 255.0)
        let greenTop = CGFloat(69.0 / 255.0)
        let blueTop = CGFloat(89.0 / 255.0)
        let topColor = UIColor(red: redTop, green: greenTop, blue: blueTop, alpha: 1.0).CGColor
        
        let redBottom = CGFloat(91.0 / 255.0)
        let greenBottom = CGFloat(105.0 / 255.0)
        let blueBottom = CGFloat(133.0 / 255.0)
        let bottomColor = UIColor(red: redBottom, green: greenBottom, blue: blueBottom, alpha: 1.0).CGColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        
        gradientLayer.frame = self.frame
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    func addNavbar(withTitle: String, withLeftBarButtonItem: UIBarButtonItem? = nil, withRightBarButtonItem: UIBarButtonItem? = nil) {
        let navBar = UINavigationBar()
        let navItems = UINavigationItem(title: withTitle)
        navItems.leftBarButtonItem = withLeftBarButtonItem
        navItems.rightBarButtonItem = withRightBarButtonItem
        navBar.setItems([navItems], animated: false)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.shadowImage = UIImage()
        navBar.translucent = true
        navBar.backgroundColor = UIColor.clearColor()
        
        let textAttributes = [NSForegroundColorAttributeName : navbarTextColor()]
        navBar.titleTextAttributes = textAttributes
        navBar.tintColor = navbarTextColor()
        
        self.addSubview(navBar)
        self.addConstraint(NSLayoutConstraint(item: navBar, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 20.0))
        self.addConstraint(NSLayoutConstraint(item: navBar, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: navBar, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
    }
    
    private func navbarTextColor() -> UIColor {
        let navTintRed = CGFloat(74.0 / 255.0)
        let navTintGreen = CGFloat(144.0 / 255.0)
        let navTintBlue = CGFloat(226.0 / 255.0)
        let navTintColor = UIColor(red: navTintRed, green: navTintGreen, blue: navTintBlue, alpha: 1.0)
        
        return navTintColor
    }
    
}

extension UITextField {
    
    func addBottomBorder() {
        let border = CALayer()
        let borderWidth: CGFloat = 0.75
        border.backgroundColor = UIColor.grayColor().CGColor
        border.frame = CGRectMake(0.0, self.frame.size.height - borderWidth, self.frame.width, borderWidth)
        self.borderStyle = .None
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
//
//  AddButton.swift
//  DoIt
//
//  Created by Leo Reyes on 3/30/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit

class AddButton: UIButton {
    
    //image
    let image = UIImage(named: "add_icon")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(target: AnyObject?, action: Selector) {
        self.init(frame: CGRectZero)
        self.setImage(image, forState: .Normal)
        self.addTarget(target, action: action, forControlEvents: .TouchDown)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

//
//  CheckBox.swift
//  DoIt
//
//  Created by Leo Reyes on 3/15/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    //images
    let checkedImage = UIImage(named: "checkbox_checked")
    let uncheckedImage = UIImage(named: "checkbox_unchecked")
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(uncheckedImage, forState: .Normal)
        self.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        self.isChecked = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if(sender == self) {
            isChecked = !isChecked
        }
    }
    
}

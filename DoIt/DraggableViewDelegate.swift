//
//  CardSwipeDelegate.swift
//  DoIt
//
//  Created by Leo Reyes on 3/8/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit

protocol DraggableViewDelegate {
    func swipedRight(view: UIView)
    func swipedLeft(view: UIView)
}

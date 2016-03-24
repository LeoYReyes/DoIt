//
//  SSDraggableView.swift
//  ThatsWhat
//
//  Created by Leo Reyes on 11/10/15.
//  Copyright © 2015 Leo Reyes. All rights reserved.
//

import UIKit

let SWIPE_MARGIN = 160

class DraggableView: UIView {
    
    var delegate: DraggableViewDelegate?
    var originalPoint = CGPoint(x: 0, y: 0)
    var xDistance: CGFloat = 0.0
    var yDistance: CGFloat = 0.0
    var dataIndex = -1
    var _contentView: UIView?
    
    //TODO: Refactor initalizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    init(contentView: UIView) {
        super.init(frame: CGRect(x: 38, y: 134, width: 300, height: 400))
        _contentView = contentView
        self.addSubview(_contentView!)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        self.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        self.xDistance = gestureRecognizer.translationInView(self).x
        self.yDistance = gestureRecognizer.translationInView(self).y
        
        switch(gestureRecognizer.state) {
        case UIGestureRecognizerState.Began:
            self.originalPoint = self.center
            break
        case UIGestureRecognizerState.Changed:
            let rotationStrength = min(xDistance / 320, 1)
            let rotationAngle = (CGFloat(2 * M_PI) * rotationStrength / 16)
            let scaleStrength = (1 as Float) - Float(rotationStrength) / 4
            let scale = max(scaleStrength, 0.93)
            
            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance)
            let transform = CGAffineTransformMakeRotation(rotationAngle)
            let scaleTransform = CGAffineTransformScale(transform, CGFloat(scale), CGFloat(scale))
            self.transform = scaleTransform
            
            break
        case UIGestureRecognizerState.Ended:
            swipeAction(xDistance)
            break
        case UIGestureRecognizerState.Possible: break
        case UIGestureRecognizerState.Cancelled: break
        case UIGestureRecognizerState.Failed: break
        }
    }
    
    func swipeAction(distance: CGFloat) {
        let userSwipedRight = distance > CGFloat(SWIPE_MARGIN)
        let userSwipedLeft = distance < CGFloat(-SWIPE_MARGIN)
        if userSwipedRight {
            rightSwipe()
        } else if userSwipedLeft {
            leftSwipe()
        } else {
            resetView()
        }
    }
    
    func rightSwipe() {
        //HACK: Hard coded finish position of view instead of calculating it relative to the view
        let finishPoint = CGPointMake(500, 2 * self.yDistance + self.originalPoint.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            }, completion: { _ in
                self.removeFromSuperview()
        })
        delegate?.swipedRight(self)
    }
    
    func leftSwipe() {
        //HACK: Hard coded finish position of view instead of calculating it relative to the view
        let finishPoint = CGPointMake(-500, 2 * self.yDistance + self.originalPoint.y)
        UIView.animateWithDuration(0.4, animations: {
            self.center = finishPoint
            }, completion: { _ in
                self.removeFromSuperview()
        })
        delegate?.swipedLeft(self)
    }
    
    func resetView() {
        UIView.animateWithDuration(0.2, animations: {
            self.center = self.originalPoint
            self.transform = CGAffineTransformMakeRotation(0)
        })
    }
    
}

//
//  StrengthTaskCardView.swift
//  DoIt
//
//  Created by Leo Reyes on 3/8/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit

class TaskCardView: UIView {
    
    var taskNameLabel: UILabel
    var repsLabel: UILabel?
    var setsLabel: UILabel?
    var weightLabel: UILabel?
    var durationLabel: UILabel?
    var distanceLabel: UILabel?
    
    var stackView: UIStackView
    
    var timerStartButton: UIButton?
    var timer = NSTimer()
    var count = 0
    
    init(task: Task) {
        
        let titleSeparator = UIBezierPath()
        titleSeparator.moveToPoint(CGPoint(x: 12, y: 65))
        titleSeparator.addLineToPoint(CGPoint(x: 287, y: 65))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = titleSeparator.CGPath
        shapeLayer.strokeColor = UIColor.blackColor().CGColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        
        
        self.taskNameLabel = UILabel(frame: CGRectMake(40, 19, 220, 34))
        self.taskNameLabel.textColor = UIColor.blackColor()
        self.taskNameLabel.textAlignment = .Center
        self.taskNameLabel.text = task.name
        
        self.stackView = UIStackView()
        self.stackView.axis = .Vertical
        self.stackView.spacing = 13
        self.stackView.distribution = .EqualSpacing
        self.stackView.alignment = .Center
        self.stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        if task.reps > -1 {
            self.repsLabel = UILabel()
            self.repsLabel!.textColor = UIColor.blackColor()
            self.repsLabel!.textAlignment = .Center
            self.repsLabel!.text = String(task.reps) + " reps"
            self.repsLabel!.heightAnchor.constraintEqualToConstant(45).active = true
            self.repsLabel!.widthAnchor.constraintEqualToConstant(200).active = true
            self.stackView.addArrangedSubview(self.repsLabel!)
        }
        if task.sets > -1 {
            self.setsLabel = UILabel()
            self.setsLabel!.textColor = UIColor.blackColor()
            self.setsLabel!.textAlignment = .Center
            self.setsLabel!.text = String(task.sets) + " sets"
            self.setsLabel!.heightAnchor.constraintEqualToConstant(45).active = true
            self.setsLabel!.widthAnchor.constraintEqualToConstant(200).active = true
            self.stackView.addArrangedSubview(self.setsLabel!)
        }
        if task.weight > -1 {
            self.weightLabel = UILabel()
            self.weightLabel!.textColor = UIColor.blackColor()
            self.weightLabel!.textAlignment = .Center
            self.weightLabel!.text = String(task.weight) + " lbs"
            self.weightLabel!.heightAnchor.constraintEqualToConstant(45).active = true
            self.weightLabel!.widthAnchor.constraintEqualToConstant(200).active = true
            self.stackView.addArrangedSubview(self.weightLabel!)
        }
        if task.duration > -1 {
            self.durationLabel = UILabel()
            self.durationLabel!.textColor = UIColor.blackColor()
            self.durationLabel!.textAlignment = .Center
            self.durationLabel!.text = String(task.duration) + " seconds"
            self.durationLabel!.heightAnchor.constraintEqualToConstant(45).active = true
            self.durationLabel!.widthAnchor.constraintEqualToConstant(200).active = true
            self.stackView.addArrangedSubview(self.durationLabel!)
            
            self.timerStartButton = UIButton()
            self.timerStartButton?.setTitle("Start", forState: .Normal)
            self.timerStartButton?.heightAnchor.constraintEqualToConstant(50).active = true
            self.timerStartButton?.widthAnchor.constraintEqualToConstant(50).active = true
            self.timerStartButton?.showsTouchWhenHighlighted = true
            self.timerStartButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.timerStartButton?.backgroundColor = UIColor(red: CGFloat(74.0 / 255.0), green: CGFloat(144.0 / 255.0), blue: CGFloat(226.0 / 255.0), alpha: 1.0)
            self.timerStartButton?.layer.cornerRadius = 25.0
            self.timerStartButton?.layer.borderColor = UIColor.clearColor().CGColor
            self.timerStartButton?.layer.borderWidth = 0.5
            self.stackView.addArrangedSubview(self.timerStartButton!)
            count = Int(task.duration)
        }
        if task.distance > -1 {
            self.distanceLabel = UILabel()
            self.distanceLabel!.textColor = UIColor.blackColor()
            self.distanceLabel!.textAlignment = .Center
            self.distanceLabel!.text = String(task.distance) + " miles"
            self.distanceLabel!.heightAnchor.constraintEqualToConstant(45).active = true
            self.distanceLabel!.widthAnchor.constraintEqualToConstant(200).active = true
            self.stackView.addArrangedSubview(self.distanceLabel!)
        }
        
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        
        self.timerStartButton?.addTarget(self, action: "startTime", forControlEvents: .TouchDown)
        
        self.backgroundColor = UIColor(red: CGFloat(216.0 / 255.0), green: CGFloat(216.0 / 255.0), blue: CGFloat(216.0 / 255.0), alpha: 1.0)
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
        
        self.addSubview(self.taskNameLabel)
        self.layer.addSublayer(shapeLayer)
        self.addSubview(self.stackView)
        
        self.addConstraint(NSLayoutConstraint(item: self.stackView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 20.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: self.stackView, attribute: .Trailing, multiplier: 1.0, constant: 20.0))
        self.addConstraint(NSLayoutConstraint(item: self.stackView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 90.0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startTime() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countDown", userInfo: nil, repeats: true)
    }
    
    func countDown() {
        count -= 1
        if (count == 0) {
            self.timer.invalidate()
        }
        updateDurationText()
    }
    
    func updateDurationText() {
        let text = String(count)
        self.durationLabel?.text = text
    }
    
}

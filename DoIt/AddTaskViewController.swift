//
//  AddTaskViewController.swift
//  DoIt
//
//  Created by Leo Reyes on 3/14/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit

protocol AddAttributeDelegate {
    func addAttributes(shouldAddReps: Bool, shouldAddSets: Bool, shouldAddWeight: Bool, shouldAddDuration: Bool, shouldAddDistance: Bool)
}

class AddTaskViewController: UIViewController, AddAttributeDelegate {
    
    var stackView: UIStackView
    
    var taskNameInput: UITextField
    var repsInput: UITextField?
    var setsInput: UITextField?
    var weightInput: UITextField?
    var durationInput: UITextField?
    var distanceInput: UITextField?
    
    //var doneButton: UIButton
    
    var addAttributeButton: UIButton
    
    var manageTaskDelegate: ManageTaskDelegate?
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.stackView = UIStackView()
        self.stackView.axis = .Vertical
        self.stackView.spacing = 13
        self.stackView.distribution = .EqualSpacing
        self.stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.taskNameInput = UITextField()
        self.taskNameInput.heightAnchor.constraintEqualToConstant(45).active = true
        self.taskNameInput.widthAnchor.constraintEqualToConstant(250).active = true
        self.taskNameInput.placeholder = "New Task"
        self.taskNameInput.textColor = UIColor.whiteColor()
        
        self.addAttributeButton = UIButton()
        self.addAttributeButton.heightAnchor.constraintEqualToConstant(50).active = true
        self.addAttributeButton.widthAnchor.constraintEqualToConstant(200).active = true
        self.addAttributeButton.setTitle("Add Attribute", forState: .Normal)
        self.addAttributeButton.showsTouchWhenHighlighted = true
        self.addAttributeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.addAttributeButton.backgroundColor = UIColor(red: CGFloat(74.0 / 255.0), green: CGFloat(144.0 / 255.0), blue: CGFloat(226.0 / 255.0), alpha: 1.0)
        self.addAttributeButton.layer.cornerRadius = 10.0
        self.addAttributeButton.layer.borderColor = UIColor.clearColor().CGColor
        self.addAttributeButton.layer.borderWidth = 0.5
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init(manageTaskDelegate: ManageTaskDelegate) {
        self.init(nibName: nil, bundle: nil)
        
        self.manageTaskDelegate = manageTaskDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setDefaultBackground()

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "done")
        self.view.addNavbar("Add Task", withLeftBarButtonItem: cancelButton, withRightBarButtonItem: doneButton)
        
        
        self.stackView.addArrangedSubview(self.taskNameInput)
        self.stackView.addArrangedSubview(self.addAttributeButton)
        
        self.addAttributeButton.addTarget(self, action: "addAttributeSelected", forControlEvents: .TouchDown)
        self.view.addSubview(stackView)
        self.view.addConstraint(NSLayoutConstraint(item: self.stackView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 64.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.stackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 40.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Trailing, relatedBy: .Equal, toItem: self.stackView, attribute: .Trailing, multiplier: 1.0, constant: 40.0))
    }
    
    override func viewDidAppear(animated: Bool) {
        //HACK: Adding border after autolayout has initialized the views, otherwise we can't get the size of the frame
        self.taskNameInput.addBottomBorder()
    }
    
    func addAttributeSelected() {
        let addAttributeViewController = AddAttributeViewController()
        addAttributeViewController.modalPresentationStyle = .OverCurrentContext
        addAttributeViewController.addAttributeDelegate = self
        self.presentViewController(addAttributeViewController, animated: true, completion: nil)
    }
    
    //MARK: AddAttributeDelegate
    func addAttributes(shouldAddReps: Bool, shouldAddSets: Bool, shouldAddWeight: Bool, shouldAddDuration: Bool, shouldAddDistance: Bool) {
        if shouldAddReps {
            addRepsInput()
        }
        if shouldAddSets {
            addSetsInput()
        }
        if shouldAddWeight {
            addWeightInput()
        }
        if shouldAddDuration {
            addDurationInput()
        }
        if shouldAddDistance {
            addDistanceInput()
        }
    }
    
    private func addRepsInput() {
        if repsInput == nil {
            let index = self.stackView.arrangedSubviews.count - 1
            self.repsInput = UITextField()
            self.repsInput?.hidden = true
            self.repsInput?.heightAnchor.constraintEqualToConstant(45).active = true
            self.repsInput?.widthAnchor.constraintEqualToConstant(200).active = true
            self.repsInput?.keyboardType = .NumberPad
            self.repsInput?.placeholder = "# of reps"
            self.repsInput?.textColor = UIColor.whiteColor()
            
            self.stackView.insertArrangedSubview(self.repsInput!, atIndex: index)
            UIView.animateWithDuration(0.25) { () -> Void in
                self.repsInput!.hidden = false
            }
            self.repsInput?.addBottomBorder()
        }
    }
    
    private func addSetsInput() {
        if setsInput == nil {
            let index = self.stackView.arrangedSubviews.count - 1
        
            self.setsInput = UITextField()
            self.setsInput?.hidden = true
            self.setsInput?.heightAnchor.constraintEqualToConstant(45).active = true
            self.setsInput?.widthAnchor.constraintEqualToConstant(200).active = true
            self.setsInput?.keyboardType = .NumberPad
            self.setsInput?.placeholder = "# of sets"
            self.setsInput?.textColor = UIColor.whiteColor()
            
            self.stackView.insertArrangedSubview(self.setsInput!, atIndex: index)
            UIView.animateWithDuration(0.25) { () -> Void in
                self.setsInput!.hidden = false
            }
            self.setsInput?.addBottomBorder()
        }
    }
    
    private func addWeightInput() {
        if weightInput == nil {
            let index = self.stackView.arrangedSubviews.count - 1
            self.weightInput = UITextField()
            self.weightInput?.hidden = true
            self.weightInput?.heightAnchor.constraintEqualToConstant(45).active = true
            self.weightInput?.widthAnchor.constraintEqualToConstant(200).active = true
            self.weightInput?.keyboardType = .NumberPad
            self.weightInput?.placeholder = "amount of weight"
            self.weightInput?.textColor = UIColor.whiteColor()
            
            self.stackView.addArrangedSubview(self.weightInput!)
            self.stackView.insertArrangedSubview(self.weightInput!, atIndex: index)
            UIView.animateWithDuration(0.25) { () -> Void in
                self.weightInput!.hidden = false
            }
            self.weightInput?.addBottomBorder()
        }
    }
    
    private func addDurationInput() {
        if durationInput == nil {
            let index = self.stackView.arrangedSubviews.count - 1
            self.durationInput = UITextField()
            self.durationInput?.hidden = true
            self.durationInput?.heightAnchor.constraintEqualToConstant(45).active = true
            self.durationInput?.widthAnchor.constraintEqualToConstant(200).active = true
            self.durationInput?.keyboardType = .NumberPad
            self.durationInput?.placeholder = "Enter duration"
            self.durationInput?.textColor = UIColor.whiteColor()
            
            self.stackView.addArrangedSubview(self.durationInput!)
            self.stackView.insertArrangedSubview(self.durationInput!, atIndex: index)
            UIView.animateWithDuration(0.25) { () -> Void in
                self.durationInput!.hidden = false
            }
            self.durationInput?.addBottomBorder()
        }
    }
    
    private func addDistanceInput() {
        if distanceInput == nil {
            let index = self.stackView.arrangedSubviews.count - 1
            self.distanceInput = UITextField()
            self.distanceInput?.hidden = true
            self.distanceInput?.heightAnchor.constraintEqualToConstant(45).active = true
            self.distanceInput?.widthAnchor.constraintEqualToConstant(200).active = true
            self.distanceInput?.keyboardType = .NumberPad
            self.distanceInput?.placeholder = "Enter duration"
            self.distanceInput?.textColor = UIColor.whiteColor()
            
            self.stackView.addArrangedSubview(self.distanceInput!)
            self.stackView.insertArrangedSubview(self.distanceInput!, atIndex: index)
            UIView.animateWithDuration(0.25) { () -> Void in
                self.distanceInput!.hidden = false
            }
            self.distanceInput?.addBottomBorder()
        }
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done() {
        let taskName = taskNameInput.text!
        let reps = (self.repsInput != nil) ? Int16(self.repsInput!.text!) : -1
        let sets = (self.setsInput != nil) ? Int16(self.setsInput!.text!) : -1
        let weight = (self.weightInput != nil) ? Int16(self.weightInput!.text!) : -1
        let duration = (self.durationInput != nil) ? Int32(self.durationInput!.text!) : -1
        let distance = (self.distanceInput != nil) ? Double(self.distanceInput!.text!) : -1
        
        manageTaskDelegate?.addTask(taskName, reps: reps!, sets: sets!, weight: weight!, duration: duration!, distance: distance!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
//
//  AddWorkoutViewController.swift
//  DoIt
//
//  Created by Leo Reyes on 3/1/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit

class AddWorkoutViewController: UIViewController, UITextFieldDelegate {
    
    var newWorkout: Workout?
    var manageWorkoutDelegate: ManageWorkoutDelegate?
    
    var workoutNameInput: UITextField?
    
    func done(sender: UIButton) {
        manageWorkoutDelegate!.addWorkout((workoutNameInput?.text!)!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        //TODO: create a view builder
        workoutNameInput = UITextField(frame: CGRect(x: 30, y: 100, width: 315, height:34))
        
        workoutNameInput?.placeholder = "New Workout"
        workoutNameInput?.textColor = UIColor.whiteColor()
        workoutNameInput?.addBottomBorder()
        
        self.view.addSubview(workoutNameInput!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.view.setDefaultBackground()

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel:")
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "done:")
        self.view.addNavbar("Add Workout", withLeftBarButtonItem: cancelButton, withRightBarButtonItem: doneButton)
        
    }
    
}
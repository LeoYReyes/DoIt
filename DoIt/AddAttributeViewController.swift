//
//  AddAttributeViewController.swift
//  DoIt
//
//  Created by Leo Reyes on 3/15/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit

class AddAttributeViewController: UIViewController {
    
    var stackView: UIStackView = UIStackView()
    
    var repsCheckBox: CheckBox?
    var setsCheckBox: CheckBox?
    var weightCheckBox: CheckBox?
    var durationCheckBox: CheckBox?
    var distanceCheckBox: CheckBox?

    var addAttributeDelegate: AddAttributeDelegate?
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.view.setDefaultBackground()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel:")
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "done:")
        self.view.addNavbar("Add Attribute", withLeftBarButtonItem: cancelButton, withRightBarButtonItem: doneButton)
        
        //stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 13
        stackView.alignment = .Fill
        stackView.distribution = .Fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        self.view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 89.0))
        self.view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 25.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Trailing, relatedBy: .Equal, toItem: stackView, attribute: .Trailing, multiplier: 1.0, constant: 25.0))

        self.repsCheckBox = createCheckBox()
        let repsView = createAttributeView("# of reps", checkbox: self.repsCheckBox!)
        stackView.addArrangedSubview(repsView)
        
        self.setsCheckBox = createCheckBox()
        let setsView = createAttributeView("# of sets", checkbox: self.setsCheckBox!)
        stackView.addArrangedSubview(setsView)
        
        self.weightCheckBox = createCheckBox()
        let weightView = createAttributeView("weight", checkbox: self.weightCheckBox!)
        stackView.addArrangedSubview(weightView)
        
        self.durationCheckBox = createCheckBox()
        let durationView = createAttributeView("duration", checkbox: self.durationCheckBox!)
        stackView.addArrangedSubview(durationView)
        
        self.distanceCheckBox = createCheckBox()
        let distanceView = createAttributeView("distance", checkbox: self.distanceCheckBox!)
        stackView.addArrangedSubview(distanceView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func done(sender: UIButton) {
        addAttributeDelegate?.addAttributes((repsCheckBox?.isChecked)!, shouldAddSets: (setsCheckBox?.isChecked)!, shouldAddWeight: (weightCheckBox?.isChecked)!, shouldAddDuration: (durationCheckBox?.isChecked)!, shouldAddDistance: (distanceCheckBox?.isChecked)!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createAttributeView(forAttribute: String, checkbox: CheckBox) -> UIStackView {
        
        let label = UILabel()
        label.text = forAttribute
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .Horizontal
        horizontalStackView.alignment = .Fill
        horizontalStackView.distribution = .FillProportionally
        horizontalStackView.spacing = 11
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStackView.addArrangedSubview(checkbox)
        horizontalStackView.addArrangedSubview(label)
        
        return horizontalStackView
    }
    
    func createCheckBox() -> CheckBox {
        let checkboxButton = CheckBox(frame: CGRectZero)
        checkboxButton.heightAnchor.constraintEqualToConstant(48)
        checkboxButton.widthAnchor.constraintEqualToConstant(48)
        return checkboxButton
    }
}

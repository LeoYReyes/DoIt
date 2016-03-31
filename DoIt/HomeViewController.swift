//
//  WorkoutsViewController.swift
//  DoIt
//
//  Created by Leo Reyes on 3/1/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit
import CoreData

import JSQCoreDataKit

protocol ManageWorkoutDelegate {
    func addWorkout(workoutName: String)
    func deleteWorkout(workout: Workout)
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ManageWorkoutDelegate {
    
    let tintColor = UIColor(red: CGFloat(74.0 / 255.0), green: CGFloat(144.0 / 255.0), blue: CGFloat(226.0 / 255.0), alpha: 1.0)
    
    var servicesContainer: ServicesContainer!
    var workoutServices: WorkoutServices!
    var stackView: UIStackView
    var workoutTableView: UITableView
    
    var workouts: [Workout]
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.stackView = UIStackView()
        self.workouts = [Workout]()
        self.workoutTableView = UITableView()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Setup stack view traits
        self.stackView.axis = .Vertical
        self.stackView.alignment = .Fill
        self.stackView.distribution = .Fill
        self.stackView.spacing = 10
        self.stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.workoutTableView.registerClass(WorkoutTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(WorkoutTableViewCell))
        
        self.stackView.addArrangedSubview(self.workoutTableView)
        
        let addWorkoutButton = AddButton(target: self, action: #selector(HomeViewController.addWorkoutSelected(_:)))
        self.stackView.addArrangedSubview(addWorkoutButton)
    }
    
    convenience init(servicesContainer: ServicesContainer) {
        self.init(nibName: nil, bundle: nil)
        self.servicesContainer = servicesContainer
        self.workoutServices = self.servicesContainer.getWorkoutServices()
        self.workouts = self.workoutServices.getAllWorkouts()
        self.workoutTableView.delegate = self
        self.workoutTableView.dataSource = self
        self.workoutTableView.backgroundColor = UIColor.clearColor()
        self.workoutTableView.separatorStyle = .None
    }

    required init?(coder aDecoder: NSCoder) {
        self.stackView = UIStackView()
        self.workouts = [Workout]()
        self.workoutTableView = UITableView()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.view.setDefaultBackground()
        setupNavbar()
        
        self.view.addSubview(self.stackView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.stackView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.stackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Trailing, relatedBy: .Equal, toItem: self.stackView, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: self.stackView, attribute: .Bottom, multiplier: 1.0, constant: 15.0))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.workoutTableView.reloadData()
    }
    
    func setupNavbar() {
        self.navigationItem.title = "DoIt"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
        let navTintRed = CGFloat(74.0 / 255.0)
        let navTintGreen = CGFloat(144.0 / 255.0)
        let navTintBlue = CGFloat(226.0 / 255.0)
        let navTintColor = UIColor(red: navTintRed, green: navTintGreen, blue: navTintBlue, alpha: 1.0)
        
        let textAttributes = [NSForegroundColorAttributeName : navTintColor]
        self.navigationController!.navigationBar.titleTextAttributes = textAttributes
        self.navigationController!.navigationBar.tintColor = navTintColor
    }
    
    func addWorkoutSelected(sender: UIButton) {
        let addWorkoutViewController = AddWorkoutViewController()
        addWorkoutViewController.modalPresentationStyle = .CurrentContext
        addWorkoutViewController.manageWorkoutDelegate = self
        self.presentViewController(addWorkoutViewController, animated: true, completion: nil)
    }

    //MARK: ManageWorkoutDelegate
    func addWorkout(workoutName: String) {
        let newWorkout = workoutServices.addWorkout(workoutName)
        self.workouts.append(newWorkout)
        self.workoutTableView.reloadData()
    }
    
    func deleteWorkout(workout: Workout) {
        self.workoutServices.deleteWorkout(workout)
        workouts.removeAtIndex(workouts.indexOf(workout)!)
        self.workoutTableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = NSStringFromClass(WorkoutTableViewCell)
        let cell = self.workoutTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTableViewCell
        let workout = self.workouts[indexPath.row]
        
        cell.selectionStyle = .None
        cell.textLabel!.text = workout.name
        cell.textLabel!.textColor = tintColor
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 75))
        let leftSeparatorLine = UIView(frame: CGRect(x: 0, y: 17, width: 146, height: 0.4))
        leftSeparatorLine.backgroundColor = UIColor.grayColor()
        let rightSeparatorLine = UIView(frame: CGRect(x: 230, y: 17, width: 146, height: 0.4))
        rightSeparatorLine.backgroundColor = UIColor.grayColor()

        let title: UILabel = UILabel(frame: CGRect(x: 150, y: 0, width: 75, height: 34))
        
        title.text = "My Workouts"
        title.textAlignment = .Center
        title.textColor = UIColor.whiteColor()
        title.backgroundColor = UIColor.clearColor()
        title.font = UIFont.boldSystemFontOfSize(10)

        headerView.addSubview(leftSeparatorLine)
        headerView.addSubview(title)
        headerView.addSubview(rightSeparatorLine)
        return headerView
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedWorkout = self.workouts[indexPath.row]
        let workoutViewController = WorkoutViewController(workout: selectedWorkout, servicesContainer: self.servicesContainer)
        workoutViewController.manageWorkoutDelegate = self
        self.navigationController?.pushViewController(workoutViewController, animated: true)
    }

}
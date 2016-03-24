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
    
    var stack: CoreDataStack!
    
    @IBOutlet var workoutTableView: UITableView?
    
    var workouts: [Workout]
    
    convenience init() {
        self.init()
        self.workoutTableView!.dataSource = self
        self.workoutTableView!.delegate = self
        self.workoutTableView!.registerClass(WorkoutTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(WorkoutTableViewCell))
        
        let model = CoreDataModel(name: DoItConstants.ModelName, bundle: NSBundle(identifier: DoItConstants.ModelBundle)!)
        let factory = CoreDataStackFactory(model: model)
        
        factory.createStackInBackground { (result: CoreDataStackResult) -> Void in
            switch result {
            case .Success(let s):
                self.stack = s
                
            case .Failure(let err):
                assertionFailure("Failure creating stack: \(err)")
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        //self.workoutTableView = WorkoutTableView()
        self.workouts = [Workout]()
        super.init(coder: aDecoder)
        
        let model = CoreDataModel(name: DoItConstants.ModelName, bundle: NSBundle(identifier: DoItConstants.ModelBundle)!)
        let factory = CoreDataStackFactory(model: model)
        
        factory.createStackInBackground { (result: CoreDataStackResult) -> Void in
            switch result {
            case .Success(let s):
                self.stack = s
                self.workouts = self.fetchWorkouts(self.stack.mainContext)
                self.workoutTableView!.dataSource = self
                self.workoutTableView!.delegate = self
                self.workoutTableView!.registerClass(WorkoutTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(WorkoutTableViewCell))
                self.workoutTableView?.separatorStyle = .None
                self.workoutTableView?.backgroundColor = UIColor.clearColor()
                self.workoutTableView!.reloadData()
            case .Failure(let err):
                assertionFailure("Failure creating stack: \(err)")
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.setDefaultBackground()

        setupNavbar()
        self.workoutTableView!.reloadData()
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
    
    @IBAction func addWorkoutClicked(sender: UIButton) {
        let addWorkoutViewController = AddWorkoutViewController()
        addWorkoutViewController.modalPresentationStyle = .CurrentContext
        addWorkoutViewController.manageWorkoutDelegate = self
        self.presentViewController(addWorkoutViewController, animated: true, completion: nil)
    }
    
    //MARK: Helpers
    
    func fetchWorkouts(context: NSManagedObjectContext) -> [Workout] {
        let e = entity(name: Workout.entityName, context: context)
        let request = FetchRequest<Workout>(entity: e)
        var fetchedWorkouts = [Workout]()
        do {
            fetchedWorkouts = try fetch(request: request, inContext: context)
        } catch {
            
        }
        return fetchedWorkouts
    }

    //MARK: ManageWorkoutDelegate
    func addWorkout(workoutName: String) {
        self.stack.mainContext.performBlockAndWait {
            let newWorkout = Workout(context: self.stack.mainContext, name: workoutName)
            saveContext(self.stack.mainContext)
            self.workouts.append(newWorkout)
        }
        self.workoutTableView!.reloadData()
    }
    
    func deleteWorkout(workout: Workout) {
        self.stack.mainContext.performBlockAndWait {
            deleteObjects([workout], inContext: self.stack.mainContext)
            saveContext(self.stack.mainContext)
        }
        workouts.removeAtIndex(workouts.indexOf(workout)!)
        self.workoutTableView!.reloadData()
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
        let cell = self.workoutTableView!.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTableViewCell
        let workout = self.workouts[indexPath.row]
        
        cell.selectionStyle = .None
        cell.textLabel!.text = workout.name
        cell.textLabel!.textColor = tintColor
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIStackView()
        headerView.axis = .Horizontal
        headerView.alignment = .Center
        headerView.distribution = .Fill
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerTitle = UILabel()
        headerTitle.text = "My Workouts"
        let leftSeparatorLine = UIView()
        leftSeparatorLine.heightAnchor.constraintEqualToConstant(3.0)
        leftSeparatorLine.backgroundColor = UIColor.blackColor()
        let rightSeparatorLine = UIView()
        rightSeparatorLine.backgroundColor = UIColor.blackColor()
        rightSeparatorLine.heightAnchor.constraintEqualToConstant(3.0)
        
        headerView.addArrangedSubview(leftSeparatorLine)
        headerView.addArrangedSubview(headerTitle)
        headerView.addArrangedSubview(rightSeparatorLine)
//        headerView.addConstraint(NSLayoutConstraint(item: leftSeparatorLine, attribute: .Leading, relatedBy: .Equal, toItem: headerView, attribute: .Leading, multiplier: 1.0, constant: 0.0))
//        leftSeparatorLine.addConstraint(NSLayoutConstraint(item: headerTitle, attribute: .Leading, relatedBy: .Equal, toItem: leftSeparatorLine, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
//        rightSeparatorLine.addConstraint(NSLayoutConstraint(item: rightSeparatorLine, attribute: .Leading, relatedBy: .Equal, toItem: headerTitle, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
//        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .Trailing, relatedBy: .Equal, toItem: rightSeparatorLine, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
//        var title: UILabel = UILabel()
//        
//        title.text = "My Workouts"
//        title.textAlignment = .Center
//        title.textColor = UIColor(red: 77.0/255.0, green: 98.0/255.0, blue: 130.0/255.0, alpha: 1.0)
//        title.backgroundColor = UIColor(red: 225.0/255.0, green: 243.0/255.0, blue: 251.0/255.0, alpha: 1.0)
//        title.font = UIFont.boldSystemFontOfSize(10)
//        
//        var constraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[label]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["label": title])
//        
//        title.addConstraints(constraint)
        return headerView
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedWorkout = self.workouts[indexPath.row]
        let workoutViewController = WorkoutViewController(workout: selectedWorkout, stack: self.stack)
        workoutViewController.manageWorkoutDelegate = self
        self.navigationController?.pushViewController(workoutViewController, animated: true)
        
    }

}
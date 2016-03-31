//
//  WorkoutSettingsViewController.swift
//  DoIt
//
//  Created by Leo Reyes on 3/21/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit

import JSQCoreDataKit

class WorkoutSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tintColor = UIColor(red: CGFloat(74.0 / 255.0), green: CGFloat(144.0 / 255.0), blue: CGFloat(226.0 / 255.0), alpha: 1.0)
    
    var stack: CoreDataStack!
    
    var workout: Workout?
    var tasks = [Task]()
    
    var manageWorkoutDelegate: ManageWorkoutDelegate?
    var manageTaskDelegate: ManageTaskDelegate?
    
    var taskTableView: UITableView?
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(workout: Workout) {
        self.init(nibName: nil, bundle: nil)
        self.workout = workout
        self.tasks = (self.workout?.tasks.sort() { (task1, task2) -> Bool in
            return task1.sequence < task2.sequence
        })!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.setDefaultBackground()
        setupNavbar()
        
        self.taskTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 375, height: 548))
        self.taskTableView!.delegate = self
        self.taskTableView!.dataSource = self
        self.taskTableView!.registerClass(WorkoutTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(WorkoutTableViewCell))
        self.taskTableView?.separatorStyle = .None
        self.taskTableView?.backgroundColor = UIColor.clearColor()
        self.taskTableView!.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:"))
        self.view.addSubview(self.taskTableView!)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.taskTableView!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 10.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.taskTableView!, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Trailing, relatedBy: .Equal, toItem: self.taskTableView, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: self.taskTableView, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
    }
    
    func setupNavbar() {
        self.navigationItem.title = self.workout!.name
        let deleteWorkoutButton = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("deleteWorkoutButtonSelected"))
        self.navigationItem.rightBarButtonItem = deleteWorkoutButton
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
    
    func deleteWorkoutButtonSelected() {
        self.manageWorkoutDelegate?.deleteWorkout(self.workout!)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (workout?.tasks.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = NSStringFromClass(WorkoutTableViewCell)
        let cell = self.taskTableView!.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTableViewCell
        let task = self.tasks[indexPath.row]
        
        cell.selectionStyle = .None
        cell.textLabel!.text = task.name
        cell.textLabel!.textColor = tintColor
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedTask = self.workout.tasks
//        let workoutViewController = WorkoutViewController(workout: selectedWorkout, stack: self.stack)
//        workoutViewController.manageWorkoutDelegate = self
//        self.navigationController?.pushViewController(workoutViewController, animated: true)
        
    }
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        
        let state = longPress.state
        
        let locationInView = longPress.locationInView(self.taskTableView)
        
        let indexPath = self.taskTableView!.indexPathForRowAtPoint(locationInView)
        
        struct My {
            
            static var cellSnapshot : UIView? = nil
            
        }
        
        struct Path {
            
            static var initialIndexPath : NSIndexPath? = nil
            
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            
            if indexPath != nil {
                
                Path.initialIndexPath = indexPath
                
                let cell = self.taskTableView!.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                
                My.cellSnapshot  = snapshopOfCell(cell)
                
                var center = cell.center
                
                My.cellSnapshot!.center = center
                
                My.cellSnapshot!.alpha = 0.0
                
                self.taskTableView!.addSubview(My.cellSnapshot!)
                
                
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    
                    center.y = locationInView.y
                    
                    My.cellSnapshot!.center = center
                    
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    
                    My.cellSnapshot!.alpha = 0.98
                    
                    cell.alpha = 0.0
                    
                    
                    
                    }, completion: { (finished) -> Void in
                        
                        if finished {
                            
                            cell.hidden = true
                            
                        }
                        
                })
                
            }
            
        case UIGestureRecognizerState.Changed:
            var center = My.cellSnapshot!.center
            
            center.y = locationInView.y
            
            My.cellSnapshot!.center = center
            
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                
                swap(&tasks[indexPath!.row], &tasks[Path.initialIndexPath!.row])
                
                self.manageTaskDelegate?.swapOrderOfTasks(tasks[indexPath!.row], taskB: tasks[Path.initialIndexPath!.row])
                
                self.taskTableView!.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                
                Path.initialIndexPath = indexPath
                
            }
            
            
        default:
            let cell = self.taskTableView!.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
            
            cell.hidden = false
            
            cell.alpha = 0.0
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                My.cellSnapshot!.center = cell.center
                
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                
                My.cellSnapshot!.alpha = 0.0
                
                cell.alpha = 1.0
                
                }, completion: { (finished) -> Void in
                    
                    if finished {
                        
                        Path.initialIndexPath = nil
                        
                        My.cellSnapshot!.removeFromSuperview()
                        
                        My.cellSnapshot = nil
                        
                    }
            })
        }
    }
        
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
            
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        
        UIGraphicsEndImageContext()
            
        let cellSnapshot : UIView = UIImageView(image: image)
            
        cellSnapshot.layer.masksToBounds = false
            
        cellSnapshot.layer.cornerRadius = 0.0
            
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
            
        cellSnapshot.layer.shadowRadius = 5.0
            
        cellSnapshot.layer.shadowOpacity = 0.4
            
        return cellSnapshot
            
    }
        
}
//
//  WorkoutViewController.swift
//  DoIt
//
//  Created by Leo Reyes on 3/3/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit
import CoreData

import JSQCoreDataKit

let MAX_BUFFER_SIZE: Int = 2

protocol ManageTaskDelegate {
    func addTask(taskName: String, reps: Int16, sets: Int16, weight: Int16, duration: Int32, distance: Double)
    func swapOrderOfTasks(taskA: Task, taskB: Task)
}

class WorkoutViewController: UIViewController, ManageTaskDelegate, DraggableViewDelegate {
    
    var servicesContainer: ServicesContainer!
    var taskServices: TaskServices!
    
    var workout: Workout!
    
    var stackView: UIStackView
    var cardViewContainer: UIView
    
    var tasks = [Task]()
    
    var loadedCards = [DraggableView]()
    var allTaskCards = [DraggableView]()
    var cardsLoaded = 0
    
    var manageWorkoutDelegate: ManageWorkoutDelegate?
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.stackView = UIStackView()
        self.stackView.axis = .Vertical
        self.stackView.alignment = .Fill
        self.stackView.distribution = .Fill
        self.stackView.spacing = 10
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.cardViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 548))
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(workout: Workout, servicesContainer: ServicesContainer) {
        self.init(nibName: nil, bundle: nil)
        self.workout = workout
        self.servicesContainer = servicesContainer
        self.taskServices = self.servicesContainer.getTaskServices()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tasks = self.taskServices.getAllTasksForWorkout(self.workout).sort( { (task1, task2) -> Bool in
            return task1.sequence < task2.sequence
        })
        
        let addTaskButton = AddButton(target: self, action: #selector(WorkoutViewController.addTaskButtonSelected))
        self.stackView.addArrangedSubview(self.cardViewContainer)
        self.stackView.addArrangedSubview(addTaskButton)
        self.view.addSubview(self.stackView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.stackView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.stackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Trailing, relatedBy: .Equal, toItem: self.stackView, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: self.stackView, attribute: .Bottom, multiplier: 1.0, constant: 15.0))
        
        loadCards()
        setupNavbar()
        self.view.setDefaultBackground()
    }
    
    func setupNavbar() {
        self.navigationItem.title = self.workout!.name
        let deleteWorkoutButton = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WorkoutViewController.settingsButtonSelected))
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
    
    //MARK: Button actions
    
    func addTaskButtonSelected() {
        let addTaskViewController = AddTaskViewController(manageTaskDelegate: self)
        addTaskViewController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(addTaskViewController, animated: true, completion: nil)
    }
    
    func settingsButtonSelected() {
        let workoutSettingsViewController = WorkoutSettingsViewController(workout: self.workout!)
        workoutSettingsViewController.manageWorkoutDelegate = self.manageWorkoutDelegate
        self.navigationController?.pushViewController(workoutSettingsViewController, animated: true)
    }
    
    //MARK: ManageTaskDelegate
    
    func addTask(taskName: String, reps: Int16, sets: Int16, weight: Int16, duration: Int32, distance: Double) {
        let newTask = self.taskServices.addTask(taskName, reps: reps, sets: sets, weight: weight, duration: duration, distance: distance, workout: self.workout!)
        self.tasks.append(newTask)
        let newTaskCard = self.createDraggableTaskCardAt(self.tasks.count - 1)
        self.allTaskCards.append(newTaskCard)
        self.loadNewCard()
    }
    
    func swapOrderOfTasks(taskA: Task, taskB: Task) {
        self.taskServices.swapOrderOfTasks(taskA, taskB: taskB)
    }
    
    
    //Helpers
    func loadCards() {
        if(tasks.count > 0) {
            let loadedCardsCap =  (tasks.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : tasks.count
            
            for (index, _) in tasks.enumerate() {
                let newDraggableTaskCard = createDraggableTaskCardAt(index)
                allTaskCards.append(newDraggableTaskCard)
                
                if(index < loadedCardsCap) {
                    loadedCards.append(newDraggableTaskCard)
                }
            }
            
            for (index, loadedCard) in loadedCards.enumerate() {
                if(index > 0) {
                    self.cardViewContainer.insertSubview(loadedCard, belowSubview: loadedCards[index - 1])
                } else {
                    self.cardViewContainer.addSubview(loadedCard)
                }
                cardsLoaded++
            }
            
        }
    }
    
    func loadNewCard() {
        let loadedCardsCap =  (tasks.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : tasks.count
        let newDraggableTaskCard = createDraggableTaskCardAt(cardsLoaded)
        if(loadedCards.count < loadedCardsCap) {
            loadedCards.append(newDraggableTaskCard)
            if(self.cardsLoaded > 0) {
                self.cardViewContainer.insertSubview(loadedCards.last!, belowSubview: loadedCards[loadedCardsCap - 2])
            } else {
                self.cardViewContainer.addSubview(loadedCards.last!)
            }
            cardsLoaded++
        }
    }
    
    func createDraggableTaskCardAt(index: Int) -> DraggableView {
        let taskCardView = TaskCardView(task: tasks[index])
        let draggableTaskCard = DraggableView(contentView: taskCardView)
        draggableTaskCard.delegate = self
        draggableTaskCard.dataIndex = index
        return draggableTaskCard
    }
    
    func reloadView() {

    }
    
    //MARK: CardSwipeDelegate
    
    func swipedRight(card: UIView) {
        let swipedTask = tasks[(card as! DraggableView).dataIndex]
        swipedTask.isComplete = true
        loadedCards.removeFirst()
        if(cardsLoaded < allTaskCards.count) {
            loadedCards.append(allTaskCards[cardsLoaded])
            cardsLoaded++
            self.cardViewContainer.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
    }

    func swipedLeft(card: UIView) {
        let swipedTask = tasks[(card as! DraggableView).dataIndex]
        swipedTask.skip = true
        loadedCards.removeFirst()
        if(cardsLoaded < allTaskCards.count) {
            loadedCards.append(allTaskCards[cardsLoaded])
            cardsLoaded++
            self.cardViewContainer.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
}

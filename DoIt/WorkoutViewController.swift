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

protocol AddTaskDelegate {
    func addTask(taskName: String, reps: Int16, sets: Int16, weight: Int16, duration: Int32, distance: Double)
}

class WorkoutViewController: UIViewController, AddTaskDelegate, DraggableViewDelegate {
    
    var stack: CoreDataStack!
    
    var workout: Workout?
    
    var stackView: UIStackView
    var cardViewContainer: UIView
    
    var tasks = [Task]()
    var taskCardViews = [DraggableView]()
    
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
        self.stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.cardViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 548))
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(workout: Workout, stack: CoreDataStack) {
        self.init(nibName: nil, bundle: nil)
        self.workout = workout
        self.stack = stack
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tasks = fetchTasks(self.stack.mainContext).sort( { (task1, task2) -> Bool in
            return task1.sequence < task2.sequence
        })
        
        let addTaskButton = createAddTaskButton()
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
    
    func fetchTasks(context: NSManagedObjectContext) -> [Task]{
        let e = entity(name: Task.entityName, context: context)
        let request = FetchRequest<Task>(entity: e)
        request.predicate = NSPredicate(format: "workout == %@", self.workout!)
        var fetchedTasks = [Task]()
        do {
            fetchedTasks = try fetch(request: request, inContext: context)
        } catch {
            
        }
        return fetchedTasks
    }
    
    func setupNavbar() {
        self.navigationItem.title = self.workout!.name
        let deleteWorkoutButton = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("settingsButtonSelected"))
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
    
    func createAddTaskButton() -> UIButton {
        let addTaskButton = UIButton(type: .Custom)
        addTaskButton.setImage(UIImage(named: "add_icon"), forState: .Normal)
        addTaskButton.addTarget(self, action: Selector("addTaskButtonSelected"), forControlEvents: .TouchDown)
        return addTaskButton
    }
    
    //MARK: Button actions
    
    func addTaskButtonSelected() {
        let addTaskViewController = AddTaskViewController(addTaskDelegate: self)
        addTaskViewController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(addTaskViewController, animated: true, completion: nil)
    }
    
    func settingsButtonSelected() {
        let workoutSettingsViewController = WorkoutSettingsViewController(workout: self.workout!, stack: self.stack)
        workoutSettingsViewController.manageWorkoutDelegate = self.manageWorkoutDelegate
        self.navigationController?.pushViewController(workoutSettingsViewController, animated: true)
    }
    
    func fetchWorkout(context: NSManagedObjectContext) -> FetchRequest<Workout> {
        let e = entity(name: Workout.entityName, context: context)
        let fetch = FetchRequest<Workout>(entity: e)
        fetch.predicate = NSPredicate(format: "name == %@", self.workout!.name)
        return fetch
    }
    
    
    //MARK: AddTaskDelegate
    
    func addTask(taskName: String, reps: Int16, sets: Int16, weight: Int16, duration: Int32, distance: Double) {
        stack.mainContext.performBlockAndWait {
            let newTask = Task(context: self.stack.mainContext, name: taskName, reps: reps, sets: sets, weight: weight, duration: duration, distance: distance, workout: self.workout!)
            saveContext(self.stack.mainContext)
            self.tasks.append(newTask)
            let newTaskCard = self.createDraggableTaskCardAt(self.tasks.count - 1)
            self.allTaskCards.append(newTaskCard)
            self.loadNewCard()
        }
    }
    
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

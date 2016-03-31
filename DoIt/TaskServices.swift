//
//  TaskServices.swift
//  DoIt
//
//  Created by Leo Reyes on 3/30/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import CoreData
import JSQCoreDataKit

class TaskServices {
    
    var context: NSManagedObjectContext
    var taskEntity: NSEntityDescription
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.taskEntity = entity(name: Task.entityName, context: context)
    }

    func getAllTasksForWorkout(workout: Workout) -> [Task] {
        let request = FetchRequest<Task>(entity: taskEntity)
        request.predicate = NSPredicate(format: "workout == %@", workout)
        var fetchedTasks = [Task]()
        do {
            fetchedTasks = try fetch(request: request, inContext: self.context)
        } catch {
            
        }
        return fetchedTasks
    }
    
    func swapOrderOfTasks(taskA: Task, taskB: Task) {
        let tempSequence = taskA.sequence
        taskA.sequence = taskB.sequence
        taskB.sequence = tempSequence
        saveContext(self.context){ result in
            switch result {
            case .Success:
                print("save succeeded")
                
            case .Failure(let error):
                print("save failed: \(error)")
            }
        }
    }
    
    func addTask(taskName: String, reps: Int16, sets: Int16, weight: Int16, duration: Int32, distance: Double, workout: Workout) -> Task {
        let newTask = Task(context: self.context, name: taskName, reps: reps, sets: sets, weight: weight, duration: duration, distance: distance, workout: workout)
        self.context.performBlockAndWait {
            saveContext(self.context)            
        }
        return newTask
    }
}
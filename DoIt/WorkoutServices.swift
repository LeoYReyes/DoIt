//
//  WorkoutServices.swift
//  DoIt
//
//  Created by Leo Reyes on 3/29/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import JSQCoreDataKit
import CoreData

class WorkoutServices {
    
    var context: NSManagedObjectContext
    var workoutEntity: NSEntityDescription
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.workoutEntity = entity(name: Workout.entityName, context: context)
    }
    
    func getAllWorkouts() -> [Workout] {
        var workouts = [Workout]()
        let request = FetchRequest<Workout>(entity: workoutEntity)
        do {
            workouts = try fetch(request: request, inContext: self.context)
        } catch {
            
        }
        return workouts
    }
    
    func addWorkout(workoutName: String) -> Workout {
        let newWorkout = Workout(context: self.context, name: workoutName)
        self.context.performBlockAndWait {
            saveContext(self.context)
        }
        return newWorkout
    }
    
    func deleteWorkout(workoutToDelete: Workout) {
        self.context.performBlockAndWait {
            deleteObjects([workoutToDelete], inContext: self.context)
            saveContext(self.context)
        }
    }

}
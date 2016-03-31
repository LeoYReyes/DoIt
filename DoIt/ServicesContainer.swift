//
//  ServicesContainer.swift
//  DoIt
//
//  Created by Leo Reyes on 3/30/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import Foundation
import JSQCoreDataKit

class ServicesContainer {
    
    private var coreDataStack: CoreDataStack!
    
    private var workoutServices: WorkoutServices?
    private var taskServices: TaskServices?
    
    init() {
        let model = CoreDataModel(name: DoItConstants.ModelName, bundle: NSBundle(identifier: DoItConstants.ModelBundle)!)
        let factory = CoreDataStackFactory(model: model)
        let result = factory.createStack()
        switch result {
        case .Success(let s):
            self.coreDataStack = s
        case .Failure(let err):
            assertionFailure("Failure creating stack: \(err)")
        }
//        factory.createStackInBackground { (result: CoreDataStackResult) -> Void in
//            switch result {
//            case .Success(let s):
//                self.coreDataStack = s
//                self.workoutServices = WorkoutServices(context: self.coreDataStack.mainContext)
//            case .Failure(let err):
//                assertionFailure("Failure creating stack: \(err)")
//            }
//        }
    }
    
    func getWorkoutServices() -> WorkoutServices {
        if(self.workoutServices == nil) {
            self.workoutServices = WorkoutServices(context: self.coreDataStack.mainContext)
        }
        return self.workoutServices!
    }
    
    func getTaskServices() -> TaskServices {
        if(self.taskServices == nil) {
            self.taskServices = TaskServices(context: self.coreDataStack.mainContext)
        }
        return self.taskServices!
    }
}
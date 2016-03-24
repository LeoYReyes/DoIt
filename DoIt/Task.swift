//
//  Task.swift
//  DoIt
//
//  Created by Leo Reyes on 3/1/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import CoreData

public final class Task: NSManagedObject {
    
    static public let entityName = "Task"
    
    var isComplete: Bool = false
    var skip: Bool = false
    
    @NSManaged public var sequence: Int16
    @NSManaged public var name: String
    @NSManaged public var reps: Int16
    @NSManaged public var sets: Int16
    @NSManaged public var weight: Int16
    @NSManaged public var duration: Int32
    @NSManaged public var distance: Double
    @NSManaged public var workout: Workout?
    
    public init(context: NSManagedObjectContext,
        name: String,
        reps: Int16,
        sets: Int16,
        weight: Int16,
        duration: Int32,
        distance: Double,
        workout: Workout? = nil) {
            let entity = NSEntityDescription.entityForName(Task.entityName, inManagedObjectContext: context)!
            super.init(entity: entity, insertIntoManagedObjectContext: context)
        
            self.sequence = (workout?.tasks.count)! + 1
            self.name = name
            self.reps = Int16(reps)
            self.sets = sets
            self.weight = weight
            self.duration = duration
            self.distance = distance
            self.workout = workout
    }
    
    @objc
    private override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

}
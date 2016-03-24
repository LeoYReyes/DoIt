//
//  Workout.swift
//  DoIt
//
//  Created by Leo Reyes on 3/1/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import Foundation
import CoreData

public final class Workout: NSManagedObject {
    
    static public let entityName = "Workout"
        
    @NSManaged public var name: String
    @NSManaged public var tasks: Set<Task>
    
    public init(context: NSManagedObjectContext, name: String) {
        let entity = NSEntityDescription.entityForName(Workout.entityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
    }
    
    public class func newWorkout(context: NSManagedObjectContext) -> Workout {
        let name = "New Workout"
        
        return Workout(context: context, name: name)
    }
    
    @objc
    private override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

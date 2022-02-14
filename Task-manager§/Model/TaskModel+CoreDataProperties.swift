//
//  TaskModel+CoreDataProperties.swift
//  Task-manager
//
//  Created by Денис Сизов on 14.02.2022.
//
//

import Foundation
import CoreData


extension TaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
        return NSFetchRequest<TaskModel>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isRoot: Bool
    @NSManaged public var subtasks: NSSet?

}

// MARK: Generated accessors for subtasks
extension TaskModel {

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: TaskModel)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: TaskModel)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSSet)

}

extension TaskModel : Identifiable {

}

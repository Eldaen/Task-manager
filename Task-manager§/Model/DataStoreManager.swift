//
//  DataStoreManager.swift
//  CoreData
//
//  Created by Денис Сизов on 04.02.2022.
//

import Foundation
import CoreData

/// Протокол менеджера Кор Даты
protocol DataManager: AnyObject {
	
	/// Добавить новую задачу
	func addNewTask(name: String, description: String, isRoot: Bool) -> TaskModel
	
	/// Добавляет задаче подзадачу
	func addSubtask(task subtask: TaskModel, to parentTask: TaskModel)
	
	/// Получает корневые задачи
	func getRootTasks() -> [TaskModel]?
	
	/// Получает задачи
	func getTasks(id: String) -> [TaskModel]?
}

final class DataStoreManager: DataManager {
	
	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "CoreData")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	lazy var viewContext = persistentContainer.viewContext
	lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()

	// MARK: - CRUD

	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}

	/// Добавляет новую задачу
	func addNewTask(name: String, description: String, isRoot: Bool = false) -> TaskModel {
		
		let task = TaskModel(context: viewContext)
		task.name = name
		task.taskDescription = description
		task.isRoot = isRoot
		task.id = UUID()
		
		do {
			try viewContext.save()
		} catch let error {
			print(error)
		}
		
		return task
	}
	
	func addSubtask(task subtask: TaskModel, to parentTask: TaskModel) {
		parentTask.addToSubtasks(subtask)
		
		do {
			try viewContext.save()
		} catch let error {
			print(error)
		}
	}
	
	func getRootTasks() -> [TaskModel]? {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
		fetchRequest.predicate = NSPredicate(format: "isRoot = true")
		
		if let tasks = try? viewContext.fetch(fetchRequest) as? [TaskModel],
		   !tasks.isEmpty {
			
			return tasks
		} else {
			return nil
		}
	}
	
	func getTasks(id: String) -> [TaskModel]? {
		guard let uuid = UUID(uuidString: id) else {
			return nil
		}
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
		fetchRequest.predicate = NSPredicate(format: "id = %@", uuid as CVarArg)
		
		if let task = try? viewContext.fetch(fetchRequest) as? [TaskModel],
		   !task.isEmpty {
			
			if let subtasks = task.first?.subtasks?.allObjects as? [TaskModel] {
				return subtasks
			} else {
				return nil
			}
		} else {
			return nil
		}
	}
	
}

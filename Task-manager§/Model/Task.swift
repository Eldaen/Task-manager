//
//  Task.swift
//  Task-manager
//
//  Created by Денис Сизов on 14.02.2022.
//

import Foundation

/// Класс задачи
class Task {
	
	/// Имя задачи
	var name: String
	
	/// Описание задачи
	var description: String?
	
	/// Массив подзадач
	var subtasks: [Task]?
	
	init(name: String, description: String? = nil, subtasks: [Task]? = nil) {
		self.name = name
		self.description = description
		self.subtasks = subtasks
	}
}

//
//  ParentControllerProtocol.swift
//  Task-manager
//
//  Created by Денис Сизов on 14.02.2022.
//

import Foundation

/// Протокол родительского контроллера для контроллера отображения задач
protocol ParentController: AnyObject {
	
	/// Добавляет свежесозданную задачу в список подзадач текущей задачи
	func addSubtask(_ task: Task, at index: Int)
}

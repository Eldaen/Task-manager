//
//  TasksController.swift
//  Task-manager§
//
//  Created by Денис Сизов on 14.02.2022.
//

import UIKit

/// Основной контроллер для отображения задач
final class TasksController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	/// Список задач
	var tasks: [Task]?
	
	/// Кол-во секций
	var sectionsCount = 1

	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableView()
	}

	private func configureTableView() {
		tableView.delegate = self
		tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
	}

}

// MARK: - UITableViewDataSource

extension TasksController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let tasks = tasks else { return 0 }
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell"  ) as? TaskTableViewCell else {
			return UITableViewCell()
		}
		
		configureCell(cell: cell, indexPath: indexPath)
		return cell
	}
	
	/// Конфигурирует ячейку
	private func configureCell(cell: TaskTableViewCell, indexPath: IndexPath) {
		guard let tasks = tasks else { return }
		
		cell.taskNameLabel.text = tasks[indexPath.row].name
		cell.subtasksLabel.text = "Подзадач: \(tasks[indexPath.row].subtasks?.count ?? 0)"
	}
}

// MARK: - UITableViewDelegate

extension TasksController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = TasksController()
		
		if let tasks = tasks {
			vc.tasks = tasks[indexPath.row].subtasks
		}
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
}


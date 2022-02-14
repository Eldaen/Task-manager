//
//  TasksController.swift
//  Task-manager§
//
//  Created by Денис Сизов on 14.02.2022.
//

import UIKit

protocol AddTaskDelegate: AnyObject {
	func addTask(name: String, description: String)
}

/// Основной контроллер для отображения задач
final class TasksController: UIViewController {
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()
	
	/// Список задач
	var tasks: [Task]?
	
	/// Предыдущий контроллер в цепочке
	var prevController: TasksController?

	/// IndexPath отображаемой задачи в родительском контроллере
	var parentIndexPath: Int?
	
	/// Кол-во секций
	var sectionsCount = 1
	
	/// ID ячейки задачи
	let cellId = "TaskTableViewCell"

	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableView()
		setupConstraints()
	}

	private func configureTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		self.view.addSubview(tableView)
		
		tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
	}
	
	/// Задаём констрейнты таблице
	func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
		])
	}

}

// MARK: - UITableViewDataSource

extension TasksController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionsCount
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let tasks = tasks else { return 0 }
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? TaskTableViewCell else {
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
		guard let vc = storyboard?.instantiateViewController(withIdentifier: "TasksController") as? TasksController else {
			return
		}
		
		if let tasks = tasks {
			vc.tasks = tasks[indexPath.row].subtasks
			vc.prevController = self
			vc.parentIndexPath = indexPath.row
		}
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddTask" {
			if let vc = segue.destination as? AddTaskController {
				vc.delegate = self
			}
		}
	}
}

// MARK: - AddTaskDelegate

extension TasksController: AddTaskDelegate {
	
	/// Добавить задачу
	func addTask(name: String, description: String) {
		let newTask = Task(name: name, description: description)
		
		if tasks != nil {
			tasks?.append(newTask)
		} else {
			tasks = [newTask]
		}
		
		// Если контроллер не корневой, то нужно сообщить родителю, что появились подзадачи
		if let prevController = prevController,
		   let parentIndex = parentIndexPath,
			let tasks = prevController.tasks {
			
			if tasks[parentIndex].subtasks != nil {
				tasks[parentIndex].subtasks?.append(newTask)
			} else {
				tasks[parentIndex].subtasks = [newTask]
			}
			prevController.tableView.reloadData()
		}
		
		tableView.reloadData()
	}
}


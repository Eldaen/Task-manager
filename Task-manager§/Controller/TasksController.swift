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
	var tasks: [TaskModel]?
	
	var parentId: String?
	
	/// Предыдущий контроллер в цепочке
	weak var prevController: ParentController?
	
	/// Ссылка на дата менеджер
	var dataManager: DataManager?

	/// IndexPath отображаемой задачи в родительском контроллере
	var parentIndexPath: Int?
	
	/// Кол-во секций
	var sectionsCount = 1
	
	/// ID ячейки задачи
	let cellId = "TaskTableViewCell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		checkDataManager()
		loadTasks()
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
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
		])
	}
	
	/// Создаём дата менеджер, если его ещё нет
	private func checkDataManager() {
		if self.dataManager == nil {
			self.dataManager = DataStoreManager()
		}
	}
	
	/// Загружает задачи
	private func loadTasks() {
		if prevController == nil {
			self.tasks = dataManager?.getRootTasks()
		} else {
			self.tasks = dataManager?.getTasks(id: parentId ?? "")
		}
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
			vc.parentId = tasks[indexPath.row].id?.uuidString
			vc.dataManager = dataManager
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
		guard let dataManager = dataManager else { return }
		var isRoot = false
		
		if prevController == nil {
			isRoot = true
		}
		let newTask = dataManager.addNewTask(name: name, description: description, isRoot: isRoot)
		
		if tasks != nil {
			tasks?.append(newTask)
		} else {
			tasks = [newTask]
		}
		
		if let prevController = prevController,
		   let parentIndexPath = parentIndexPath {
			prevController.addSubtask(newTask , at: parentIndexPath)
		}
		
		tableView.reloadData()
	}
}

// MARK: - ParentController

extension TasksController: ParentController {
	
	func addSubtask(_ task: TaskModel, at index: Int) {
		guard tasks != nil else { return }
		
		if let tasks = tasks {
			if tasks[index].subtasks != nil {
				tasks[index].subtasks?.adding(task)
				dataManager?.addSubtask(task: task, to: tasks[index])
			} else {
				tasks[index].subtasks = [task]
			}
		}
		
		tableView.reloadData()
	}
}


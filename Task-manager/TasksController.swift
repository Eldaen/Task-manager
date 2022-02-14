//
//  TasksController.swift
//  Task-manager§
//
//  Created by Денис Сизов on 14.02.2022.
//

import UIKit

/// Основной контроллер для отображения задач
final class TasksController: UIViewController {
	
	/// Список задач
	var tasks: [Task]?
	
	/// Кол-во секций
	var sectionsCount = 1

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


}

// MARK: - UITableViewDataSource

extension TasksController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let tasks = tasks else { return 0 }
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
	}
}

// MARK: - UITableViewDelegate

extension TasksController: UITableViewDelegate {
	
}


//
//  AddTaskController.swift
//  Task-manager
//
//  Created by Денис Сизов on 14.02.2022.
//

import UIKit

/// Контроллер для добавления задачи
final class AddTaskController: UIViewController {
	@IBOutlet weak var taskNameLabel: UITextField!
	@IBOutlet weak var taskDescriptionLabel: UITextField!
	
	/// Делегат добавления задачи
	weak var delegate: AddTaskDelegate?
	
	@IBAction func addTaskAction(_ sender: Any) {
		guard let name = taskNameLabel.text,
			  let description = taskDescriptionLabel.text else {
				  return
			  }
		delegate?.addTask(name: name, description: description)
		dismiss(animated: true, completion: nil)
	}
	
}

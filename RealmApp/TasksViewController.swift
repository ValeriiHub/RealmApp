//
//  TasksViewController.swift
//  RealmApp
//
//  Created by Valerii D on 08.08.2021.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {

    var currentTaskList: TasksList!
    
    var currentTasks: Results<Task>!
    var completedTasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        title = currentTaskList.name
        
        filteringTasks()
    }

    @IBAction func editButtonPressed(_ sender: Any) {
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? currentTasks.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "CURRENT TASK" :  "COMPLETED TASK"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)

        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]

        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        
        return cell
    }
    
    private func  filteringTasks() {
        currentTasks = currentTaskList.tasks.filter("isCompleted = false")
        completedTasks = currentTaskList.tasks.filter("isCompleted = true") 
        
        tableView.reloadData()
    }
}

extension TasksViewController {
    
    private func alertForAddAndUpdateList() {
        
        let alert = UIAlertController(title: "New List",
                                      message: "Please insert new value",
                                      preferredStyle: .alert)
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
            guard let newTask = taskTextField.text, !newTask.isEmpty else { return }
            
            let task = Task()
            task.name = newTask
            
            if let newNote = noteTextField.text, !newNote.isEmpty {
                task.note = newNote
            }
            
            StorageManager.saveTask(self.currentTaskList, task: task)
            self.filteringTasks()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = "LNew Task"
        }
        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = "Note"
        }
        
        present(alert, animated: true)
    }
}

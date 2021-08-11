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
    
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    
    private var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        title = currentTaskList.name
        
        filteringTasks()
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
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
    
    //MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.alertForAddAndUpdateList(task)
            self.filteringTasks()
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, _ in
            StorageManager.makeDone(task)
            self.filteringTasks()
        }
        
        doneAction.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        editAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [deleteAction,doneAction, editAction])
    }
    
    private func   filteringTasks() {
        currentTasks = currentTaskList.tasks.filter("isCompleted = false")
        completedTasks = currentTaskList.tasks.filter("isCompleted = true") 
        
        tableView.reloadData()
    }
}

extension TasksViewController {
    
    private func alertForAddAndUpdateList(_ taskName: Task? = nil) {
        
        var title = "New Task"
        var doneButton = "Save"
        
        if taskName != nil {
            title = "Edit Task"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title,
                                      message: "Please insert new value",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: doneButton,
                                       style: .default) { _ in
            guard let newTask = alert.textFields?.first?.text, !newTask.isEmpty else { return }
            
            if let taskName = taskName {
                if let newNote = alert.textFields?[1].text, !newNote.isEmpty {
                    StorageManager.editTask(taskName, newTask: newTask, newNote: newNote)
                } else {
                    StorageManager.editTask(taskName, newTask: newTask, newNote: "")
                }
                self.filteringTasks()
            } else {
                let task = Task()
                task.name = newTask
                
                if let newNote = alert.textFields?[1].text, !newNote.isEmpty {
                    task.note = newNote
                }
                
                StorageManager.saveTask(self.currentTaskList, task: task)
                self.filteringTasks()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            textField.placeholder = "New Task"
            
            if let taskName = taskName {
                alert.textFields?.first?.text = taskName.name
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Note"
            
            if let taskName = taskName {
                alert.textFields?[1].text = taskName.note
            }
        }
        
        present(alert, animated: true)
    }
}

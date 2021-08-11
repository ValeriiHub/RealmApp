//
//  TasksListViewController.swift
//  RealmApp
//
//  Created by Valerii D on 08.08.2021.
//

import UIKit
import RealmSwift

class TasksListViewController: UITableViewController {

    var tasksLists: Results<TasksList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksLists = realm.objects(TasksList.self)   // достаём данные из базы
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        /*
        // создаем shoppinList
        let shoppinList = TasksList()
        shoppinList.name = "Shoppin List"
        
        let milk = Task()
        milk.name = "Milk"
        milk.note = "2L"                                                // инициализация и настройка свойств по отдельности
        
        let bread = Task(value: ["Bread", "", Date(), true])            // инициализация с помощью массива
        
        let apples = Task(value: ["name" : "Apples", "note" : "2Kg"])   // инициализация с помощью словаря
        
        shoppinList.tasks.append(milk)
        shoppinList.tasks.insert(contentsOf: [bread, apples], at: 1)   // добавляем tasks массивом с помощью функции insert(contentsOf:at:)
        
        // создаем moviesList
        let moviesList = TasksList(value: ["Movies List", Date(), [["John Wick"], ["Tor", "", Date(), true]]])    // создаем все свойства TasksList в одну строку
    
        DispatchQueue.main.async {
            StorageManager.saveTasksList([shoppinList, moviesList])
        }
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {
            tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)

        let tasksList = tasksLists[indexPath.row]
        
        cell.configure(with: tasksList)

        return cell
    }
    
    // MARK: - TableView Delegate
    
    /*  'UITableViewRowAction' was deprecated in iOS 13.0
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let currentList = tasksLists[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            StorageManager.deleteList(currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { _, _ in
            self.alertForAddAndUpdateList(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        return [deleteAction, editAction]
    }  */
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentList = tasksLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteList(currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.alertForAddAndUpdateList(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, _ in
            StorageManager.makeAllDone(currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        doneAction.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        editAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [deleteAction, doneAction, editAction])
    }
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let tasksList = tasksLists[indexPath.row]
            let tasksVC = segue.destination as! TasksViewController
            tasksVC.currentTaskList = tasksList
        }
    }
}

extension TasksListViewController {
    
    private func alertForAddAndUpdateList(_ listName: TasksList? = nil, complition: (() -> Void)? = nil) {
        
        var title = "New List"
        var doneButton = "Save"
        
        if listName != nil {
            title = "Edit List"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title,
                                      message: "Please insert new value",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newList = alert.textFields?.first?.text, !newList.isEmpty else { return }
            
            // editlist
            if let listName = listName {
                StorageManager.editlist(listName, newListName: newList)
                if complition != nil {
                    complition!()
                }
            } else {
                // saveTasksList
                let taskList = TasksList()
                taskList.name = newList
                
                StorageManager.saveTasksList(taskList) 
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            textField.placeholder = "List Name"
        }
        
        if let listName = listName {
            alert.textFields?.first?.text = listName.name
        }
        
        present(alert, animated: true)
    }
}

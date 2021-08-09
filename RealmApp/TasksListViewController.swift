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

    @IBAction func editButtonPressed(_ sender: Any) {
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)

        let tasksList = tasksLists[indexPath.row]
        
        cell.textLabel?.text = tasksList.name
        cell.detailTextLabel?.text = "\(tasksList.tasks.count)"

        return cell
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
    
    private func alertForAddAndUpdateList() {
        
        let alert = UIAlertController(title: "New List",
                                      message: "Please insert new value",
                                      preferredStyle: .alert)
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else { return }
            
            let taskList = TasksList()
            taskList.name = newList
            
            StorageManager.saveTasksList(taskList)
            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }
        
        present(alert, animated: true)
    }
}

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
        
        tasksLists = realm.objects(TasksList.self)
        
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
            guard let text = alertTextField.text, !text.isEmpty else { return }
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

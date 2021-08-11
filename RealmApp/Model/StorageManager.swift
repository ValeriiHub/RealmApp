//
//  StorageManager.swift
//  RealmApp
//
//  Created by Valerii D on 08.08.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    //MARK: - Tasks Lists Methods
    
    static func saveTasksList(_ tasksList: TasksList) {
        
        try! realm.write {
            realm.add(tasksList)
        }
    }

    static func deleteList(_ taskList: TasksList) {
        try! realm.write {
            let tasks = taskList.tasks
            realm.delete(tasks)
            realm.delete(taskList)           // сначала удаляем все tasks внутри taskList, а только потом удаляем сaм taskList
        }
    }
    
    static func editlist( _ taskList: TasksList, newListName: String) {
        try! realm.write {
            taskList.name = newListName
        }
    }
    
    static func makeAllDone(_ taskList: TasksList) {
        try! realm.write {
            taskList.tasks.setValue(true, forKey: "isCompleted")
        }
    }
    
    
    //MARK: - Tasks Methods
    
    static func saveTask( _ taskList: TasksList, task: Task) {
        try! realm.write {
            taskList.tasks.append(task)
        }
    }
    
    static func editTask( _ task: Task, newTask: String, newNote: String) {
        try! realm.write {
            task.name = newTask
            task.note = newNote
        }
    }
    
    static func deleteTask(_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    static func makeDone(_ task: Task) {
        try! realm.write {
            task.isCompleted.toggle()
        }
    }
}

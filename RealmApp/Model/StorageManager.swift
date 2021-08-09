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

    
    
    
    //MARK: - Tasks Methods
    
    static func saveTask( _ taskList: TasksList, task: Task) {
        try! realm.write {
            taskList.tasks.append(task)
        }
    }
}

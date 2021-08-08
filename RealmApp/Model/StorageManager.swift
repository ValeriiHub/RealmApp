//
//  StorageManager.swift
//  RealmApp
//
//  Created by Valerii D on 08.08.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveTasksList(_ tasksLists: [TasksList]) {
        
        try! realm.write {
            realm.add(tasksLists)
        }
    }
}

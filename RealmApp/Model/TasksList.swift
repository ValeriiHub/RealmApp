//
//  TasksList.swift
//  RealmApp
//
//  Created by Valerii D on 08.08.2021.
//

import RealmSwift

class TasksList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}

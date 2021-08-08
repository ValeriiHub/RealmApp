//
//  Task.swift
//  RealmApp
//
//  Created by Valerii D on 08.08.2021.
//

import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isCompleted = false
}

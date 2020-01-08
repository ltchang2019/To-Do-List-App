//
//  Project.swift
//  To Do List
//
//  Created by Luke Tchang on 12/21/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import Foundation

class Project: Codable{
    var name = ""
    var tasks = [Task]()
    var iconName = "Checklist"
    
    init(name: String, iconName: String){
        self.name = name
        self.iconName = iconName
    }
    
    func countUncheckedTasks() -> Int {
        var count = 0
        for task in tasks{
            if !task.isChecked{
                count += 1
            }
        }
        return count
    }
}

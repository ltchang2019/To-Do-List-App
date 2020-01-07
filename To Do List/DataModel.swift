//
//  DataModel.swift
//  To Do List
//
//  Created by Luke Tchang on 12/21/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import Foundation

class DataModel{
    class func generateID() -> Int{
        var userDefaults = UserDefaults.standard
        var nextTaskID = userDefaults.integer(forKey: "TaskID") + 1
        
        userDefaults.set(nextTaskID, forKey: "TaskID")
        userDefaults.synchronize()
        
        return nextTaskID
    }
}

//
//  Task.swift
//  To Do List
//
//  Created by Luke Tchang on 12/21/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import Foundation
import UserNotifications

class Task: NSObject, Codable{
    var text = ""
    var dueDate = Date()
    var shouldRemind = false
    var isChecked = false
    var taskID = UUID().uuidString
    
    init(text: String, dueDate: Date, shouldRemind: Bool){
        self.text = text
        self.dueDate = dueDate
        self.shouldRemind = shouldRemind
    }
    
    deinit{
        removeNotification()
    }
    
    func saveNotification(){
        removeNotification()
        if shouldRemind && dueDate > Date(){
            let content = UNMutableNotificationContent()
            content.title = "To Do List Notification"
            content.body = text
            content.sound = .default
            
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "\(taskID)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func removeNotification(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(taskID)"])
    }
}

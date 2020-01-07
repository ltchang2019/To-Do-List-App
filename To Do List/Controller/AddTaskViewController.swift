//
//  AddTaskViewController.swift
//  To Do List
//
//  Created by Luke Tchang on 12/31/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import UIKit
import UserNotifications

class AddTaskViewController: UITableViewController{
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var remindMeSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    
    var index: Int!
    var projectItems: [Project]!
    var taskIndex: Int?
    var remindMeDefault: Bool?
    var dateDefault: String?
    var dueDate = Date()
    var datePickerVisible = false
    
    let dataFilePathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Projects.plist")
    
    override func viewDidLoad() {
        if taskIndex != nil{
            taskNameTextField.text = projectItems[index].tasks[taskIndex!].text
        }
        remindMeSwitch.isOn = remindMeDefault ?? false
        dueDateLabel.text = dateDefault ?? "Default Date"
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        updateDueDateLabel()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if !taskNameTextField.text!.isEmpty{
            let newTask = Task(text: taskNameTextField.text!, dueDate: dueDate, shouldRemind: remindMeSwitch.isOn)
            
            if taskIndex != nil {
                projectItems[index].tasks[taskIndex!] = newTask
            } else {
                projectItems[index].tasks.append(newTask)
                taskIndex = projectItems[index].tasks.firstIndex(of: newTask)
            }
            
            if remindMeSwitch.isOn{
                projectItems[index].tasks[taskIndex!].saveNotification()
            }
        }
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.projectItems)
            try data.write(to: dataFilePathURL!)
        } catch {
            print("Error encoding new task: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shouldRemindToggled(_ remindSwitch: UISwitch){
        taskNameTextField.resignFirstResponder()
        if remindSwitch.isOn{
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            }
        }
    }
    
}


//DATE PICKER METHODS
extension AddTaskViewController{
    func updateDueDateLabel(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: self.dueDate)
    }
    
    @IBAction func dueDateChanged(_datePicker: UIDatePicker){
        self.dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    func showDatePicker(){
        self.datePickerVisible = true
        let dueDateLabelPath = IndexPath(row: 1, section: 1)
        let dueDateCell = tableView.cellForRow(at: dueDateLabelPath)
        dueDateCell?.detailTextLabel?.textColor = dueDateCell?.detailTextLabel?.tintColor
        
        let datePickerPath = IndexPath(row: 2, section: 1)
        
        //start calling table view delegate methods when table view is changed or reloaded (insert, delete, reload, etc...)
        tableView.beginUpdates()
        tableView.insertRows(at: [datePickerPath], with: .fade)
        tableView.reloadRows(at: [dueDateLabelPath], with: .none)
        tableView.endUpdates()
    }
    
    func hideDatePicker(){
        self.datePickerVisible = false
        let dueDateLabelPath = IndexPath(row: 1, section: 1)
        let dueDateCell = tableView.cellForRow(at: dueDateLabelPath)
        dueDateCell?.detailTextLabel?.textColor = .black
        
        let datePickerPath = IndexPath(row: 2, section: 1)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [datePickerPath], with: .fade)
        tableView.reloadRows(at: [dueDateLabelPath], with: .none)
        tableView.endUpdates()
    }
    
    
    //special case delegate methods for when date picker is opened
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible{
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2{
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2{
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1{
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        taskNameTextField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1{
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2{
            newIndexPath = IndexPath(row: 0, section: 1)
        }

        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
}


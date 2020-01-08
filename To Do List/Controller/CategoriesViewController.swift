//
//  CategoriesViewController.swift
//  To Do List
//
//  Created by Luke Tchang on 12/30/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import UIKit
import SwipeCellKit

class CategoriesViewController: UITableViewController{

    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    
    var index: Int!
    var projectItems: [Project]!
    let dataFilePathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Projects.plist")
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = addTaskButton
        self.title = projectItems[index].name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
        tableView.reloadData()
    }
    
    func loadItems(){
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: dataFilePathURL!){
            do{
                projectItems = try decoder.decode([Project].self, from: data)
            } catch {
                print("Error decoding project tasks: \(error)")
            }
        }
    }
    
    func writeItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.projectItems)
            try data.write(to: dataFilePathURL!)
        } catch{
            print("Error encoding data: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewTask"{
            let addTaskVC = segue.destination as! AddTaskViewController
            addTaskVC.index = self.index
            addTaskVC.projectItems = self.projectItems
        } else if segue.identifier == "editTask"{
            let editTaskVC = segue.destination as! AddTaskViewController
            editTaskVC.index = self.index
            editTaskVC.projectItems = self.projectItems
            editTaskVC.taskIndex = sender as! Int
        }
    }
}

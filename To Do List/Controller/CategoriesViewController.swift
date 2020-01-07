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
}

//CATEGORIESVC DELEGATE METHODS
extension CategoriesViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectItems[index].tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        cell.textLabel?.text = projectItems![index].tasks[indexPath.row].text
        
        if projectItems![index].tasks[indexPath.row].isChecked{
            cell.detailTextLabel?.text = "✅"
        } else {
            cell.detailTextLabel?.text = "❌"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        projectItems![index].tasks[indexPath.row].isChecked = !projectItems![index].tasks[indexPath.row].isChecked
        writeItems()
        tableView.reloadData()
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

//SWIPECELLKIT DELEGATE METHODS
extension CategoriesViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            do{
                self.performSegue(withIdentifier: "editTask", sender: indexPath.row)
            } catch {
                print("Error transitioning to editTask VC: \(error)")
            }
        }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            do{
                self.projectItems[self.index].tasks.remove(at: indexPath.row)
                self.writeItems()
            } catch {
                print("Error deleting task: \(error)")
            }
        }

        editAction.backgroundColor = UIColor.systemBlue
        deleteAction.backgroundColor = UIColor.systemRed
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}


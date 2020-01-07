//
//  ViewController.swift
//  To Do List
//
//  Created by Luke Tchang on 12/21/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import UIKit
import SwipeCellKit

class ProjectsViewController: UITableViewController {
    var projectItems = [Project]()
    let dataFilePathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Projects.plist")
    
    
    override func viewDidLoad() {
        loadItems()
        print(dataFilePathURL)
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePathURL!){
            let decoder  = PropertyListDecoder()
            do{
                projectItems = try decoder.decode([Project].self, from: data)
            } catch {
                print("Error decoding data: \(error)")
            }
            tableView.reloadData()
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
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addButtonPressed", sender: nil)
    }
}


//TABLEVIEW DELEGATE METHODS
extension ProjectsViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        cell.textLabel?.text = projectItems[indexPath.row].name
        cell.imageView?.image = UIImage(named: projectItems[indexPath.row].iconName)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addButtonPressed"{
            let addProjectVC = segue.destination as! AddProjectViewController
            addProjectVC.projectItems = projectItems
        } else if segue.identifier == "categorySelected"{
            let toCategoryVC = segue.destination as! CategoriesViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                toCategoryVC.index = indexPath.row
                toCategoryVC.projectItems = projectItems
//                toCategoryVC.navigationItem.backBarButtonItem?.title = "\(projectItems[indexPath.row].name)"
            }
        } else if segue.identifier == "editProject"{
            let editProjectVC = segue.destination as! AddProjectViewController
            editProjectVC.projectItems = projectItems
            editProjectVC.projectIndex = sender as! Int
            editProjectVC.editProjectDelegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "editProject", sender: indexPath.row)
    }
}

//SWIPECELLKIT DELEGATE METHODS
extension ProjectsViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            do{
                self.projectItems.remove(at: indexPath.row)
                self.writeItems()
            } catch {
                print("Error deleting task: \(error)")
            }
        }

        deleteAction.backgroundColor = UIColor.systemRed
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}

//PROTOCOL EXTENSION
extension ProjectsViewController: EditProjectDelegate{
    func reloadAfterDelete(projects: [Project]) {
        self.projectItems = projects
        writeItems()
        loadItems()
    }
}

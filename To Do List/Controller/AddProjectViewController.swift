//
//  AddProjectViewController.swift
//  To Do List
//
//  Created by Luke Tchang on 12/23/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import UIKit

protocol EditProjectDelegate {
    func reloadAfterDelete(projects: [Project])
}

class AddProjectViewController: UITableViewController{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    var editProjectDelegate: EditProjectDelegate?
    
    var projectItems: [Project]!
    var projectIndex: Int?
    var iconName: String?
    
    override func viewDidLoad() {
        if projectIndex != nil{
            nameTextField.text = projectItems[projectIndex!].name
            iconImageView.image = UIImage(named: projectItems[projectIndex!].iconName)
            iconName = projectItems[projectIndex!].iconName
        } else {
            iconName = "Checklist"
        }
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    let dataFilePathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Projects.plist")
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if !nameTextField.text!.isEmpty {
            if projectIndex != nil{
                projectItems[projectIndex!].name = nameTextField.text!
                projectItems[projectIndex!].iconName = self.iconName!
            } else {
                let newProject = Project(name: nameTextField.text!, iconName: self.iconName!)
                projectItems.append(newProject)
            }
        }
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.projectItems)
            try data.write(to: dataFilePathURL!)
        } catch{
            print("Error encoding data: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if projectIndex != nil{
            let alert = UIAlertController(title: "Are you sure?", message: "You can't undo this action.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) in
                self.projectItems.remove(at: self.projectIndex!)
                self.editProjectDelegate?.reloadAfterDelete(projects: self.projectItems)
                self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIconPicker"{
            let iconPickerVC = segue.destination as! IconPickerViewController
            iconPickerVC.delegate = self
        }
    }
}

//ICONPICKERDELGATE EXTENSION
extension AddProjectViewController: IconPickerDelegate{
    func iconPicked(iconName: String) {
        iconImageView.image = UIImage(named: iconName)
        self.iconName = iconName
    }
}

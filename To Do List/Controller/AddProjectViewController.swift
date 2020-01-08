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

protocol ProjectSavedDelegate {
    func reloadAfterSave()
}

class AddProjectViewController: UIViewController{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cancelDeleteButton: UIButton!
    @IBOutlet weak var saveBarButtonItem: UIButton!
    @IBOutlet weak var pickProjectView: UIView!
    
    var editProjectDelegate: EditProjectDelegate?
    var projectSavedDelegate: ProjectSavedDelegate?
    
    var projectItems: [Project]!
    var projectIndex: Int?
    var iconName: String?
    
    let dataFilePathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Projects.plist")
    
    override func viewDidLoad() {
        pickProjectView.layer.cornerRadius = 3.0
        saveBarButtonItem.layer.cornerRadius = 3.0
        
        if projectIndex != nil{
            nameTextField.text = projectItems[projectIndex!].name
            iconImageView.image = UIImage(named: projectItems[projectIndex!].iconName)
            iconName = projectItems[projectIndex!].iconName
        } else {
            iconName = "Checklist"
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toIconPicker(_:)))
        pickProjectView.addGestureRecognizer(tap)
    }
    
    @objc func toIconPicker(_ sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "toIconPicker", sender: nil)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
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
        
        self.dismiss(animated: true) {
            self.projectSavedDelegate?.reloadAfterSave()
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

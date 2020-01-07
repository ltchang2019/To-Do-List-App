//
//  IconPickerViewController.swift
//  To Do List
//
//  Created by Luke Tchang on 12/24/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import UIKit

protocol IconPickerDelegate {
    func iconPicked(iconName: String)
}

class IconPickerViewController: UITableViewController{
    
    var delegate: IconPickerDelegate?
    
    var iconArray: [String] = ["Baby", "Birthday", "Checklist", "Drink", "Email", "Family", "Grocery", "Party", "Shopping", "Vacation", "Work"]
}

extension IconPickerViewController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iconPickerCell", for: indexPath)
        
        cell.textLabel?.text = iconArray[indexPath.row]
        cell.imageView?.image = UIImage(named: iconArray[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .checkmark
            delegate?.iconPicked(iconName: iconArray[indexPath.row])
            navigationController?.popViewController(animated: true)
        }
    }
    
}

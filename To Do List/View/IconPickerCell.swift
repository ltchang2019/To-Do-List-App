//
//  IconPickerCell.swift
//  To Do List
//
//  Created by Luke Tchang on 1/6/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit

class IconPickerCell: UITableViewCell{
    @IBOutlet weak var iconNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var iconName: String! {
        didSet{
            fillCell()
        }
    }
    
    func fillCell(){
        iconNameLabel.text = iconName
        iconImageView.image = UIImage(named: iconName)
    }
    
}

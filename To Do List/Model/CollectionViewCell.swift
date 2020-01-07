//
//  CollectionViewCell.swift
//  To Do List
//
//  Created by Luke Tchang on 1/6/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var remainingTasks: UILabel!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    static let reuseIdentifier = "ProjectCell"
    let projectColors = [UIColor.systemBlue, UIColor.systemTeal, UIColor.systemOrange, UIColor.systemRed]
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .black
    
    var project: Project!{
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        projectNameLabel.text = project.name
        projectImageView.image = UIImage(named: project.iconName)
        
        let uncheckedTasks = project.countUncheckedTasks()
        if project.tasks.count == 0 {
            remainingTasks.text = "No Tasks"
        } else if uncheckedTasks == 0{
            remainingTasks.text = "All Done!"
        } else {
            remainingTasks.text = "\(uncheckedTasks) Tasks"
        }
        
        let randomNumb = Int.random(in: 0...3)
        progressBarView.backgroundColor = projectColors[randomNumb]
        
        contentView.layer.cornerRadius = 3.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        layer.shadowOpacity = 0.10
        layer.shadowRadius = 15.0
        layer.masksToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
    }
}

//
//  ViewController.swift
//  To Do List
//
//  Created by Luke Tchang on 12/21/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import UIKit
import SwipeCellKit

class ProjectsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var projectItems = [Project]()
    let dataFilePathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Projects.plist")
    
    
    override func viewDidLoad() {
        loadItems()
        print(dataFilePathURL)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePathURL!){
            let decoder  = PropertyListDecoder()
            do{
                projectItems = try decoder.decode([Project].self, from: data)
            } catch {
                print("Error decoding data: \(error)")
            }
//            tableView.reloadData()
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
            if segue.identifier == "CreateNewProject"{
                let addProjectVC = segue.destination as! AddProjectViewController
                addProjectVC.projectItems = self.projectItems
                addProjectVC.projectSavedDelegate = self
            }
    }
}

extension ProjectsViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as! CollectionViewCell
        let project = projectItems[indexPath.item]
        
        cell.project = project
        
        return cell
    }
}

extension ProjectsViewController: ProjectSavedDelegate{
    func reloadAfterSave() {
        loadItems()
        collectionView.reloadData()
    }
}

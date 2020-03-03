//
//  MemeTableViewController.swift
//  meme 2.0
//
//  Created by sudo on 1/9/18.
//  Copyright © 2018 sudo. All rights reserved.
//
import UIKit

import FittedSheets
import CoreData

class BorrowTableViewController: UITableViewController {
    
    var dataController:DataController!
    var imageInfo: [ImageInfo] = []
    var member: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("Now NO")
        
        self.tableView.reloadData()
        let fetchRequest: NSFetchRequest<ImageInfo> = ImageInfo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? dataController.viewContext.fetch(fetchRequest){
            //                                                DestroysCoreDataMaintence(result)
            imageInfo = result
            for object in imageInfo {
                print("\(object.imageData!)")
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageInfo.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        let memeImages = imageInfo[indexPath.row]
        let memeTopText = memeImages.topInfo ?? "No name"
        let memeBottomText = memeImages.bottomInfo ?? "No Number"
        cell.imageView?.image = UIImage(data: memeImages.imageData!)
        cell.textLabel?.text = "\(memeTopText)      \(memeBottomText)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "OptionTableViewController") as! OptionTableViewController
        controller.memberImage = self.imageInfo[indexPath.row].imageData
        controller.memberNumber = self.imageInfo[indexPath.row].bottomInfo
        let sheet = SheetViewController(controller: controller, sizes: [.halfScreen])
        sheet.setSizes([.fixed(215)])
        sheet.adjustForBottomSafeArea = true
        self.present(sheet, animated: false, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto" {
            let destinationVC = segue.destination as! BorrowEditorViewController
            destinationVC.dataController = self.dataController
        }
    }
}
extension UITableView {
    
    func reloadOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func hideExcessCells() {
        tableFooterView = UIView(frame: CGRect.zero)
    }
}

//
//  DragDropTableViewController.swift
//  iOS11FeaturesDemo
//
//  Created by satheeshwaran on 6/7/17.
//  Copyright © 2017 Satheeshwaran. All rights reserved.
//

import UIKit
import MobileCoreServices

class DragDropTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITableViewDragDelegate,UITableViewDropDelegate {
    
    
    @IBOutlet weak var prosTableView: UITableView!
    
    @IBOutlet weak var consTableView: UITableView!
    
    
    var pros = ["This is good!","Has more space"]
    var cons = ["This is not that good!","Has less space"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prosTableView.dragDelegate = self
        self.consTableView.dragDelegate = self
        self.prosTableView.dropDelegate = self
        self.consTableView.dropDelegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableView == self.prosTableView ? pros.count : cons.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dragCell", for: indexPath)
        cell.textLabel?.text = tableView == self.prosTableView ? pros[indexPath.row] : cons[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        if tableView == self.prosTableView{
            
            coordinator.session.loadObjects(ofClass: NSString.self) { items in
                // Consume drag items.
                let stringItems = items as! [String]
                
                var indexPaths = [IndexPath]()
                for (index, item) in stringItems.enumerated() {
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                    self.pros.append(item)
                    indexPaths.append(indexPath)
                }
                
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }else{
            coordinator.session.loadObjects(ofClass: NSString.self) { items in
                // Consume drag items.
                let stringItems = items as! [String]
                
                var indexPaths = [IndexPath]()
                for (index, item) in stringItems.enumerated() {
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                    self.cons.append(item)
                    indexPaths.append(indexPath)
                }
                
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider()
        let data:Data?
        if tableView == prosTableView{
            data = pros[indexPath.row].data(using: .utf8)
        }else{
            data = cons[indexPath.row].data(using: .utf8)
        }
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    /**
     A drop proposal from a table view includes two items: a drop operation,
     typically .move or .copy; and an intent, which declares the action the
     table view will take upon receiving the items. (A drop proposal from a
     custom view does includes only a drop operation, not an intent.)
     */
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        // The .move operation is available only for dragging within a single app.
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(dropOperation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(dropOperation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    
}

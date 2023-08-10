//
//  CustomContentTableViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 04.08.23.
//

import UIKit

class CustomTruthTableViewController: UITableViewController {
    
    let persistentContainer: PersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    var delegate: ContentDelegate?
    
    var data: [CustomContent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.data = self.persistentContainer.fetch(of: CustomContent.self, with: NSPredicate(format: "type == %@", "truth"))
    }
    
    func updateTable(with content: CustomContent, edit: Bool) {
        if edit {
            if let indexToUpdate = self.data.firstIndex(where: {$0.id == content.id}) {
                self.data[indexToUpdate] = content
            }
        } else {
            self.data.append(content)
        }
        
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTruthCell", for: indexPath)

        // Fetch data.
        let cellData = data[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = cellData.data
        content.textProperties.color = UIColor(named: "SoftBlack") ?? .black
        
        cell.contentConfiguration = content
        cell.contentView.layoutMargins.left = 30

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row CoreData
            persistentContainer.viewContext.delete(data[indexPath.row])
            persistentContainer.saveContext()
            
            // Delete the row from the data source
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addCustomContentStoryboard = UIStoryboard(name: "AddCustomContent", bundle: .main)
        let addCustomContentViewController: AddCustomContentViewController = addCustomContentStoryboard.instantiateViewController(identifier: "AddCustomContentScreen")
        
        addCustomContentViewController.type = .truth
        addCustomContentViewController.content = data[indexPath.row]
        addCustomContentViewController.delegate = self.delegate
        
        self.present(addCustomContentViewController, animated: true)
    }
}

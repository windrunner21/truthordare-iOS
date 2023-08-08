//
//  PlayersTableViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 08.08.23.
//

import UIKit

class PlayersTableViewController: UITableViewController {
    var delegate: PlayerManagementDelegate?
    
    var data: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerCellView

        cell.nameLabel.text = data[indexPath.row].getName()
        cell.nameLabel.textColor = UIColor(named: "SoftBlack")
        
        cell.colorCircle.backgroundColor = data[indexPath.row].getColor()
        cell.colorCircle.addElevation()
        cell.colorCircle.toCircle()
        cell.colorCircle.layer.borderWidth = 1.5
        cell.colorCircle.layer.borderColor = UIColor(named: "SoftGray")?.cgColor
        
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
            // Delete the row from the data source
            delegate?.didRemovePlayer(data[indexPath.row])
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if data.isEmpty {
                self.dismiss(animated: true)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}

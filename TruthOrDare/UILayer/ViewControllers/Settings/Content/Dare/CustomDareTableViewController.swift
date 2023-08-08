//
//  CustomDareTableViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 05.08.23.
//

import UIKit

class CustomDareTableViewController: UITableViewController {

    var tempData: [String] = [
        "What is the most embarrassing thing that has ever happened to you?",
        "Have you ever kept a secret from your best friend? If yes, what was it?",
        "What is your biggest fear, and why?",
        "What is the most embarrassing thing you've done while on a date?",
        "Have you ever had a crush on someone in this room? If so, who?",
        "Have you ever lied to get out of trouble? What was the situation?",
        "If you could switch lives with someone for a day, who would it be and why?",
        "What is your most unusual or quirky habit that you're willing to share?",
        "What is the most embarrassing thing that has ever happened to you?",
        "Have you ever kept a secret from your best friend? If yes, what was it?",
        "What is your biggest fear, and why?",
        "What is the most embarrassing thing you've done while on a date?",
        "Have you ever had a crush on someone in this room? If so, who?",
        "Have you ever lied to get out of trouble? What was the situation?",
        "If you could switch lives with someone for a day, who would it be and why?",
        "What is your most unusual or quirky habit that you're willing to share?",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tempData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customDareCell", for: indexPath)

        // Fetch data
        let cellData = tempData[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = cellData
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
            // Delete the row from the data source
            tempData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}

//
//  PlayersViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 08.08.23.
//

import UIKit

class PlayersViewController: UIViewController {
    
    var players: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playersViewToPlayersTable",
            let embeddedTableViewController = segue.destination as? PlayersTableViewController {
            embeddedTableViewController.data = players
        }
    }
}

//
//  GameViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import UIKit

class GameViewController: UIViewController {

    let game = Game()
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerColor: UIView!
    
    @IBOutlet weak var numberOfPlayers: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.playerName.text = self.game.getNumberOfPlayers() == 0 ? "No players" : game.getPlayer()?.name
        self.playerColor.transformToCircle()
        self.playerColor.addElevation()
        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onAdd(_ sender: Any) {
        let player = Player(name: "Imran")
        self.game.addPlayer(player)
        
        self.playerName.text = game.getPlayer()?.name
        self.playerColor.backgroundColor = player.color
        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
    }
    
    @IBAction func onDare(_ sender: Any) {
    }
    
    @IBAction func onTruth(_ sender: Any) {
    }
}

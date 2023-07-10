//
//  ViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSettings(_ sender: Any) {
        let settingsStoryboard: UIStoryboard = UIStoryboard(name: "Settings", bundle: .main)
        let settingsViewController: SettingsViewController = settingsStoryboard.instantiateViewController(identifier: "SettingsScreen")
        
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @IBAction func onPlay(_ sender: Any) {
        let gameStoryboard: UIStoryboard = UIStoryboard(name: "Game", bundle: .main)
        let gameViewController: GameViewController = gameStoryboard.instantiateViewController(identifier: "GameScreen")
        
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
    
}


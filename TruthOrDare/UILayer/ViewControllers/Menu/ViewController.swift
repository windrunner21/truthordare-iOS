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
        
        self.applyGrayHalfBackground()
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
    
    private func applyGrayHalfBackground() {
        let grayLayer = CALayer()
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        
        grayLayer.backgroundColor = UIColor(named: "SoftGray")?.cgColor
        grayLayer.frame = CGRect(x: screenWidth / 2, y: 0, width: screenWidth / 2, height: screenHeight)
        self.view.layer.insertSublayer(grayLayer, at: 0)
    }
}


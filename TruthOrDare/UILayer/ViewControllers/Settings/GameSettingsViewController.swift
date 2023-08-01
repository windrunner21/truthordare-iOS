//
//  GameSettingsViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 01.08.23.
//

import UIKit

class GameSettingsViewController: UIViewController {

    // Storyboard related properties.
    @IBOutlet weak var truthStackView: UIStackView!
    @IBOutlet weak var dareStackView: UIStackView!
    @IBOutlet weak var randomizeStackView: UIStackView!
    
    @IBOutlet weak var truthSwitch: UISwitch!
    @IBOutlet weak var dareSwitch: UISwitch!
    @IBOutlet weak var randomizePlayersSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBorder(to: [truthStackView, dareStackView, randomizeStackView])
        
        self.truthSwitch.isOn = true
        self.dareSwitch.isOn = true
        self.randomizePlayersSwitch.isOn = true
    }

    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func addBorder(to stackViews: [UIStackView]) {
        for stackView in stackViews {
            stackView.layer.borderWidth = 1
            stackView.layer.borderColor = UIColor.black.cgColor
            stackView.layer.cornerRadius = 6
        }
    }
    
    
    @IBAction func onTruthSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("im on")
        } else {
            print("im off")
        }
    }
    
    @IBAction func onDareSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("im on 2")
        } else {
            print("im off 2")
        }
    }
    
    @IBAction func onRandomizePlayersSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            print("im on 3")
        } else {
            print("im off 3")
        }
    }
}

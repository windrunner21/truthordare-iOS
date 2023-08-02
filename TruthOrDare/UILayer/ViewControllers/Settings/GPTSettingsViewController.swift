//
//  GPTSettingsViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 01.08.23.
//

import UIKit

class GPTSettingsViewController: UIViewController {

    @IBOutlet weak var truthStackView: UIStackView!
    @IBOutlet weak var dareStackView: UIStackView!
    
    @IBOutlet weak var truthSwitch: UISwitch!
    @IBOutlet weak var dareSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBorder(to: [truthStackView, dareStackView])
        
        guard let settings = Settings.retrieveSettings() else { return }
        
        self.truthSwitch.isOn = settings.isChatGPTTruthEnabled
        self.dareSwitch.isOn = settings.isChatGPTDareEnabled
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
            print("im onn")
        } else {
            print("im offf")
        }
    }
    
    @IBAction func onDareSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("im onn 2")
        } else {
            print("im offf 2")
        }
    }
}

//
//  CustomSettingsViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 01.08.23.
//

import UIKit

class CustomSettingsViewController: UIViewController {

    
    @IBOutlet weak var truthStackView: UIStackView!
    @IBOutlet weak var dareStackView: UIStackView!
    @IBOutlet weak var noContentStackView: UIStackView!
    
    @IBOutlet weak var customTruthSwitch: UISwitch!
    @IBOutlet weak var customDareSwitch: UISwitch!
    @IBOutlet weak var noContentSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBorder(to: [truthStackView, dareStackView, noContentStackView])
        
        guard let settings = Settings.retrieveSettings() else { return }
        
        self.customTruthSwitch.isOn = settings.isCustomTruthEnabled
        self.customDareSwitch.isOn = settings.isCustomDareEnabled
        self.noContentSwitch.isOn = settings.isNoContentEnabled
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
    
    
    @IBAction func onCustomTruthSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("im onnn")
        } else {
            print("im offff")
        }
    }
    
    
    @IBAction func onCustomDareSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("im onnn 2")
        } else {
            print("im offff 2")
        }
    }
    
    
    @IBAction func onNoContentSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("im onnn 3")
        } else {
            print("im offff 3")
        }
    }
}

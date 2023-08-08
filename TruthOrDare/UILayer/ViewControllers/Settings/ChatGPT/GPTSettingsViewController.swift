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
    
    // Other properties.
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBorder(to: [truthStackView, dareStackView])
        
        self.settings = Settings.retrieveSettings()
        self.setSettings()
    }

    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func addBorder(to stackViews: [UIStackView]) {
        for stackView in stackViews {
            stackView.layer.borderWidth = 1
            stackView.layer.borderColor = UIColor(named: "SoftBlack")?.cgColor
            stackView.layer.cornerRadius = 6
        }
    }
    
    
    @IBAction func onTruthSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isChatGPTTruthEnabled = sender.isOn
        Settings.updateSettings(using: settings)
    }
    
    @IBAction func onDareSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isChatGPTDareEnabled = sender.isOn
        Settings.updateSettings(using: settings)
    }
    
    private func setSettings() {
        if let settings = self.settings {
            self.truthSwitch.isOn = settings.isChatGPTTruthEnabled
            self.dareSwitch.isOn = settings.isChatGPTDareEnabled
        } else {
            let alert = UIAlertController(title: "Error", message: "Could not retrieve settings", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: { _ in
                        UserDefaults.standard.removeObject(forKey: "settings")
                        alert.dismiss(animated: true)
                    }
                )
            )
            
            self.present(alert, animated: true)
        }
    }
}

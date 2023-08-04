//
//  CustomSettingsViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 01.08.23.
//

import UIKit

class CustomSettingsViewController: UIViewController {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addDareButton: UIButton!
    @IBOutlet weak var addTruthButton: UIButton!
    
    @IBOutlet weak var truthStackView: UIStackView!
    @IBOutlet weak var dareStackView: UIStackView!
    @IBOutlet weak var noContentStackView: UIStackView!
    
    @IBOutlet weak var customTruthSwitch: UISwitch!
    @IBOutlet weak var customDareSwitch: UISwitch!
    @IBOutlet weak var noContentSwitch: UISwitch!
    
    // Other properties.
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.addBorder(to: [truthStackView, dareStackView, noContentStackView])
        
        self.settings = Settings.retrieveSettings()
        self.setSettings()
    }

    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAddDare(_ sender: Any) {
    }
    
    @IBAction func onAddTruth(_ sender: Any) {
    }
    
    private func addBorder(to stackViews: [UIStackView]) {
        for stackView in stackViews {
            stackView.layer.borderWidth = 1
            stackView.layer.borderColor = UIColor.black.cgColor
            stackView.layer.cornerRadius = 6
        }
    }
    
    @IBAction func onCustomTruthSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isCustomTruthEnabled = sender.isOn
        
        if settings.isCustomTruthEnabled || settings.isCustomDareEnabled {
            settings.isNoContentEnabled = false
            self.noContentSwitch.setOn(settings.isNoContentEnabled, animated: true)
        }
        
        self.editButton.isHidden = !settings.isCustomTruthEnabled && !settings.isCustomDareEnabled
        self.addTruthButton.isHidden = !settings.isCustomTruthEnabled
        self.addDareButton.isHidden = !settings.isCustomDareEnabled
        
        Settings.updateSettings(using: settings)
    }
    
    
    @IBAction func onCustomDareSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isCustomDareEnabled = sender.isOn
        
        if settings.isCustomTruthEnabled || settings.isCustomDareEnabled {
            settings.isNoContentEnabled = false
            self.noContentSwitch.setOn(settings.isNoContentEnabled, animated: true)
        }
        
        self.editButton.isHidden = !settings.isCustomTruthEnabled && !settings.isCustomDareEnabled
        self.addTruthButton.isHidden = !settings.isCustomTruthEnabled
        self.addDareButton.isHidden = !settings.isCustomDareEnabled
        
        Settings.updateSettings(using: settings)
    }
    
    
    @IBAction func onNoContentSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isNoContentEnabled = sender.isOn
        
        if settings.isNoContentEnabled {
            settings.isCustomTruthEnabled = false
            settings.isCustomDareEnabled = false
            
            self.customTruthSwitch.setOn(settings.isCustomTruthEnabled, animated: true)
            self.customDareSwitch.setOn(settings.isCustomDareEnabled, animated: true)
            
            // Regulate edit, and action buttons if custom truth or dare enabled.
            self.editButton.isHidden = true
            self.addTruthButton.isHidden = true
            self.addDareButton.isHidden = true
        }
        
        Settings.updateSettings(using: settings)
    }
    
    private func setSettings() {
        if let settings = self.settings {
            self.customTruthSwitch.isOn = settings.isCustomTruthEnabled
            self.customDareSwitch.isOn = settings.isCustomDareEnabled
            self.noContentSwitch.isOn = settings.isNoContentEnabled
            
            // Regulate edit, and action buttons if custom truth or dare enabled.
            self.editButton.isHidden = !(settings.isCustomTruthEnabled || settings.isCustomDareEnabled)
            self.addTruthButton.isHidden = !settings.isCustomTruthEnabled
            self.addDareButton.isHidden = !settings.isCustomDareEnabled
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

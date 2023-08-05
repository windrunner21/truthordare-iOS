//
//  CustomTruthViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 05.08.23.
//

import UIKit

class CustomTruthViewController: UIViewController {
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addTruthButton: UIButton!
    
    // Storyboard properties.
    @IBOutlet weak var customTruthStackView: UIStackView!
    @IBOutlet weak var customTruthSwitch: UISwitch!
    
    // Other properties.
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBorder(to: customTruthStackView)
        
        self.settings = Settings.retrieveSettings()
        self.setSettings()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func addBorder(to stackView: UIStackView) {
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.layer.cornerRadius = 6
    }

    @IBAction func onCustomTruthSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isCustomTruthEnabled = sender.isOn
        
        if settings.isCustomTruthEnabled {
            settings.isNoContentEnabled = false
        }
        
        self.editButton.isHidden = !settings.isCustomTruthEnabled
        self.addTruthButton.isHidden = !settings.isCustomTruthEnabled
        
        Settings.updateSettings(using: settings)
    }

    private func setSettings() {
        if let settings = self.settings {
            self.customTruthSwitch.isOn = settings.isCustomTruthEnabled
            
            // Regulate edit, and action buttons, and scroll view if custom truth or dare enabled.
            self.editButton.isHidden = !settings.isCustomTruthEnabled
            self.addTruthButton.isHidden = !settings.isCustomTruthEnabled
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

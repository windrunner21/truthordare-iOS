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
    
    // Other properties.
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBorder(to: [truthStackView, dareStackView, randomizeStackView])
        
        self.settings = Settings.retrieveSettings()
        self.setSettings()
    }

    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTruthSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isTruthGameModeEnabled = sender.isOn
        
        if !settings.isTruthGameModeEnabled && !settings.isDareGameModeEnabled {
            settings.isDareGameModeEnabled = true
            self.dareSwitch.setOn(settings.isDareGameModeEnabled, animated: true)
        }

        Settings.updateSettings(using: settings)
    }
    
    @IBAction func onDareSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isDareGameModeEnabled = sender.isOn
        
        if !settings.isTruthGameModeEnabled && !settings.isDareGameModeEnabled {
            settings.isTruthGameModeEnabled = true
            self.truthSwitch.setOn(settings.isTruthGameModeEnabled, animated: true)
        }
        
        Settings.updateSettings(using: settings)
    }
    
    @IBAction func onRandomizePlayersSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isRandomizePlayerEnabled = sender.isOn
        Settings.updateSettings(using: settings)
    }
    
    private func addBorder(to stackViews: [UIStackView]) {
        for stackView in stackViews {
            stackView.layer.borderWidth = 1
            stackView.layer.borderColor = UIColor.black.cgColor
            stackView.layer.cornerRadius = 6
        }
    }
    
    private func setSettings() {
        if let settings = self.settings {
            self.truthSwitch.isOn = settings.isTruthGameModeEnabled
            self.dareSwitch.isOn = settings.isDareGameModeEnabled
            self.randomizePlayersSwitch.isOn = settings.isRandomizePlayerEnabled
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

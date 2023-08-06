//
//  CustomDareViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 05.08.23.
//

import UIKit

class CustomDareViewController: UIViewController {
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addDareButton: UIButton!
    
    @IBOutlet weak var customDareStackView: UIStackView!
    @IBOutlet weak var customDareSwitch: UISwitch!
    
    // Other properties.
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBorder(to: customDareStackView)
                
        self.settings = Settings.retrieveSettings()
        self.setSettings()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCustomDareAdd(_ sender: Any) {
        let addCustomContentStoryboard = UIStoryboard(name: "AddCustomContent", bundle: .main)
        let addCustomContentViewController: AddCustomContentViewController = addCustomContentStoryboard.instantiateViewController(identifier: "AddCustomContentScreen")
        
        addCustomContentViewController.type = .dare
        
        self.present(addCustomContentViewController, animated: true)
    }
    
    private func addBorder(to stackView: UIStackView) {
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.layer.cornerRadius = 6
    }

    @IBAction func onCustomDareSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isCustomDareEnabled = sender.isOn
        
        if settings.isCustomDareEnabled {
            settings.isNoContentEnabled = false
        }
        
        self.editButton.isHidden = !settings.isCustomDareEnabled
        self.addDareButton.isHidden = !settings.isCustomDareEnabled
        
        Settings.updateSettings(using: settings)
    }
    
    private func setSettings() {
        if let settings = self.settings {
            self.customDareSwitch.isOn = settings.isCustomDareEnabled
            
            // Regulate edit, and action buttons, and scroll view if custom truth or dare enabled.
            self.editButton.isHidden = !settings.isCustomDareEnabled
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

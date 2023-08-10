//
//  CustomDareViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 05.08.23.
//

import UIKit
import CoreData

class CustomDareViewController: UIViewController, ContentDelegate {
    
    // Storyboard properties.
    @IBOutlet weak var addDareButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
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
        addCustomContentViewController.delegate = self
        
        self.present(addCustomContentViewController, animated: true)
    }
    
    func didUpdateContent(_ content: CustomContent, isEditing: Bool) {
        if let embeddedTableViewController = children.first(where: {$0 is CustomDareTableViewController}) as? CustomDareTableViewController {
            embeddedTableViewController.updateTable(with: content, edit: isEditing)
        }
    }
    
    private func addBorder(to stackView: UIStackView) {
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor(named: "SoftBlack")?.cgColor
        stackView.layer.cornerRadius = 6
    }

    @IBAction func onCustomDareSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isCustomDareEnabled = sender.isOn
        
        if settings.isCustomDareEnabled {
            settings.isNoContentEnabled = false
        }
        
        self.addDareButton.isHidden = !settings.isCustomDareEnabled
        self.containerView.isHidden = !settings.isCustomDareEnabled
        
        Settings.updateSettings(using: settings)
    }
    
    private func setSettings() {
        if let settings = self.settings {
            self.customDareSwitch.isOn = settings.isCustomDareEnabled
            
            // Regulate action buttons, and scroll view if custom truth or dare enabled.
            self.addDareButton.isHidden = !settings.isCustomDareEnabled
            self.containerView.isHidden = !settings.isCustomDareEnabled
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dareViewToDareTable",
            let embeddedTableViewController = segue.destination as? CustomDareTableViewController {
            embeddedTableViewController.delegate = self
        }
    }

}

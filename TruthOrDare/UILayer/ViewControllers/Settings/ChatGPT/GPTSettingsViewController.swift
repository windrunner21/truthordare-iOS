//
//  GPTSettingsViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 01.08.23.
//

import UIKit

class GPTSettingsViewController: UIViewController {
    
    // Storyboard related properties.
    @IBOutlet weak var truthStackView: UIStackView!
    @IBOutlet weak var dareStackView: UIStackView!
    
    @IBOutlet weak var truthLabel: UILabel!
    @IBOutlet weak var dareLabel: UILabel!
    
    @IBOutlet weak var truthSwitch: UISwitch!
    @IBOutlet weak var dareSwitch: UISwitch!
    
    @IBOutlet weak var activateLabel: UILabel!
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    // Other properties.
    private var transactionManager: TransactionManager = TransactionManager.shared
    private var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBorder(to: [truthStackView, dareStackView])
        
        self.settings = Settings.retrieveSettings()
        self.setSettings()
        
        self.truthSwitch.isEnabled = transactionManager.isPremium
        self.dareSwitch.isEnabled = transactionManager.isPremium
        
        self.truthLabel.textColor = transactionManager.isPremium ? UIColor(named: "SoftBlack") : UIColor(named: "TapColor")
        self.dareLabel.textColor = transactionManager.isPremium ? UIColor(named: "SoftBlack") : UIColor(named: "TapColor")
        
        self.activateLabel.isHidden = transactionManager.isPremium
        self.restoreButton.isHidden = !transactionManager.isPremium
        self.activateButton.isHidden = transactionManager.isPremium
        
        if !transactionManager.isPremium {
            Task {
                try await transactionManager.fetchProducts()
            }
        }
    }

    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onActivateSubscription(_ sender: Any) {
        
        self.activateButton.configuration?.showsActivityIndicator = true
        self.activateButton.setTitle("", for: .normal)
        
        Task {
            guard let montlySubscription = transactionManager.products.first else { return}
            try await transactionManager.purchase(montlySubscription)
            
            self.activateButton.configuration?.showsActivityIndicator = false
            self.activateButton.setTitle("Activate TruthAI+", for: .normal)
        }
    }
    
    @IBAction func onRestorePurchases(_ sender: Any) {
        
        self.restoreButton.configuration?.showsActivityIndicator = true
        self.restoreButton.setTitle("", for: .normal)
        
        Task {
            try await transactionManager.restorePurchases()
            
            self.activateButton.configuration?.showsActivityIndicator = false
            self.activateButton.setTitle("Restore Purchases", for: .normal)
        }
    }
    
    private func addBorder(to stackViews: [UIStackView]) {
        for stackView in stackViews {
            stackView.layer.borderWidth = 1
            stackView.layer.borderColor = transactionManager.isPremium ? UIColor(named: "SoftBlack")?.cgColor : UIColor(named: "TapColor")?.cgColor
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

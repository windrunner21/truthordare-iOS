//
//  GPTSettingsViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 01.08.23.
//

import UIKit

class GPTSettingsViewController: UIViewController {
    
    // Links to Privacy Policy and Terms of Use
    private let privacyPolicyLink = "https://truth-or-dare-ai.vercel.app/privacy-policy"
    private let termsOfUseLink = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula"
    
    // Storyboard related properties.
    @IBOutlet weak var truthStackView: UIStackView!
    @IBOutlet weak var dareStackView: UIStackView!
    
    @IBOutlet weak var truthLabel: UILabel!
    @IBOutlet weak var dareLabel: UILabel!
    
    @IBOutlet weak var truthSwitch: UISwitch!
    @IBOutlet weak var dareSwitch: UISwitch!
    
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    @IBOutlet weak var termsAndConditionsTextView: UITextView!
    
    // Other properties.
    private var transactionManager: TransactionManager = TransactionManager.shared
    private var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBorder(to: [truthStackView, dareStackView])
        
        self.setupTermsAndConditionsLabel()
        
        self.settings = Settings.retrieveSettings()
        
        self.checkSubscriptionAccess()
        
        if !transactionManager.isPremium {
            Task {
                try await transactionManager.fetchProducts()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSubscriptionAccess), name: NSNotification.Name("CheckAccess"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("REFUND"), object: nil)
    }

    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onActivateSubscription(_ sender: Any) {
        self.activateButton.configuration?.showsActivityIndicator = true
        self.activateButton.setTitle("", for: .normal)
        self.activateButton.isEnabled = false
        
        Task {
            guard let montlySubscription = transactionManager.products.first else { return}
            try await transactionManager.purchase(montlySubscription)
            
            self.activateButton.configuration?.showsActivityIndicator = false
            self.activateButton.setTitle("Activate TruthAI+", for: .normal)
            self.activateButton.isEnabled = true
            
            self.checkSubscriptionAccess()
        }
    }
    
    @IBAction func onRestorePurchases(_ sender: Any) {
        self.restoreButton.configuration?.showsActivityIndicator = true
        self.restoreButton.setTitle("", for: .normal)
        self.restoreButton.isEnabled = false
        
        Task {
            try await transactionManager.restorePurchases()
            
            self.restoreButton.configuration?.showsActivityIndicator = false
            self.restoreButton.setTitle("Restore Purchases", for: .normal)
            self.restoreButton.isEnabled = true
            
            self.checkSubscriptionAccess()
        }
    }
    
    private func addBorder(to stackViews: [UIStackView]) {
        for stackView in stackViews {
            stackView.layer.borderWidth = 1
            stackView.layer.cornerRadius = 6
        }
    }
    
    private func setBorderColor(to stackViews: [UIStackView]) {
        for stackView in stackViews {
            stackView.layer.borderColor = transactionManager.isPremium ? UIColor(named: "SoftBlack")?.cgColor : UIColor(named: "TapColor")?.cgColor
        }
    }
    
    @IBAction func onTruthSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isChatGPTTruthEnabled = sender.isOn
        
        if settings.isChatGPTTruthEnabled {
            settings.isNoContentEnabled = false
            settings.isCustomTruthEnabled = false
        }
        
        Settings.updateSettings(using: settings)
    }
    
    @IBAction func onDareSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isChatGPTDareEnabled = sender.isOn
        
        if settings.isChatGPTDareEnabled {
            settings.isNoContentEnabled = false
            settings.isCustomDareEnabled = false
        }
        
        Settings.updateSettings(using: settings)
    }
    
    private func setSettings() {
        if let settings = self.settings {
            self.truthSwitch.isOn = self.transactionManager.isPremium ? settings.isChatGPTTruthEnabled : false
            self.dareSwitch.isOn = self.transactionManager.isPremium ? settings.isChatGPTDareEnabled : false
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
    
    @objc private func checkSubscriptionAccess() {
        DispatchQueue.main.async {
            self.truthSwitch.isEnabled = self.transactionManager.isPremium
            self.dareSwitch.isEnabled = self.transactionManager.isPremium
            
            self.truthLabel.textColor = self.transactionManager.isPremium ? UIColor(named: "SoftBlack") : UIColor(named: "TapColor")
            self.dareLabel.textColor = self.transactionManager.isPremium ? UIColor(named: "SoftBlack") : UIColor(named: "TapColor")
            
            self.restoreButton.isHidden = self.transactionManager.isPremium
            self.activateButton.isHidden = self.transactionManager.isPremium
            
            self.setBorderColor(to: [self.truthStackView, self.dareStackView])
            
            self.setSettings()
        }

    }
    
    private func setupTermsAndConditionsLabel() {
        let attributedString = NSMutableAttributedString(string: "By using TruthAI+, you agree to our ")
        let concatAttributedString = NSAttributedString(string: " and ")
        
        // Terms of Use Link
        let termsOfUseText = "Terms of Use (EULA)"
        let termsOfUseLinkAttributes: [NSAttributedString.Key: Any] = [
            .link: termsOfUseLink,
            .foregroundColor: UIColor.systemBlue
        ]
        let termsOfUseLinkAttributedString = NSAttributedString(string: termsOfUseText, attributes: termsOfUseLinkAttributes)
        
        attributedString.append(termsOfUseLinkAttributedString)
        
        // Concatenate next link
        attributedString.append(concatAttributedString)

        // Privacy Policy Link
        let privacyPolicyText = "Privacy Policy"
        let privacyPolicyLinkAttributes: [NSAttributedString.Key: Any] = [
            .link: privacyPolicyLink,
            .foregroundColor: UIColor.systemBlue
        ]
        let privacyPolicyLinkAttributedString = NSAttributedString(string: privacyPolicyText, attributes: privacyPolicyLinkAttributes)

        attributedString.append(privacyPolicyLinkAttributedString)
        
        // Apply the line height to the entire attributed string
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5
        attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        
        termsAndConditionsTextView.attributedText = attributedString
        termsAndConditionsTextView.textAlignment = .center
        
        termsAndConditionsTextView.isUserInteractionEnabled = true
        termsAndConditionsTextView.delegate = self
    }
}

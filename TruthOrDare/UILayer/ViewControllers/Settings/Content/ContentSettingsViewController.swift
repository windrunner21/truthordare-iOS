//
//  CustomSettingsViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 01.08.23.
//

import UIKit

class ContentSettingsViewController: UIViewController {
    
    @IBOutlet weak var customTruthStackView: UIStackView!
    @IBOutlet weak var customDareStackView: UIStackView!
    @IBOutlet weak var noContentStackView: UIStackView!
    
    @IBOutlet weak var noContentSwitch: UISwitch!
    
    // Other properties.
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.addBorder(to: [customTruthStackView, customDareStackView, noContentStackView])
        
        let customTruthLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        customTruthLongPressGestureRecognizer.minimumPressDuration = 0
        let customDareLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        customDareLongPressGestureRecognizer.minimumPressDuration = 0

        self.customTruthStackView.addGestureRecognizer(customTruthLongPressGestureRecognizer)
        self.customDareStackView.addGestureRecognizer(customDareLongPressGestureRecognizer)
        
        self.settings = Settings.retrieveSettings()
        self.setSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settings = Settings.retrieveSettings()
        self.setSettings()
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        var storyboard: UIStoryboard
        var viewContoller: UIViewController
        
        switch gestureRecognizer.view {
        case self.customTruthStackView:
            storyboard = UIStoryboard(name: "CustomTruth", bundle: .main)
            viewContoller = storyboard.instantiateViewController(identifier: "CustomTruthScreen")
            self.handleViewChange(for: self.customTruthStackView, using: gestureRecognizer, changetTo: viewContoller)
        case self.customDareStackView:
            storyboard = UIStoryboard(name: "CustomDare", bundle: .main)
            viewContoller = storyboard.instantiateViewController(identifier: "CustomDareScreen")
            self.handleViewChange(for: self.customDareStackView, using: gestureRecognizer, changetTo: viewContoller)
        default:
            break
        }
    }
    
    private func handleViewChange(for view: UIStackView, using recognizer: UIGestureRecognizer, changetTo viewController: UIViewController) {
        switch recognizer.state {
        case .began, .changed:
            view.backgroundColor = UIColor(named: "TapColor")
        case .ended:
            self.navigationController?.pushViewController(viewController, animated: true)
            view.backgroundColor = UIColor(named: "BackgroundColor")
        default:
            view.backgroundColor = UIColor(named: "BackgroundColor")
        }
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
    
    @IBAction func onNoContentSwitch(_ sender: UISwitch) {
        guard let settings = settings else { return }
        settings.isNoContentEnabled = sender.isOn
        
        if settings.isNoContentEnabled {
            settings.isChatGPTTruthEnabled = false
            settings.isChatGPTDareEnabled = false
            settings.isCustomTruthEnabled = false
            settings.isCustomDareEnabled = false
        }
        
        Settings.updateSettings(using: settings)
    }
    
    private func setSettings() {
        if let settings = self.settings {
            self.noContentSwitch.isOn = settings.isNoContentEnabled
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

//
//  SettingsViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var gameModeStackView: UIStackView!
    @IBOutlet weak var chatGPTStackView: UIStackView!
    @IBOutlet weak var customStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBorder(to: [gameModeStackView, chatGPTStackView, customStackView])

        let gameModeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        let gameModeLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tap2))
        self.gameModeStackView.addGestureRecognizer(gameModeTapGestureRecognizer)
        self.gameModeStackView.addGestureRecognizer(gameModeLongPressGestureRecognizer)
    }

    @objc func tap() {
        print("tapped")
    }
    
    @objc func tap2(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.gameModeStackView.backgroundColor = .systemGray6
        case .ended:
            self.gameModeStackView.backgroundColor = .white
        default:
            break
        }
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
}

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

        let gameModeLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gameModeLongPressGestureRecognizer.minimumPressDuration = 0
        let chatGPTLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        chatGPTLongPressGestureRecognizer.minimumPressDuration = 0
        let customLongPresspGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        customLongPresspGestureRecognizer.minimumPressDuration = 0

        self.gameModeStackView.addGestureRecognizer(gameModeLongPressGestureRecognizer)
        self.chatGPTStackView.addGestureRecognizer(chatGPTLongPressGestureRecognizer)
        self.customStackView.addGestureRecognizer(customLongPresspGestureRecognizer)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.view {
        case self.gameModeStackView:
            self.handleViewChange(for: self.gameModeStackView, and: gestureRecognizer)
        case self.chatGPTStackView:
            self.handleViewChange(for: self.chatGPTStackView, and: gestureRecognizer)
        case self.customStackView:
            self.handleViewChange(for: self.customStackView, and: gestureRecognizer)
        default:
            break
        }
    }
    
    private func handleViewChange(for view: UIStackView, and recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            view.backgroundColor = .systemGray6
        case .ended:
            print("tapped 5")
            view.backgroundColor = .white
        default:
            view.backgroundColor = .white
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

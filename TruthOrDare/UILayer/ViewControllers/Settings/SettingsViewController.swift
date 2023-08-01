//
//  SettingsViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // Storyboard related properties.
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
        var storyboard: UIStoryboard
        var viewContoller: UIViewController
        
        switch gestureRecognizer.view {
        case self.gameModeStackView:
            storyboard = UIStoryboard(name: "GameSettings", bundle: .main)
            viewContoller = storyboard.instantiateViewController(identifier: "GameSettingsScreen")
            self.handleViewChange(for: self.gameModeStackView, using: gestureRecognizer, changetTo: viewContoller)
        case self.chatGPTStackView:
            storyboard = UIStoryboard(name: "GPTSettings", bundle: .main)
            viewContoller = storyboard.instantiateViewController(identifier: "GPTSettingsScreen")
            self.handleViewChange(for: self.chatGPTStackView, using: gestureRecognizer, changetTo: viewContoller)
        case self.customStackView:
            storyboard = UIStoryboard(name: "CustomSettings", bundle: .main)
            viewContoller = storyboard.instantiateViewController(identifier: "CustomSettingsScreen")
            self.handleViewChange(for: self.customStackView, using: gestureRecognizer, changetTo: viewContoller)
        default:
            break
        }
    }
    
    private func handleViewChange(for view: UIStackView, using recognizer: UIGestureRecognizer, changetTo viewController: UIViewController) {
        switch recognizer.state {
        case .began, .changed:
            view.backgroundColor = .systemGray6
        case .ended:
            self.navigationController?.pushViewController(viewController, animated: true)
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

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBorder(to: [truthStackView, dareStackView, randomizeStackView])
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

//
//  AddCustomContentViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 06.08.23.
//

import UIKit

class AddCustomContentViewController: UIViewController {
    
    var type: RoundType!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = "New \(type.value)"
    }

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

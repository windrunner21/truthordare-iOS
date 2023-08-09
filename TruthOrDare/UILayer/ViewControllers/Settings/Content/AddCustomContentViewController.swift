//
//  AddCustomContentViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 06.08.23.
//

import UIKit

class AddCustomContentViewController: UIViewController, UITextViewDelegate {
    
    var type: RoundType!
    var placeholder: String = String()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.placeholder = "Type in your custom \(type.value)"
        
        self.titleLabel.text = "New \(type.value)"
        
        self.contentTextView.delegate = self
        self.contentTextView.textColor = .lightGray
        self.contentTextView.text = self.placeholder
        
        // Add tap gesture recognizer to listen to external taps.
        let keyboardOutsideTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(keyboardOutsideTapGestureRecognizer)
    }

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeholder {
            textView.textColor = UIColor(named: "SoftBlack")
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightGray
            textView.text = self.placeholder
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

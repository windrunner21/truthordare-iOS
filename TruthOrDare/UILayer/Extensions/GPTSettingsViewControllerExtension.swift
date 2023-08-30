//
//  GPTSettingsViewControllerExtension.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 30.08.23.
//

import UIKit

extension GPTSettingsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // Handle URL interaction here
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}

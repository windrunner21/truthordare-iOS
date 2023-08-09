//
//  AddCustomContentViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 06.08.23.
//

import UIKit

class AddCustomContentViewController: UIViewController, UITextViewDelegate {
    
    let persistentContainer: PersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    var delegate: ContentDelegate?
    
    var type: RoundType!
    var placeholder: String = String()
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentTextViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.doneButton.isEnabled = false
        
        self.placeholder = "Type in your custom \(type.rawValue)..."
        
        self.titleLabel.text = "New \(type.rawValue)"
        
        self.contentTextView.delegate = self
        self.contentTextView.textColor = UIColor(named: "SoftBlack")?.withAlphaComponent(0.75)
        self.contentTextView.text = self.placeholder
        
        // Add tap gesture recognizer to listen to external taps.
        let keyboardOutsideTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(keyboardOutsideTapGestureRecognizer)
        
        self.configureKeyboardNotifications()
    }

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let newContent = CustomContent(context: persistentContainer.viewContext)
        
        newContent.id = UUID()
        newContent.created = Date.now
        newContent.data = contentTextView.text
        newContent.type = type.rawValue
        
        persistentContainer.saveContext()
        
        self.delegate?.didUpdateContent(newContent)
        
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
            textView.textColor = UIColor(named: "SoftBlack")?.withAlphaComponent(0.75)
            textView.text = self.placeholder
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.doneButton.isEnabled = !textView.text.isEmpty
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func configureKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if contentTextView.isEditable {
            self.moveWithKeyboard(self.contentTextViewBottomConstraint, on: notification, by: 30, up: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.moveWithKeyboard(self.contentTextViewBottomConstraint, on: notification, by: 30, up: false)
    }
    
    private func moveWithKeyboard(_ constraint: NSLayoutConstraint, on notification: NSNotification, by value: CGFloat, up: Bool) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = UIView.AnimationCurve(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int) else { return }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        if up {
            let safeArea = self.view.window?.safeAreaInsets.bottom != 0
            constraint.constant = keyboardHeight + (safeArea ? 0 : value)
        } else {
            constraint.constant = value
        }
        
        let animation = UIViewPropertyAnimator(duration: duration, curve: curve) { [weak self] in
            self?.view?.layoutIfNeeded()
        }
        
        animation.startAnimation()
    }
}

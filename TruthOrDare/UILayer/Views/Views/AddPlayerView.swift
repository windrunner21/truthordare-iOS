//
//  AddPlayerView.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 11.07.23.
//

import UIKit

class AddPlayerView: UIView, UITextFieldDelegate {
    var delegate: PlayerManagementDelegate?
    
    // UI Properties - storyboard and code.
    private let overlayView: UIView = UIView()

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerColorPopUp: UIButton!
    
    var player: Player = Player()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AddPlayer", owner: self)
        
        self.configureKeyboardNotifications()
        
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.addElevation()
        
        // Add overlay to disable user interaction and clearly seperate design wise.
        self.overlayView.backgroundColor = .black.withAlphaComponent(0.3)
        self.overlayView.frame = UIScreen.main.bounds
        self.overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(overlayView)
        
        // Setting up UI elements.
        self.setupPlayerColorPopUp()
        self.setupPlayerNameTextField()
        
        if self.playerColorPopUp.menu?.selectedElements[0].title == "Blue" {
            self.player.setColor(to: PlayerColor.blue.color)
        }
    }
    
    func show() {
        superview?.insertSubview(self.overlayView, belowSubview: self)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.removeFromSuperview()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func onAddPlayer(_ sender: Any) {
        if let playerName = self.playerNameTextField.text, !playerName.isEmpty {
            self.player.setName(to: playerName)
        }
        
        delegate?.didAddPlayer(self.player)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.removeFromSuperview()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    private func setupPlayerColorPopUp() {
        var children: [UIAction] = []
        for color in PlayerColor.allCases {
            children.append(
                UIAction(
                    title: color.label,
                    handler: { _ in
                        self.player.setColor(to: color.color)
                    }
                )
            )
        }
        
        playerColorPopUp.menu = UIMenu(children: children)
        
        playerColorPopUp.showsMenuAsPrimaryAction = true
    }
    
    private func setupPlayerNameTextField() {
        self.playerNameTextField.delegate = self
        self.playerNameTextField.layer.borderColor = UIColor(named: "SoftGray")?.cgColor
        self.playerNameTextField.layer.borderWidth = 0.6
        self.playerNameTextField.layer.cornerRadius = 6
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.playerNameTextField.layer.borderColor = UIColor(named: "SoftBlack")?.cgColor
        textField.layer.borderWidth = 1.2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0.6
        self.playerNameTextField.layer.borderColor = UIColor(named: "SoftGray")?.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        if self.playerNameTextField.isEditing {
            self.moveWithKeyboard(on: notification, up: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.moveWithKeyboard(on: notification, up: false)
    }
    
    private func moveWithKeyboard(on notification: NSNotification, up: Bool) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = UIView.AnimationCurve(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int) else { return }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        if up {
            self.frame.origin.y = UIScreen.main.bounds.height - keyboardHeight - 30 - self.frame.size.height
        } else {
            self.frame.origin.y = UIScreen.main.bounds.height / 2 - 125
        }
        
        let animation = UIViewPropertyAnimator(duration: duration, curve: curve) { [weak self] in
            self?.layoutIfNeeded()
        }
        
        animation.startAnimation()
    }
}

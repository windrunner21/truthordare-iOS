//
//  AddPlayerView.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 11.07.23.
//

import UIKit
import Combine

class AddPlayerView: UIView, UITextFieldDelegate {
    let playerPublisher = PassthroughSubject<Player, Never>()
    private let overlayView: UIView = UIView()

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerColorPopUp: UIButton!
    
    @IBOutlet weak var test: UIButton!
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
    
    @IBAction func onAddPlayers(_ sender: Any) {
        guard let playerName = playerNameTextField.text else { return }
        let player = Player(name: playerName, color: .yellow)
        
        playerPublisher.send(player)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.removeFromSuperview()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    private func setupPlayerColorPopUp() {
        let optionClosure = { (action: UIAction) in
            print(action.identifier)
        }
        
        playerColorPopUp.menu = UIMenu(children: [
            UIAction(title: "Black", handler: optionClosure),
            UIAction(title: "Yellow", handler: optionClosure),
            UIAction(title: "Red", handler: optionClosure),
            UIAction(title: "Green", handler: optionClosure),
            UIAction(title: "Purple", handler: optionClosure),
            UIAction(title: "Orange", handler: optionClosure),
            UIAction(title: "Blue", handler: optionClosure),
            UIAction(title: "Brown", handler: optionClosure),
        ])
        
        playerColorPopUp.showsMenuAsPrimaryAction = true
    }
    
    private func setupPlayerNameTextField() {
        self.playerNameTextField.delegate = self
        self.playerNameTextField.layer.borderColor = UIColor.black.cgColor
        self.playerNameTextField.layer.cornerRadius = 6
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

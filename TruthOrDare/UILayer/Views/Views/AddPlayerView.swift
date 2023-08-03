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
        
        playerPublisher.send(self.player)
        
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

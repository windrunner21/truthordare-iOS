//
//  GameViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import UIKit
import Combine

class GameViewController: UIViewController {
    private var playerSubscriber: AnyCancellable?
    private let game = Game()
    
    @IBOutlet weak var numberOfPlayers: UILabel!
    
    private var playerNameView: UIView!
    private var playerNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
        
        self.setupPlayerNameLabel()
        self.setupPlayerNameView()
        self.playerNameView.isHidden = !self.game.hasPlayers()
        self.showPlayerNameLabel(hasPlayers: false)
        self.playerNameLabel.text = "Add players to start playing..."
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }    
    
    @IBAction func onAdd(_ sender: Any) {
        let addPlayerView: AddPlayerView = AddPlayerView(
            frame: CGRect(
                x: 30,
                y: UIScreen.main.bounds.height / 2 - 100,
                width: UIScreen.main.bounds.width - 60,
                height: 250
            )
        )
        
        self.view.addSubview(addPlayerView)
        addPlayerView.show()
        
        playerSubscriber = addPlayerView.playerPublisher.sink { [weak self] player in
            self?.handlePlayer(player)
        }
    }
    
    @IBAction func onDare(_ sender: Any) {
    }
    
    @IBAction func onTruth(_ sender: Any) {
    }
    
    private func setupPlayerNameView() {
        let width = self.view.frame.width - 120
        
        self.playerNameView = UIView()
        self.playerNameView.backgroundColor = .white
        
        self.playerNameView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerNameView)
        
        NSLayoutConstraint.activate([
            self.playerNameView.widthAnchor.constraint(equalToConstant: width),
            self.playerNameView.heightAnchor.constraint(equalTo: self.playerNameView.widthAnchor),
            self.playerNameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.playerNameView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.playerNameView.layer.cornerRadius = width / 2
        self.playerNameView.addElevation()
    }
    
    private func setupPlayerNameLabel() {
        self.playerNameLabel = UILabel()
        self.playerNameLabel.textColor = .black
        self.playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func showPlayerNameLabel(hasPlayers: Bool) {
        if hasPlayers {
            self.playerNameLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
            self.playerNameView.addSubview(self.playerNameLabel)
            
            NSLayoutConstraint.activate([
                self.playerNameLabel.centerXAnchor.constraint(equalTo: self.playerNameView.centerXAnchor),
                self.playerNameLabel.centerYAnchor.constraint(equalTo: self.playerNameView.centerYAnchor)
            ])
        } else {
            self.playerNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            self.view.addSubview(self.playerNameLabel)
            
            NSLayoutConstraint.activate([
                self.playerNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.playerNameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            ])
        }
    }

    private func removePlayerNameLabel(hasPlayers: Bool) {
        if hasPlayers {
            NSLayoutConstraint.deactivate([
                self.playerNameLabel.centerXAnchor.constraint(equalTo: self.playerNameView.centerXAnchor),
                self.playerNameLabel.centerYAnchor.constraint(equalTo: self.playerNameView.centerYAnchor)
            ])
        } else {
            NSLayoutConstraint.deactivate([
                self.playerNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.playerNameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            ])
        }
        
        self.playerNameLabel.removeFromSuperview()
    }
    
    private func handlePlayer(_ player: Player?) {
        guard let player = player else {
            print("Could not get player.")
            return
        }
        
        // Do it only once.
        if game.getNumberOfPlayers() == 0 {
            self.playerNameView.isHidden = self.game.hasPlayers()
            self.removePlayerNameLabel(hasPlayers: false)
            self.showPlayerNameLabel(hasPlayers: true)
        }
        
        self.game.addPlayer(player)
        
        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
        
        self.playerNameLabel.text = game.getPlayer()?.getName()
        self.playerNameView.backgroundColor = player.getColor()
    }
}

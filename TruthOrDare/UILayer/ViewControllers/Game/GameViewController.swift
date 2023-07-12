//
//  GameViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import UIKit
import Combine

// TODO: inspect if can refactor major funcs into seperate UI classes.
class GameViewController: UIViewController {
    // Combine related variable for listening to changes. Sub part.
    private var playerSubscriber: AnyCancellable?
    
    // Initialize game object.
    private let game = Game()
    
    // Adding and showing Players in the UI and Game class related variables.
    private var shouldAddPlayer: Bool = true
    private var currentRow: Int = 0
    private var currentColumn: Int = 0
    
    // Storyboard related UI elements.
    @IBOutlet weak var numberOfPlayers: UILabel!
    
    // Code initialized UI elements.
    private var playerNameView: UIView!
    private var playerNameLabel: UILabel!
    private var allPlayersView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
        
        self.setupPlayerNameLabel()
        self.setupPlayerNameView()
        self.setupAllPlayersView()
        
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
        self.playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupAllPlayersView() {
        self.allPlayersView = UIView()
        
        self.allPlayersView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(allPlayersView)
        
        NSLayoutConstraint.activate([
            self.allPlayersView.topAnchor.constraint(equalTo:  self.numberOfPlayers.bottomAnchor, constant: 10),
            self.allPlayersView.bottomAnchor.constraint(equalTo:  self.playerNameView.topAnchor, constant: -30),
            self.allPlayersView.leadingAnchor.constraint(equalTo:  self.view.centerXAnchor, constant: 30),
            self.allPlayersView.trailingAnchor.constraint(equalTo:  self.view.trailingAnchor, constant: -30)
        ])
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
    
    private func populateAllPlayersView() {
        let circleSize: CGFloat = 20
        let spacing: CGFloat = 10
        let maxWidth = self.allPlayersView.bounds.width - circleSize
        let maxHeight = self.allPlayersView.bounds.height - circleSize
        
        guard let player = self.game.getAllPlayers().last else { return }
    
        let playerView = UIView()
        playerView.frame.size = CGSize(width: circleSize, height: circleSize)
        playerView.layer.cornerRadius = circleSize / 2
        playerView.backgroundColor = player.getColor()
        
        let x = maxWidth - (circleSize + spacing) * CGFloat(currentColumn)
        let y = (circleSize + spacing) * CGFloat(currentRow)
        playerView.frame.origin = CGPoint(x: x, y: y)
        
        allPlayersView.addSubview(playerView)
        currentColumn += 1
        
        if CGFloat(currentColumn) > maxWidth / (circleSize + spacing) {
            currentColumn = 0
            currentRow += 1
        }
        
        if CGFloat(currentRow) > maxHeight / (circleSize + spacing) {
            self.shouldAddPlayer = false
        }
    }
    
    private func handlePlayer(_ player: Player?) {
        guard let player = player else {
            print("Could not get player.")
            return
        }
        
        guard shouldAddPlayer else {
            print("Cannot add new player. Max capacity.")
            return
        }

        // Do it only once.
        if game.getNumberOfPlayers() == 0 {
            self.playerNameView.isHidden = self.game.hasPlayers()
            self.removePlayerNameLabel(hasPlayers: false)
            self.showPlayerNameLabel(hasPlayers: true)
        }

   
        self.game.addPlayer(player)
        
        // TODO: REFACTOR INTO SEPARATE FUNCS
        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
        
        self.playerNameLabel.text = game.getPlayer()?.getName()
        self.playerNameView.backgroundColor = player.getColor()
        
        if player.getColor() == .black {
            self.playerNameLabel.textColor = .white
        } else {
            self.playerNameLabel.textColor = .black
        }
        
        self.populateAllPlayersView()
    }
}

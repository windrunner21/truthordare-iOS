//
//  GameViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import UIKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate, PlayerManagementDelegate {
    
    // Initialize game object with CoreData.
    private let game = Game(with: (UIApplication.shared.delegate as! AppDelegate).persistentContainer)
    
    // Adding and showing Players in the UI and Game class related variables.
    private var shouldAddPlayer: Bool = true
    private var currentRow: Int = 0
    private var currentColumn: Int = 0
    
    // Storyboard related UI elements.
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var totalPlayersButton: UIButton!
    @IBOutlet weak var numberOfPlayers: UILabel!
    @IBOutlet weak var dareButton: UIButton?
    @IBOutlet weak var truthButton: UIButton?
    
    // Code initialized UI elements.
    private var playerNameView: UIView!             // Player circle
    private var playerNameLabel: UILabel!           // Player label - name or empty
    private var contentLabel: UILabel!              // Truth or Dare question
    private var allPlayersView: UIView!             // Circles of all players
    private var roundTypeLabel: UILabel!            // Truth or dare
    private var roundNameLabel: UILabel!            // Player name
    
    // Constraints.
    private var playerNameViewWidthAnchorConstraint: NSLayoutConstraint!
    private var playerNameViewHeightAnchorConstraint: NSLayoutConstraint!
    private var playerNameViewCenterXAnchorConstraint: NSLayoutConstraint!
    
    private var playerNameViewXPosition: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial number of players, set to 0.
        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
        
        if !self.game.getSettings().isTruthGameModeEnabled {
            self.truthButton?.removeFromSuperview()
        }
        
        if !self.game.getSettings().isDareGameModeEnabled {
            self.dareButton?.removeFromSuperview()
        }
        
        // Setup label, circle and little player circles.
        self.setupPlayerNameLabel()
        self.setupContentLabel()
        self.setupPlayerNameView()
        self.setupAllPlayersView()
        self.setupRoundDetailsView()
        
        // Setup GestureRecognizers for player name view, circle.
        self.setupGestureRecognizersForPlayerNameView()
        
        // Configure setup moves.
        self.playerNameView.isHidden = !self.game.hasPlayers()
        self.showEmptyPlayerNameLabel()
        self.playerNameLabel.text = "Add players to start playing..."
        
        // Check if there are players in the game.
        self.shouldDisableActionButtons()
    }
    
    // Implement UIGestureRecognizerDelegate for it to recognize long press together with pan gestures.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTotalPlayers(_ sender: Any) {
        let playersStoryboard: UIStoryboard = UIStoryboard(name: "Players", bundle: .main)
        let playersViewController: PlayersViewController = playersStoryboard.instantiateViewController(identifier: "PlayersScreen")
        
        playersViewController.delegate = self
        playersViewController.players = self.game.getAllPlayers()
        playersViewController.currentPlayer = self.game.getCurrentPlayer()
        
        self.present(playersViewController, animated: true)
    }
    
    @IBAction func onAdd(_ sender: Any) {
        guard shouldAddPlayer else { return }
        
        let addPlayerView: AddPlayerView = AddPlayerView(
            frame: CGRect(
                x: 30,
                y: UIScreen.main.bounds.height / 2 - 125,
                width: UIScreen.main.bounds.width - 60,
                height: 250
            )
        )
        
        addPlayerView.delegate = self
        
        self.view.addSubview(addPlayerView)
        addPlayerView.show()
    }
    
    @IBAction func onDare(_ sender: Any) {
        if self.game.isRoundActive() {
            self.removeContentLabel()
            self.cleanupUpdatedScreen(with: .dare)
        } else {
            self.translatePlayerNameView(to: .dare)
        }
    }
    
    @IBAction func onTruth(_ sender: Any) {
        if self.game.isRoundActive() {
            self.removeContentLabel()
            self.cleanupUpdatedScreen(with: .truth)
        } else {
            self.translatePlayerNameView(to: .truth)
        }
    }
    
    func didAddPlayer(_ player: Player) {
        if game.getNumberOfPlayers() == 0 {
            self.playerNameView.isHidden = false
            self.removePlayerNameLabel()
            self.showPlayerNameLabel()
        }
   
        self.game.addPlayer(player)
        
        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
        self.setPlayerNameView(with: player)
        self.addToAllPlayersView(player)
        self.shouldDisableActionButtons()
    }
    
    func didRemovePlayer(_ player: Player) {
        if game.getNumberOfPlayers() == 1 {
            self.playerNameView.isHidden = self.game.hasPlayers()
            self.removePlayerNameLabel()
            self.showEmptyPlayerNameLabel()
            self.playerNameLabel.text = "Add players to start playing..."
        }
   
        self.game.removePlayer(player)
        
        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
        self.removeFromAllPlayersView(player)
        self.shouldDisableActionButtons()
        
        guard let currentPlayer = self.game.getCurrentPlayer() else { return }
        self.setPlayerNameView(with: currentPlayer)
    }
    
    private func setupPlayerNameView() {
        let width = self.view.frame.width - 140
        
        self.playerNameView = UIView()
        self.playerNameView.backgroundColor = .white
        
        self.playerNameView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerNameView)
        
        self.playerNameViewWidthAnchorConstraint = self.playerNameView.widthAnchor.constraint(equalToConstant: width)
        self.playerNameViewHeightAnchorConstraint = self.playerNameView.heightAnchor.constraint(equalTo: self.playerNameView.widthAnchor)
        self.playerNameViewCenterXAnchorConstraint = self.playerNameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        NSLayoutConstraint.activate([
            self.playerNameViewWidthAnchorConstraint,
            self.playerNameViewHeightAnchorConstraint,
            self.playerNameViewCenterXAnchorConstraint,
            self.playerNameView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.playerNameView.layer.cornerRadius = width / 2
        self.playerNameView.addElevation()
    }
    
    private func setupPlayerNameLabel() {
        self.playerNameLabel = UILabel()
        self.playerNameLabel.textColor = UIColor(named: "SoftBlack")
        self.playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.playerNameLabel.textAlignment = .center
        self.playerNameLabel.numberOfLines = .max
    }
    
    private func setupContentLabel() {
        self.contentLabel = UILabel()
        self.contentLabel.textColor = UIColor(named: "SoftBlack")
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func setupRoundDetailsView() {
        self.roundNameLabel = UILabel()
        self.roundTypeLabel = UILabel()
        
        self.roundNameLabel.textColor = UIColor(named: "SoftBlack")
        self.roundTypeLabel.textColor = UIColor(named: "SoftBlack")
        
        self.roundTypeLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        self.roundNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        self.roundNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.roundTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(roundNameLabel)
        self.view.addSubview(roundTypeLabel)
        
        NSLayoutConstraint.activate([
            self.roundNameLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 30),
            self.roundNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            self.roundNameLabel.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -30),
            self.roundTypeLabel.topAnchor.constraint(equalTo: self.roundNameLabel.bottomAnchor, constant: 5),
            self.roundTypeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            self.roundTypeLabel.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -30)
        ])
    }
    
    private func setupGestureRecognizersForPlayerNameView() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapPlayerNameView))
        tapGesture.minimumPressDuration = 0
        tapGesture.delegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipePlayerNameView))
        panGesture.delegate = self
        self.playerNameView.addGestureRecognizer(tapGesture)
        self.playerNameView.addGestureRecognizer(panGesture)
    }
    
    private func showPlayerNameLabel() {
        self.playerNameLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        
        self.playerNameView.addSubview(self.playerNameLabel)
        
        NSLayoutConstraint.activate([
            self.playerNameLabel.widthAnchor.constraint(equalToConstant: self.playerNameView.frame.width - 60),
            self.playerNameLabel.centerXAnchor.constraint(equalTo: self.playerNameView.centerXAnchor),
            self.playerNameLabel.centerYAnchor.constraint(equalTo: self.playerNameView.centerYAnchor),
        ])
    }
    
    private func showEmptyPlayerNameLabel() {
        self.playerNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        self.view.addSubview(self.playerNameLabel)
        
        NSLayoutConstraint.activate([
            self.playerNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.playerNameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.playerNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            self.playerNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
        ])
    }

    private func removePlayerNameLabel() {
        // Check whether label has width constraint and remove it as it won't be removed automatically.
        if let existingWidthConstraint = playerNameLabel.constraints.first(where: { $0.firstAttribute == .width }) {
            playerNameLabel.removeConstraint(existingWidthConstraint)
        }
        
        self.playerNameLabel.removeFromSuperview()
    }
    
    private func showContentLabel() {
        self.contentLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
               
        self.contentLabel.textAlignment = .center
        self.contentLabel.numberOfLines = .max
        
        self.view.addSubview(self.contentLabel)
        
        NSLayoutConstraint.activate([
            self.contentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.contentLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.contentLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
        ])
        
    }
    
    private func removeContentLabel() {
        NSLayoutConstraint.deactivate([
            self.contentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.contentLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.contentLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
        ])
        self.contentLabel.removeFromSuperview()
    }
    
    private func addToAllPlayersView(_ player: Player? = nil) {
        // Dimensions.
        let circleSize: CGFloat = 20
        let spacing: CGFloat = 10
        let maxWidth = self.allPlayersView.bounds.width - circleSize
        let maxHeight = self.allPlayersView.bounds.height - circleSize
        
        if let player = player {
            // Add only one, usually last, player.
            
            // Create small player circle view.
            let playerView = UIView()
            playerView.accessibilityIdentifier = String(player.id)
            playerView.frame.size = CGSize(width: circleSize, height: circleSize)
            playerView.layer.cornerRadius = circleSize / 2
            playerView.backgroundColor = player.getColor()
            playerView.layer.borderWidth = 1.5
            
            for view in self.allPlayersView.subviews {
                view.layer.borderColor = view.accessibilityIdentifier == String(player.id) ? UIColor(named: "SoftBlack")?.cgColor : UIColor(named: "SoftGray")?.cgColor
            }
            
            let x = maxWidth - (circleSize + spacing) * CGFloat(self.currentColumn)
            let y = (circleSize + spacing) * CGFloat(self.currentRow)
            playerView.frame.origin = CGPoint(x: x, y: y)
            
            allPlayersView.addSubview(playerView)
            self.currentColumn += 1
            
            if CGFloat(self.currentColumn) > maxWidth / (circleSize + spacing) {
                self.currentColumn = 0
                self.currentRow += 1
            }
            
            if CGFloat(self.currentRow) > maxHeight / (circleSize + spacing) {
                self.addPlayerButton.isEnabled = false
                self.shouldAddPlayer = false
            }
            
        } else {
            // Add all players one by one.
            
            self.game.getAllPlayers().forEach { player in
                // Create small player circle view.
                let playerView = UIView()
                playerView.accessibilityIdentifier = String(player.id)
                playerView.frame.size = CGSize(width: circleSize, height: circleSize)
                playerView.layer.cornerRadius = circleSize / 2
                playerView.backgroundColor = player.getColor()
                playerView.layer.borderWidth = 1.5

                playerView.layer.borderColor = player.id == self.game.getCurrentPlayer()?.id ? UIColor(named: "SoftBlack")?.cgColor : UIColor(named: "SoftGray")?.cgColor

                let x = maxWidth - (circleSize + spacing) * CGFloat(self.currentColumn)
                let y = (circleSize + spacing) * CGFloat(self.currentRow)
                playerView.frame.origin = CGPoint(x: x, y: y)
                
                allPlayersView.addSubview(playerView)
                self.currentColumn += 1
                
                if CGFloat(self.currentColumn) > maxWidth / (circleSize + spacing) {
                    self.currentColumn = 0
                    self.currentRow += 1
                }
                
                if CGFloat(self.currentRow) > maxHeight / (circleSize + spacing) {
                    self.addPlayerButton.isEnabled = false
                    self.shouldAddPlayer = false
                }
            }
        }
    }
    
    private func removeFromAllPlayersView(_ player: Player) {
        // NOTE: May need update in the future.
        // Clean whole view and rebuild again
        
        // Clean part.
        self.allPlayersView.subviews.forEach({$0.removeFromSuperview()})
        self.currentRow = 0
        self.currentColumn = 0
        
        // Rebuild part.
        self.addToAllPlayersView()
    }
    
    private func setPlayerNameView(with player: Player) {
        self.playerNameLabel.text = player.getName()
        self.playerNameView.backgroundColor = player.getColor()
    }
    
    private func shouldDisableActionButtons() {
        self.truthButton?.isEnabled = self.game.hasPlayers()
        self.dareButton?.isEnabled = self.game.hasPlayers()
        self.totalPlayersButton.isEnabled = self.game.hasPlayers()
    }
    
    private func translatePlayerNameView(to type: RoundType) {
        // Deactivate the centerXAnchor constraint temporarily to change its value.
        self.playerNameViewCenterXAnchorConstraint.isActive = false
        // Change constraints value.
        self.playerNameViewCenterXAnchorConstraint = self.playerNameView.centerXAnchor.constraint(equalTo: type == .truth ? self.view.trailingAnchor : self.view.leadingAnchor)
        // Activate the centerXAnchor constraint after changing its value.
        self.playerNameViewCenterXAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.4, animations: {
            // Call layoutIfNeeded to apply the updated position during animation.
            self.view.layoutIfNeeded()
        }) { _ in
            self.contentLabel.text = ". . ."
            self.game.activateContent(type: type) { text in
                DispatchQueue.main.async {
                    self.contentLabel.text = text
                }
            }
            
            self.updateScreen(with: type)
        }
    }
    
    // Objective-C (Selector) functions.
    @objc func swipePlayerNameView(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        switch gestureRecognizer.state {
        case .changed:
            let translation = gestureRecognizer.translation(in: view.superview)
            self.playerNameViewXPosition = view.center.x + translation.x
            
            view.center.x = playerNameViewXPosition
            gestureRecognizer.setTranslation(.zero, in: view.superview)
        case .ended:
            if playerNameViewXPosition > UIScreen.main.bounds.width - view.frame.width / 3 {
                if !self.game.getSettings().isTruthGameModeEnabled {
                    self.contentLabel.text = ". . ."
                    self.game.activateContent(type: .dare) { text in
                        DispatchQueue.main.async {
                            self.contentLabel.text = text
                        }
                    }
                    
                    self.updateScreen(with: .dare)
                } else {
                    self.contentLabel.text = ". . ."
                    self.game.activateContent(type: .truth) { text in
                        DispatchQueue.main.async {
                            self.contentLabel.text = text
                        }
                    }
                    
                    self.updateScreen(with: .truth)
                }
            } else if playerNameViewXPosition < 0 + view.frame.width / 3 {
                if !self.game.getSettings().isDareGameModeEnabled {
                    self.contentLabel.text = ". . ."
                    self.game.activateContent(type: .truth) { text in
                        DispatchQueue.main.async {
                            self.contentLabel.text = text
                        }
                    }
                    
                    self.updateScreen(with: .truth)
                } else {
                    self.contentLabel.text = ". . ."
                    self.game.activateContent(type: .dare) { text in
                        DispatchQueue.main.async {
                            self.contentLabel.text = text
                        }
                    }
                    
                    self.updateScreen(with: .dare)
                }
            }
        default:
            break
        }
    }
    
    @objc func tapPlayerNameView(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.playerNameViewWidthAnchorConstraint.constant += 20
            self.playerNameView.layer.cornerRadius = self.playerNameViewWidthAnchorConstraint.constant / 2
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
            }
        case .ended, .cancelled, .failed:
            self.playerNameViewWidthAnchorConstraint.constant -= 20
            self.playerNameView.layer.cornerRadius = self.playerNameViewWidthAnchorConstraint.constant / 2
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
    
    // Utilities. SSoT functions.
    private func cleanupUpdatedScreen(with type: RoundType) {
        self.addPlayerButton.isEnabled = true
        self.totalPlayersButton.isEnabled = true
        
        let mainButton = type == .truth ? self.truthButton : self.dareButton
        let hiddenButton = type == .truth ? self.dareButton : self.truthButton
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor(named: "BackgroundColor")
            self.playerNameView.addElevation()
            
            hiddenButton?.isHidden = false
            mainButton?.setTitle(type == .truth ? "Truth" : "Dare", for: .normal)
            
            self.playerNameView.isHidden = false
            self.cleanupRoundDetails()
        })
        
        self.game.finishRound()
        if let player = self.game.getCurrentPlayer() {
            self.setPlayerNameView(with: player)
            
            for playerView in self.allPlayersView.subviews {
                playerView.layer.borderColor = playerView.accessibilityIdentifier == String(player.id) ? UIColor(named: "SoftBlack")?.cgColor : UIColor(named: "SoftGray")?.cgColor
            }
        }
    }
    
    private func updateScreen(with type: RoundType) {
        // Reset player view center x constaint.
        self.playerNameViewCenterXAnchorConstraint.isActive = false
        self.playerNameViewCenterXAnchorConstraint = self.playerNameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        self.playerNameViewCenterXAnchorConstraint.isActive =  true
        
        // Follow up with direct visible changes.
        self.addPlayerButton.isEnabled = false
        self.totalPlayersButton.isEnabled = false
        
        let mainButton = type == .truth ? self.truthButton : self.dareButton
        let hideButton = type == .truth ? self.dareButton : self.truthButton
        
        UIView.animate(withDuration: 0.4, animations: {
            self.showContentLabel()
            self.playerNameView.removeElevation()
            self.view.backgroundColor = self.game.getCurrentPlayer()?.getColor()
            
            hideButton?.isHidden = true
            mainButton?.setTitle("Next", for: .normal)
            
            self.playerNameView.isHidden = true
            
            self.roundTypeLabel.text = type == .truth ? "Truth" : "Dare"
            self.roundNameLabel.text = self.game.getCurrentPlayer()?.getName()
        })
    }
    
    private func cleanupRoundDetails() {
        self.roundTypeLabel.text = String()
        self.roundNameLabel.text = String()
    }
}

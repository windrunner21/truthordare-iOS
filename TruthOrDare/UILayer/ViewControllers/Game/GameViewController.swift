//
//  GameViewController.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import UIKit
import Combine

// TODO: inspect if can refactor major funcs into seperate UI classes.
class GameViewController: UIViewController, UIGestureRecognizerDelegate {
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
    @IBOutlet weak var dareButton: UIButton!
    @IBOutlet weak var truthButton: UIButton!
    
    // Code initialized UI elements.
    private var playerNameView: UIView!             // Player circle
    private var playerNameLabel: UILabel!           // Player label - name or empty
    private var allPlayersView: UIView!             // Circles of all players
    private var backgroundColorView: UIView?        // Background color of the whole self.view
    
    // Constraints.
    var playerNameViewWidthAnchorConstraint: NSLayoutConstraint!
    var playerNameViewHeightAnchorConstraint: NSLayoutConstraint!
    
    var newX: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial number of players, set to 0.
        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
        
        // Setup label, circle and little player circles.
        self.setupPlayerNameLabel()
        self.setupPlayerNameView()
        self.setupAllPlayersView()
        
        // Setup GestureRecognizers for player name view, circle.
        self.setupGestureRecognizersForPlayerNameView()
        
        // Configure setup moves.
        self.playerNameView.isHidden = !self.game.hasPlayers()
        self.showPlayerNameLabel(hasPlayers: false)
        self.playerNameLabel.text = "Add players to start playing..."
        
        self.shouldDisableActionButtons()
    }
    
    // Implement UIGestureRecognizerDelegate for it to recognize long press together with pan gestures.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
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
        self.playerNameLabel.text = self.game.activateDare()
    }
    
    @IBAction func onTruth(_ sender: Any) {
        self.playerNameLabel.text = self.game.activateTruth()
    }
    
    private func setupPlayerNameView() {
        let width = self.view.frame.width - 140
        
        self.playerNameView = UIView()
        self.playerNameView.backgroundColor = .white
        
        self.playerNameView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerNameView)
        
        self.playerNameViewWidthAnchorConstraint = self.playerNameView.widthAnchor.constraint(equalToConstant: width)
        self.playerNameViewHeightAnchorConstraint = self.playerNameView.heightAnchor.constraint(equalTo: self.playerNameView.widthAnchor)
        
        NSLayoutConstraint.activate([
            self.playerNameViewWidthAnchorConstraint,
            self.playerNameViewHeightAnchorConstraint,
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
    
    private func setupGestureRecognizersForPlayerNameView() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapPlayerNameView))
        tapGesture.minimumPressDuration = 0
        tapGesture.delegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipePlayerNameView))
        panGesture.delegate = self
        self.playerNameView.addGestureRecognizer(tapGesture)
        self.playerNameView.addGestureRecognizer(panGesture)
    }
    
    private func showPlayerNameLabel(hasPlayers: Bool) {
        self.playerNameLabel.font = hasPlayers ? UIFont.systemFont(ofSize: 30, weight: .heavy) : UIFont.systemFont(ofSize: 14, weight: .regular)
        self.view.addSubview(self.playerNameLabel)
        
        NSLayoutConstraint.activate([
            self.playerNameLabel.centerXAnchor.constraint(equalTo: hasPlayers ? self.playerNameView.centerXAnchor : self.view.centerXAnchor),
            self.playerNameLabel.centerYAnchor.constraint(equalTo: hasPlayers ? self.playerNameView.centerYAnchor : self.view.centerYAnchor)
        ])
    }

    private func removePlayerNameLabel(hasPlayers: Bool) {
        NSLayoutConstraint.deactivate([
            self.playerNameLabel.centerXAnchor.constraint(equalTo: hasPlayers ? self.playerNameView.centerXAnchor : self.view.centerXAnchor),
            self.playerNameLabel.centerYAnchor.constraint(equalTo: hasPlayers ? self.playerNameView.centerYAnchor : self.view.centerYAnchor)
        ])
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
        
        self.numberOfPlayers.text = "\(self.game.getNumberOfPlayers()) players"
        self.setPlayerNameView(with: player)
        self.populateAllPlayersView()
        self.shouldDisableActionButtons()

    }
    
    private func setPlayerNameView(with player: Player) {
        self.playerNameLabel.text = player.getName()
        self.playerNameView.backgroundColor = player.getColor()
        self.playerNameLabel.textColor = player.getColor() == .black ? .white : .black
    }
    
    private func shouldDisableActionButtons() {
        self.truthButton.isEnabled = self.game.hasPlayers()
        self.dareButton.isEnabled = self.game.hasPlayers()
    }
    
    // Objective-C (Selector) functions.
    @objc func swipePlayerNameView(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        switch gestureRecognizer.state {
        case .changed:
            let translation = gestureRecognizer.translation(in: view.superview)
            newX = view.center.x + translation.x
            view.center.x = newX
            gestureRecognizer.setTranslation(.zero, in: view.superview)
        case .ended:
            if newX > UIScreen.main.bounds.width - view.frame.width / 3 {
                print("truth")
                self.playerNameLabel.text = self.game.activateTruth()
            } else if newX < 0 + view.frame.width / 3 {
                print("dare")
                self.playerNameLabel.text = self.game.activateDare()
            }
   
//            print(translation.x)
//            if translation.x > 0 {
//                self.playerNameLabel.text = self.game.activateTruth()
//                // Swiped to the right
//                UIView.animate(withDuration: 0.2) {
//                    self.playerNameView.frame.origin.x = UIScreen.main.bounds.width
//                }
//            } else if translation.x < 0 {
//                self.playerNameLabel.text = self.game.activateDare()
//                // Swiped to the left
//                UIView.animate(withDuration: 0.2) {
//                    self.playerNameView.frame.origin.x = -self.playerNameView.frame.width
//                }
//            }
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
}

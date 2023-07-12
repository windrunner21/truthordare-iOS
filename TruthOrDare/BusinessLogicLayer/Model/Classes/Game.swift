//
//  Game.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import Foundation

class Game {
    private var players: [Player]
    
    init() {
        self.players = []
    }
    
    func getNumberOfPlayers() -> Int {
        self.players.count
    }
    
    func addPlayer(_ player: Player) {
        self.players.append(player)
    }
    
    func getPlayer() -> Player? {
        self.players.randomElement()
    }
    
    func hasPlayers() -> Bool {
        !self.players.isEmpty
    }
}

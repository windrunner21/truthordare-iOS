//
//  Game.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import Foundation

class Game {
    private var currentPlayer: Player?
    private var players: [Player]
    
    private var truthPool: [String]
    private var darePool: [String]
    private var currentOption: String?
    
    init() {
        self.players = []
        self.truthPool = ["Merhaba Usame abi nasilsiniz?", "nurlan geldi mi", "sonuç?"]
        self.darePool = ["bişeyler yapsın raşit", "bunu ekrem için açtım", "sen dikkate alma"]
    }
    
    func getNumberOfPlayers() -> Int {
        self.players.count
    }
    
    func addPlayer(_ player: Player) {
        self.players.append(player)
        self.currentPlayer = player
    }
    
    func getPlayer() -> Player? {
        self.players.randomElement()
    }
    
    func getAllPlayers() -> [Player] {
        self.players
    }
    
    func hasPlayers() -> Bool {
        !self.players.isEmpty
    }
    
    func activateTruth() -> String {
        guard let currentPlayer = currentPlayer else { return String() }
        self.currentOption = self.truthPool.randomElement()
        
        return self.currentOption!
    }
    
    func activateDare() -> String {
        guard let currentPlayer = currentPlayer else { return String() }
        self.currentOption = self.darePool.randomElement()
        
        return self.currentOption!
    }
}

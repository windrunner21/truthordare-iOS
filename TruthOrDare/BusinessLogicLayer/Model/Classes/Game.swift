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
    
    private var isActiveRound: Bool
    
    init() {
        self.players = []
        self.isActiveRound = false
        
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
    
    func getCurrentPlayer() -> Player? {
        self.currentPlayer
    }
    
    func getAllPlayers() -> [Player] {
        self.players
    }
    
    func hasPlayers() -> Bool {
        !self.players.isEmpty
    }
    
    func isRoundActive() -> Bool {
        self.isActiveRound
    }
    
    func finishRound() {
        self.isActiveRound = false
        self.currentPlayer = players.randomElement()
    }
    
    func activateTruth() -> String {
        guard currentPlayer != nil else { return String() }
        self.currentOption = self.truthPool.randomElement()
        self.isActiveRound = true
        
        return self.currentOption!
    }
    
    func activateDare() -> String {
        guard currentPlayer != nil else { return String() }
        self.currentOption = self.darePool.randomElement()
        self.isActiveRound = true
        
        return self.currentOption!
    }
}

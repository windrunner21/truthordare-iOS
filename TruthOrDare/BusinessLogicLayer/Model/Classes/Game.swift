//
//  Game.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import CoreData
import Foundation

class Game {
    private var settings: Settings
    
    private var currentPlayer: Player?
    private var players: [Player]
    
    private var truthPool: [String]
    private var darePool: [String]
    private var customPool: CustomPool
    
    private var currentOption: String?
    
    private var isActiveRound: Bool
    
    init(managedObjectContext: NSManagedObjectContext) {
        // Try to retrieve settings first.
        if let encodedSettings = UserDefaults.standard.value(forKey: "settings"),
           let encodedSettings = encodedSettings as? Data,
           let decodedSettings = try? NSKeyedUnarchiver.unarchivedObject(ofClass: Settings.self, from: encodedSettings) {
            self.settings = decodedSettings
        } else {
            self.settings = Settings()
        }
       
        self.players = []
        self.isActiveRound = false

        // Initialize custom pool if it has been enabled in the settings.
        self.customPool = CustomPool(
            isTruthPoolEnabled: self.settings.isCustomTruthEnabled,
            isDarePoolEnabled: self.settings.isCustomDareEnabled,
            manager: DataManager(managedObjectContext: managedObjectContext)
        )
        
        // Will add empty pools if not initialized in self class. If no content selected use static no content.
        self.truthPool = self.settings.isNoContentEnabled ? ["Your own Truth"] : ["Truth #1", "Truth #2", "Truth #3"] + self.customPool.getTruthPool()
        self.darePool = self.settings.isNoContentEnabled ? ["Your own Dare"] : ["Dare #1", "Dare #2", "Dare #3"] + self.customPool.getTruthPool()
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
        
        if settings.isRandomizePlayerEnabled {
            self.currentPlayer = players.randomElement()
        } else {
            guard let index = self.players.firstIndex(where: { $0.id == self.currentPlayer?.id}) else { return }
            if index == self.getNumberOfPlayers() - 1 {
                self.currentPlayer = players[0]
            } else {
                self.currentPlayer = players[index + 1]
            }
        }

    }
    
    func activateContent(type: RoundType) -> String {
        let pool: [String] = type == .truth ? truthPool : darePool
        
        guard currentPlayer != nil else { return String() }
        self.currentOption = pool.randomElement()
        self.isActiveRound = true
        
        return self.currentOption!
    }

    
    func getSettings() -> Settings {
        self.settings
    }
}

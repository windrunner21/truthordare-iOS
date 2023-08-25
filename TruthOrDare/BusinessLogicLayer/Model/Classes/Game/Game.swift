//
//  Game.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import CoreData
import Foundation

class Game {
    private let gptService: GPTService = GPTService()
    
    private var settings: Settings
    
    private var currentPlayer: Player?
    private var players: [Player]
    
    private var truthPool: [String]
    private var darePool: [String]
    private var customPool: CustomPool
    
    private var currentOption: String?
    
    private var isActiveRound: Bool
        
    init(with persistentContainer: PersistentContainer) {
        // Try to retrieve settings first.
        if let encodedSettings = UserDefaults.standard.value(forKey: "settings"),
           let encodedSettings = encodedSettings as? Data,
           let decodedSettings = try? NSKeyedUnarchiver.unarchivedObject(ofClass: Settings.self, from: encodedSettings) {
            self.settings = decodedSettings
            
            print(settings)
        } else {
            self.settings = Settings()
        }
        
        self.players = []
        self.isActiveRound = false

        // Initialize custom pool if it has been enabled in the settings.
        self.customPool = CustomPool(
            isTruthPoolEnabled: self.settings.isCustomTruthEnabled,
            isDarePoolEnabled: self.settings.isCustomDareEnabled,
            persistentContainer: persistentContainer
        )
        
        // Will add empty pools if not initialized in self class. If no content selected use static no content.
        let defaultContent = DefaultContent()
        
        self.truthPool = self.settings.isNoContentEnabled ? ["Your Truth"] : defaultContent.truthPool + self.customPool.getTruthPool()
        self.darePool = self.settings.isNoContentEnabled ? ["Your Dare"] : defaultContent.darePool + self.customPool.getDarePool()
        
        // Check if subscription has expired.
        Task {
            await TransactionManager.shared.refreshPurchasedProducts()
            
            // Try to retrieve settings first.
            if let encodedSettings = UserDefaults.standard.value(forKey: "settings"),
               let encodedSettings = encodedSettings as? Data,
               let decodedSettings = try? NSKeyedUnarchiver.unarchivedObject(ofClass: Settings.self, from: encodedSettings) {
                self.settings = decodedSettings
                
                print(settings)
            } else {
                self.settings = Settings()
            }
        }
    }
    
    func getNumberOfPlayers() -> Int {
        self.players.count
    }
    
    func addPlayer(_ player: Player) {
        self.players.append(player)
        self.currentPlayer = player
    }
    
    func removePlayer(_ player: Player) {
        guard let indexToRemove = self.players.firstIndex(where: { $0.id == player.id }) else { return }
        self.players.remove(at: indexToRemove)
                
        if !self.players.isEmpty && self.currentPlayer?.id == player.id {
            if self.settings.isRandomizePlayerEnabled {
                self.currentPlayer = self.players.first(where: {$0.skippedCount >= 4}) ?? self.players.randomElement()
            } else {
                self.currentPlayer = players[indexToRemove == self.getNumberOfPlayers() ? 0 : indexToRemove]
            }
        }
        
        if self.players.isEmpty {
            self.currentPlayer = nil
        }
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
            if self.getNumberOfPlayers() == 1 {
                self.currentPlayer = self.players[0]
            } else {
                self.currentPlayer = self.players.first(where: {$0.skippedCount >= 4}) ?? self.players.filter({$0.id != currentPlayer?.id}).randomElement()
                
                self.currentPlayer?.skippedCount = 0
                for player in self.players where player.id != currentPlayer?.id { player.skippedCount += 1 }
            }
        } else {
            guard let index = self.players.firstIndex(where: { $0.id == self.currentPlayer?.id}) else { return }
            if index == self.getNumberOfPlayers() - 1 {
                self.currentPlayer = players[0]
            } else {
                self.currentPlayer = players[index + 1]
            }
        }
    }
    
    func activateContent(type: RoundType, completion: @escaping (String) -> Void) {
        guard currentPlayer != nil else {
            completion(String())
            return
        }
        
        self.isActiveRound = true
        
        if self.settings.isChatGPTTruthEnabled && type == .truth {
            self.gptService.retrieveTruth() {
                response, data in
                
                switch response {
                case .success:
                    self.currentOption = data
                    completion(self.currentOption!)
                case .error:
                    self.currentOption = "Sorry for the inconvenience. Error occured. Please try again."
                    completion(self.currentOption!)
                }
            }
            
            return
        }
        
        if self.settings.isChatGPTDareEnabled && type == .dare {            
            self.gptService.retrieveDare() {
                response, data in
                
                switch response {
                case .success:
                    self.currentOption = data
                    completion(self.currentOption!)
                case .error:
                    self.currentOption = "Sorry for the inconvenience. Error occured. Please try again."
                    completion(self.currentOption!)
                }
            }
            
            return
        }
        
        let pool: [String] = type == .truth ? truthPool : darePool
        self.currentOption = pool.filter({$0 != self.currentOption}).randomElement()
        
        completion(self.currentOption!)
    }

    
    func getSettings() -> Settings {
        self.settings
    }
}

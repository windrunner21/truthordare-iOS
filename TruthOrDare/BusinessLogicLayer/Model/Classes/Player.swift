//
//  Player.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import Foundation
import UIKit

class Player {
    private var name: String
    private var color: UIColor
    
    convenience init() {
        self.init(name: Player.generateRandomPlayerName(), color: .black)
    }
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
    
    func update(with player: Player) {
        self.name = player.name
        self.color = player.color
    }
    
    func setName(to name: String) {
        self.name = name
    }
    
    func setColor(to color: UIColor) {
        self.color = color
    }
    
    func getName() -> String {
        self.name
    }
    
    func getColor() -> UIColor {
        self.color
    }
    
    private static func generateRandomPlayerName() -> String {
        let adjectives = ["Swift", "Brave", "Fierce", "Mighty", "Sneaky", "Wild", "Hungry", "Little", "Horny"]
        let nouns = ["Warrior", "Hero", "Champion", "Ninja", "Wizard", "Knight", "Rapper", "Lion", "Robot"]
        
        let randomAdjectiveIndex = Int.random(in: 0..<adjectives.count)
        let randomNounIndex = Int.random(in: 0..<nouns.count)
        
        let adjective = adjectives[randomAdjectiveIndex]
        let noun = nouns[randomNounIndex]
        
        return "\(adjective) \(noun)"
    }
}

//
//  PlayerColor.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 12.07.23.
//

import UIKit

enum PlayerColor: CaseIterable {
    case blue
    case pink
    case yellow
    case red
    case green
    case purple
    case orange
    case brown
}

extension PlayerColor {
    var label: String {
        switch self {
        case .blue:
            return "Blue"
        case .pink:
            return "Pink"
        case .yellow:
            return "Yellow"
        case .red:
            return "Red"
        case .green:
            return "Green"
        case .purple:
            return "Purple"
        case .orange:
            return "Orange"
        case .brown:
            return "Brown"
        }
    }
    
    var color: UIColor {
        switch self {
        case .blue:
            return UIColor(named: "BlueCircle") ?? .systemBlue
        case .pink:
            return UIColor(named: "PinkCircle") ?? .systemPink
        case .yellow:
            return UIColor(named: "YellowCircle") ?? .systemYellow
        case .red:
            return UIColor(named: "RedCircle") ?? .systemRed
        case .green:
            return UIColor(named: "GreenCircle") ?? .systemGreen
        case .purple:
            return UIColor(named: "PurpleCircle") ?? .systemPurple
        case .orange:
            return UIColor(named: "OrangeCircle") ?? .systemOrange
        case .brown:
            return UIColor(named: "BrownCircle") ?? .systemBrown
        }
    }
}

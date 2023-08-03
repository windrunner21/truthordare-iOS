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
            return UIColor.systemBlue
        case .pink:
            return UIColor.systemPink
        case .yellow:
            return UIColor.systemYellow
        case .red:
            return UIColor.systemRed
        case .green:
            return UIColor.systemGreen
        case .purple:
            return UIColor.systemPurple
        case .orange:
            return UIColor.systemOrange
        case .brown:
            return UIColor.systemBrown
        }
    }
}

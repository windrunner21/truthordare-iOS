//
//  PlayerColor.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 12.07.23.
//

import UIKit

enum PlayerColor: CaseIterable {
    case gray
    case yellow
    case red
    case green
    case purple
    case orange
    case blue
    case brown
}

extension PlayerColor {
    var label: String {
        switch self {
        case .gray:
            return "Gray"
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
        case .blue:
            return "Blue"
        case .brown:
            return "Brown"
        }
    }
    
    var color: UIColor {
        switch self {
        case .gray:
            return UIColor.gray
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
        case .blue:
            return UIColor.systemBlue
        case .brown:
            return UIColor.systemBrown
        }
    }
}

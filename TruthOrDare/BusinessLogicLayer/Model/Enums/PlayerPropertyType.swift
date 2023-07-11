//
//  PlayerPropertyType.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 11.07.23.
//

import Foundation

enum PlayerPropertyType {
    case name
    case color
}

extension PlayerPropertyType {
    var label: String {
        switch self {
        case .name:
            return "Name"
        case .color:
            return "Color"
        }
    }
}

//
//  RoundType.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 14.07.23.
//

enum RoundType {
    case truth
    case dare
}

extension RoundType {
    var value: String {
        switch self {
        case .truth:
            return "truth"
        case .dare:
             return "dare"
        }
    }
}

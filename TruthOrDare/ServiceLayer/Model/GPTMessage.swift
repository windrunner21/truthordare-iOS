//
//  GPTMessage.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 23.08.23.
//

import Foundation

class GPTMessage: Codable {
    var role: String
    var content: String
    
    init(role: String, content: String) {
        self.role = role
        self.content = content
    }
    
    init() {
        self.role = String()
        self.content = String()
    }
}

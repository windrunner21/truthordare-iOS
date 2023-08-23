//
//  GPTChoice.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 23.08.23.
//

import Foundation

class GPTChoice: Decodable {
    var index: Int
    var message: GPTMessage
    var finish_reason: String
    
    init() {
        self.index = -1
        self.message = GPTMessage()
        self.finish_reason = String()
    }
}

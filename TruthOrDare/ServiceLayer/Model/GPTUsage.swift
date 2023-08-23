//
//  GPTUsage.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 23.08.23.
//

import Foundation

class GPTUsage: Decodable {
    var prompt_tokens: Int
    var completion_tokens: Int
    var total_tokens: Int
    
    init() {
        self.prompt_tokens = -1
        self.completion_tokens = -1
        self.total_tokens = -1
    }
}

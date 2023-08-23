//
//  GPTCompletion.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 23.08.23.
//

import Foundation

class CreateGPTCompletion: Encodable {
    var model: String
    var messages: [GPTMessage]
    var temperature: Double?
    var n: Int?
    
    init(model: String, messages: [GPTMessage], temperature: Double? = nil, n: Int? = nil) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
        self.n = n
    }
    
    func encode() -> Data? {
        let encoder = JSONEncoder()
        
        do {
            let encodedData = try encoder.encode(self)
            return encodedData
        } catch {
            print("Could not encode object. Error: \(error)")
        }
        
        return nil
    }
}

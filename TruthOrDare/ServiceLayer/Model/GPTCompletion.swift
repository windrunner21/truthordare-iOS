//
//  GPTCompletion.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 23.08.23.
//

import Foundation

class GPTCompletion: Decodable, CustomStringConvertible {
    var id: String
    var object: String
    var created: Int
    var model: String
    var choices: [GPTChoice]
    var usage: GPTUsage
    
    var description: String {
        "Completion object with \(id) id.\nObject is \(object).\nCreated at: \(created).\nModel: \(model).Response: \(choices.first?.message.content ?? "empty choices array").\nFinish reason: \(choices.first?.finish_reason ?? "empty choices array").\nUsed total tokens: \(usage.total_tokens)"
    }
    
    init(data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(GPTCompletion.self, from: data)
            
            self.id = decodedData.id
            self.object = decodedData.object
            self.created = decodedData.created
            self.model = decodedData.model
            self.choices = decodedData.choices
            self.usage = decodedData.usage
            
        } catch {
            print("Could not decode object. Error: \(error)")
            
            self.id = String()
            self.object = String()
            self.created = -1
            self.model = String()
            self.choices = []
            self.usage = GPTUsage()
        }
    }
}

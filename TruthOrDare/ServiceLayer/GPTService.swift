//
//  GPTService.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 23.08.23.
//

import Foundation

class GPTService {
    private let client = APIClient(baseURL: "https://api.openai.com/v1")
    private let path = "/chat/completions"
    private let gptModel = "gpt-3.5-turbo"
    
    func retrieveTruth(completion: @escaping (Response, String?) -> Void) {
        let gptMessage = GPTMessage(role: "system", content: "give me 1 interesting truth question. do not repeat yourself.")
        let createGptCompletion = CreateGPTCompletion(model: gptModel, messages: [gptMessage])
        
        self.client.sendRequest(path: self.path, method: .POST, body: createGptCompletion.encode()) {
            data, response, error in
            
            if let error = error {
                print("Error occured at retrieveTruth(): \(error)")
                completion(.error, nil)
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                let gptCompletion = GPTCompletion(data: data)
                completion(.success, gptCompletion.choices.first?.message.content)
            } else {
                print("Incorrect request at retrieveTruth().")
                completion(.error, nil)
            }
        }
    }
    
    func retrieveDare(completion: @escaping (Response, String?) -> Void) {
        let gptMessage = GPTMessage(role: "system", content: "give me 1 spicy or creative dare. do not repeat yourself.")
        let createGptCompletion = CreateGPTCompletion(model: gptModel, messages: [gptMessage])
        
        self.client.sendRequest(path: self.path, method: .POST, body: createGptCompletion.encode()) {
            data, response, error in
            
            if let error = error {
                print("Error occured at retreiveDare(): \(error)")
                completion(.error, nil)
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                let gptCompletion = GPTCompletion(data: data)
                completion(.success, gptCompletion.choices.first?.message.content)
            } else {
                print("Incorrect request at retrieveDare().")
                completion(.error, nil)
            }
        }
    }
}

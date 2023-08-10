//
//  CustomPool.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 04.08.23.
//

import Foundation

class CustomPool {
    private var persistentContainer: PersistentContainer
    private var truthPool: [CustomContent]?
    private var darePool: [CustomContent]?
    
    init(isTruthPoolEnabled: Bool, isDarePoolEnabled: Bool, persistentContainer: PersistentContainer) {
        self.persistentContainer = persistentContainer
        
        if isTruthPoolEnabled && isDarePoolEnabled {
            self.truthPool = persistentContainer.fetch(of: CustomContent.self, with: NSPredicate(format: "type == %@", "truth"))
            self.darePool = persistentContainer.fetch(of: CustomContent.self, with: NSPredicate(format: "type == %@", "dare"))
        } else if isTruthPoolEnabled {
            self.truthPool = persistentContainer.fetch(of: CustomContent.self, with: NSPredicate(format: "type == %@", "truth"))
        } else if isDarePoolEnabled {
            self.darePool = persistentContainer.fetch(of: CustomContent.self, with: NSPredicate(format: "type == %@", "dare"))
        }
    }
    
    func getTruthPool() -> [String] {
        truthPool?.compactMap { $0.data } ?? []
    }
    
    func getDarePool() -> [String] {
        darePool?.compactMap { $0.data } ?? []
    }
}

//
//  CustomPool.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 04.08.23.
//

class CustomPool {
    private var truthPool: [String]?
    private var darePool: [String]?
    
    init(isTruthPoolEnabled: Bool, isDarePoolEnabled: Bool) {
        if isTruthPoolEnabled && isDarePoolEnabled {
            self.truthPool = []
            self.darePool = []
        } else if isTruthPoolEnabled {
            self.truthPool = []
        } else if isDarePoolEnabled {
            self.darePool = []
        } else {
            self.truthPool = nil
            self.darePool = nil
        }
    }
    
    func getTruthPool() -> [String] {
        self.truthPool ?? []
    }
    
    func getDarePool() -> [String] {
        self.darePool ?? []
    }
    
    func setPool(to pool: [String], of type: RoundType) {
        if type == .truth {
            self.truthPool = pool
        } else {
            self.darePool = pool
        }
    }
    
    func addToPool(of type: RoundType, _ content: String) {
        if type == .truth {
            self.truthPool?.append(content)
        } else {
            self.darePool?.append(content)
        }
    }
}

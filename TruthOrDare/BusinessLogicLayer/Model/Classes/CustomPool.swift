//
//  CustomPool.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 04.08.23.
//

class CustomPool {
    private var manager: DataManager
    private var truthPool: [String]?
    private var darePool: [String]?
    
    init(isTruthPoolEnabled: Bool, isDarePoolEnabled: Bool, manager: DataManager) {
        self.manager = manager
        
        if isTruthPoolEnabled && isDarePoolEnabled {
            
            if let fetchedData = manager.fetchData(of: CustomContent.self) {
               for entity in fetchedData {
                   print(entity.type!)
                   print(entity.data!)
                   print(entity.created!)
                   self.truthPool?.append(entity.data!)
                   self.darePool?.append(entity.data!)
               }
           }
          
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

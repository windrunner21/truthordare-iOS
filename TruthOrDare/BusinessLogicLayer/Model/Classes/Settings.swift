//
//  Settings.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 01.08.23.
//

import Foundation

class Settings: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        true
    }
    
    override var description: String {
        """
        isTruthGameModeEnabled: \(isTruthGameModeEnabled)
        isDareGameModeEnabled: \(isDareGameModeEnabled)
        isRandomizePlayerEnabled: \(isRandomizePlayerEnabled)
        isChatGPTTruthEnabled: \(isChatGPTTruthEnabled)
        isChatGPTDareEnabled: \(isChatGPTDareEnabled)
        isCustomTruthEnabled: \(isCustomTruthEnabled)
        isCustomDareEnabled: \(isCustomDareEnabled)
        isNoContentEnabled: \(isNoContentEnabled)
        """
    }
    
    // Properties.
    var isTruthGameModeEnabled: Bool
    var isDareGameModeEnabled: Bool
    var isRandomizePlayerEnabled: Bool
    var isChatGPTTruthEnabled: Bool
    var isChatGPTDareEnabled: Bool
    var isCustomTruthEnabled: Bool
    var isCustomDareEnabled: Bool
    var isNoContentEnabled: Bool
    
    // Coding keys.
    let truthGameModeKey: String = "isTruthGameModeEnabled"
    let dareGameModeKey: String = "isDareGameModeEnabled"
    let randomizePlayerKey: String = "isRandomizePlayerEnabled"
    let chatGPTTruthKey: String = "isChatGPTTruthEnabled"
    let chatGPTDareKey: String = "isChatGPTDareEnabled"
    let customTruthKey: String = "isCustomTruthEnabled"
    let customDareKey: String = "isCustomDareEnabled"
    let noContentKey: String = "isNoContentEnabled"
    
    override init() {
        self.isTruthGameModeEnabled = true
        self.isDareGameModeEnabled = true
        self.isRandomizePlayerEnabled = true
        
        self.isChatGPTTruthEnabled = false
        self.isChatGPTDareEnabled = false
        
        self.isCustomTruthEnabled = false
        self.isCustomDareEnabled = false
        
        self.isNoContentEnabled = false
    }
    
    // Encode the object's properties to NSData.
    func encode(with coder: NSCoder) {
        coder.encode(isTruthGameModeEnabled, forKey: truthGameModeKey)
        coder.encode(isDareGameModeEnabled, forKey: dareGameModeKey)
        coder.encode(isRandomizePlayerEnabled, forKey: randomizePlayerKey)
        coder.encode(isChatGPTTruthEnabled, forKey: chatGPTTruthKey)
        coder.encode(isChatGPTDareEnabled, forKey: chatGPTDareKey)
        coder.encode(isCustomTruthEnabled, forKey: customTruthKey)
        coder.encode(isCustomDareEnabled, forKey: customDareKey)
        coder.encode(isNoContentEnabled, forKey: noContentKey)
    }

    // Initialize the object with decoder.
    required init?(coder: NSCoder) {
        isTruthGameModeEnabled = coder.decodeBool(forKey: truthGameModeKey)
        isDareGameModeEnabled = coder.decodeBool(forKey: dareGameModeKey)
        isRandomizePlayerEnabled = coder.decodeBool(forKey: randomizePlayerKey)
        isChatGPTTruthEnabled = coder.decodeBool(forKey: chatGPTTruthKey)
        isChatGPTDareEnabled = coder.decodeBool(forKey: chatGPTDareKey)
        isCustomTruthEnabled = coder.decodeBool(forKey: customTruthKey)
        isCustomDareEnabled = coder.decodeBool(forKey: customDareKey)
        isNoContentEnabled = coder.decodeBool(forKey: noContentKey)

        super.init()
    }
    
    static func updateSettings(using settings: Settings) {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: settings, requiringSecureCoding: true)
            UserDefaults.standard.set(encodedData, forKey: "settings")
            print("Settings updated successfully.")
        } catch {
            print(error)
            NSLog("Cannot update settings. Archiving data failed. Deleting settings.")
            UserDefaults.standard.removeObject(forKey: "settings")
        }
    }
    
    static func retrieveSettings() -> Settings? {
        if let settings = UserDefaults.standard.value(forKey: "settings") {
            do {
                guard let settings = settings as? Data else { return nil }
                let decodedData = try NSKeyedUnarchiver.unarchivedObject(ofClass: Settings.self, from: settings)
                
                return decodedData
            } catch {
                print("Error decoding Settings object \(error)")
            }
        }
        
        return nil
    }
}

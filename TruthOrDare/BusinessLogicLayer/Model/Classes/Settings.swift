//
//  Settings.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 01.08.23.
//

class Settings {
    var mode: GameMode
    var randomizePlayer: Bool
    var chatGPTType: ChatGPTType
    var contentType: ContentType
    
    init() {
        self.mode = .all
        self.randomizePlayer = true
        self.chatGPTType = .all
        self.contentType = .noneCustom
    }
}

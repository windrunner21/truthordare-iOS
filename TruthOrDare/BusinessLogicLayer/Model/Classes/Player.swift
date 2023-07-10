//
//  Player.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import Foundation
import UIKit

class Player {
    var name: String
    var color: UIColor = .black
    
    init(name: String) {
        self.name = name
        self.color = self.generateRandomColor()
    }
    
    private func generateRandomColor() -> UIColor {
      let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
      let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
      let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
            
      return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

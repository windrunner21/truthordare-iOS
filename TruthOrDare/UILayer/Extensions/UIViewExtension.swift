//
//  UIViewExtension.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import Foundation
import UIKit

extension UIView {    
    func addElevation() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }
    
    func removeElevation() {
        self.layer.shadowColor = .none
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 0
    }
}

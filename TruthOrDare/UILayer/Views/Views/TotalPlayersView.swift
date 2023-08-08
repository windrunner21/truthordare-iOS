//
//  TotalPlayersView.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 08.08.23.
//

import UIKit

class TotalPlayersView: UIView {

    private let overlayView: UIView = UIView()
    
    @IBOutlet var contentView: UIView!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("TotalPlayers", owner: self)
        
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.addElevation()
        
        // Add overlay to disable user interaction and clearly seperate design wise.
        self.overlayView.backgroundColor = .black.withAlphaComponent(0.3)
        self.overlayView.frame = UIScreen.main.bounds
        self.overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(overlayView)
    }
    
    func show() {
        superview?.insertSubview(self.overlayView, belowSubview: self)
    }
}

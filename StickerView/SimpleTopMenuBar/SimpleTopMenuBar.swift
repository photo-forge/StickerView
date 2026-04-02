//
//  TopMenuBar.swift
//  StickerView
//
//  Created by Rashed Nizam on 27/2/21.
//

import UIKit

public protocol StickerTopMenuBarDelegate {
    func stickerTopMenuBar_BackButtonTapped()
    func stickerTopMenuBar_TickButtonTapped()
}

class SimpleTopMenuBar: UIView {
    
    var delegate:StickerTopMenuBarDelegate!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, title:NSString) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear;
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = color.cgColor
        
        // Title
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width/2, height: frame.height))
        self.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.center = CGPoint(x: self.bounds.width/2, y: self.bounds.minY)
        titleLabel.text = title as String
        titleLabel.center = CGPoint(x: frame.width/2, y: frame.height/2)
        
        // Back Button
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        self.addSubview(backButton)
        
        backButton.setImage(CommonMethods.ins.uiImageWithName(named: "menubar-back-button"), for: UIControl.State())
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
        
        // Tick Button
        let tickButton = UIButton(frame: CGRect(x: frame.width-frame.height, y: 0, width: frame.height, height: frame.height))
        self.addSubview(tickButton)
        tickButton.setImage(CommonMethods.ins.uiImageWithName(named: "menubar-tick-button"), for: UIControl.State())
        tickButton.imageView?.contentMode = .scaleAspectFit
        tickButton.addTarget(self, action: #selector(self.tickButtonTapped), for: .touchUpInside)
        
    }
    
    
    @objc func backButtonTapped() {
        
        if (delegate != nil) {
            delegate.stickerTopMenuBar_BackButtonTapped()
        }
        
    }
    
    @objc func tickButtonTapped() {
        if (delegate != nil) {
            delegate.stickerTopMenuBar_TickButtonTapped()
        }
    }
    
    
    
}

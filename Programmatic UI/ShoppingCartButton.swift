//
//  ShoppingCartButton.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/24/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class ShoppingCartButton: UIButton {
    
    enum CartType: String {
        case normal = "cart"
        case add = "cart.badge.plus"
    }
    
    var cartType: CartType = .normal
    var diameter: CGFloat = 50
    
    init(type: CartType, tint: UIColor, background: UIColor) {
        super.init(frame: CGRect.zero)
        
        setImage(UIImage(systemName: type.rawValue, withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        tintColor = tint
        backgroundColor = background
        layer.cornerRadius = diameter / 2
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: diameter).isActive = true
        heightAnchor.constraint(equalToConstant: diameter).isActive = true
        
        addTarget(self, action: #selector(shoppingCartButtonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(shoppingCartButtonTouchUp), for: .touchUpInside)
        addTarget(self, action: #selector(shoppingCartButtonTouchUp), for: .touchDragExit)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Actions
    
    @objc func shoppingCartButtonTouchDown() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = self.transform.scaledBy(x: 1.3, y: 1.3)
        })
    }
    
    @objc func shoppingCartButtonTouchUp() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
    
}

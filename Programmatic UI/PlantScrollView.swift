//
//  PlantScrollView.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/7/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class PlantScrollView: UIScrollView, PlantCardViewDelegate {
    
    let stackView = UIStackView()
        
    init() {
        super.init(frame: CGRect.zero)
                
        showsHorizontalScrollIndicator = false
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        self.addSubview(stackView)
        
        // Set constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func clearPlants() {
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    func setPlants(_ plants: [Plant]) {
        let cardViews: [PlantCardView] = plants.map {
            let cardView = PlantCardView(from: $0)
            cardView.widthAnchor.constraint(equalToConstant: PlantCardView.cardWidth).isActive = true
            cardView.heightAnchor.constraint(equalToConstant: PlantCardView.cardHeight).isActive = true
            cardView.delegate = self
            return cardView
        }

        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.clearPlants()
            for cardView in cardViews {
                self.stackView.addArrangedSubview(cardView)
            }
            self.contentOffset = .zero
        }, completion: nil)
    }
    
    @objc func plantCardPressed(_ sender: PlantCardView) {
        (delegate as! PlantCardViewDelegate).plantCardPressed(sender)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if clipsToBounds || isHidden || alpha == 0 {
            return nil
        }
        
        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }

        return nil
    }
        
}

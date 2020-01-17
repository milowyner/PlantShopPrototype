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
        stackView.spacing = smallerSpacingConstant
        
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
    
    func addPlant(_ plant: Plant) {
        let cardView = PlantCardView(from: plant)
        stackView.addArrangedSubview(cardView)
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
        
}

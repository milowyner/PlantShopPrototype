//
//  PlantScrollView.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/7/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class PlantScrollView: UIScrollView {
    
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
        setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.layer.opacity = 0.5
        }) { (completed) in
            self.clearPlants()
            for plant in plants {
                let cardView = PlantCardView(from: plant)
                self.stackView.addArrangedSubview(cardView)
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.layer.opacity = 1
            }, completion: nil)
        }
        
        // Alternate method
//
//        // Clear card views that aren't in the plant array
//        for subview in stackView.arrangedSubviews {
//            let cardView = subview as! PlantCardView
//            if !plants.contains(where: { $0.name == cardView.nameLabel.text }) {
//                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
//                    subview.layer.opacity = 0
//                }) { (completed) in
//                    self.stackView.removeArrangedSubview(subview)
//                    subview.removeFromSuperview()
//                }
//            }
//        }
//
//        // Add card views that aren't in the stackView array
//        for (index, plant) in plants.enumerated() {
//            if !stackView.arrangedSubviews.contains(where: { ($0 as! PlantCardView).nameLabel.text == plant.name }) {
//                let cardView = PlantCardView(from: plant)
//                cardView.layer.opacity = 0
//
//                var cardToMove: UIView?
//                var secondCardToMove: UIView?
//
//                UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
//                    cardToMove = self.stackView.arrangedSubviews.count >= index + 1 ? self.stackView.arrangedSubviews[index] : nil
//                    secondCardToMove = self.stackView.arrangedSubviews.count >= index + 2 ? self.stackView.arrangedSubviews[index + 1] : nil
//                    cardToMove?.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
//                    secondCardToMove?.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
//                }) { (completed) in
//                    self.stackView.insertArrangedSubview(cardView, at: index)
//                    cardToMove?.transform = CGAffineTransform.identity
//                    secondCardToMove?.transform = CGAffineTransform.identity
//                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
//                        cardView.layer.opacity = 1
//                    }, completion: nil)
//                }
//            }
//        }
    }
        
}

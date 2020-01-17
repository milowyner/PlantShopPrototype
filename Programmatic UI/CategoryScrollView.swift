//
//  CategoryScrollView.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/7/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class CategoryScrollView: UIScrollView {
    
    let stackView = UIStackView()
    let buttonArray = (0..<5).map { _ in UIButton() }
    var selectedButton = UIButton()
    
    var categoryDelegate: CategoryScrollViewDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        
        showsHorizontalScrollIndicator = false
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = spacingConstant
        
        // Set up buttons
                
        for (index, button) in buttonArray.enumerated() {
            button.setTitle(PlantCategory.allCases[index].rawValue, for: .normal)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
            styleDeselected(button)
            button.addTarget(self, action: #selector(categorybuttonPressed(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        selectedButton = buttonArray[0]
        styleSelected(selectedButton)
        
        self.addSubview(stackView)
        
        // Set constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Add padding to left and right side
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: spacingConstant, bottom: 0, right: spacingConstant)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func categorybuttonPressed(_ sender: UIButton) {
        categoryDelegate?.categoryButtonPressed(sender)
        if sender != selectedButton {
            styleDeselected(selectedButton)

            UIView.animate(withDuration: 0.1, animations: {
                self.styleSelected(sender)
                sender.transform = sender.transform.scaledBy(x: 1.1, y: 1.1)
            }) { (completed) in
                UIView.animate(withDuration: 0.2) {
                    sender.transform = CGAffineTransform.identity
                }
            }
            selectedButton = sender
        }
    }
    
    private func styleSelected(_ button: UIButton) {
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = getScaledFont(for: .coreSansBold, size: .button)
    }
    
    private func styleDeselected(_ button: UIButton) {
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = getScaledFont(for: .coreSansRegular, size: .button)
    }
    
}

enum PlantCategory: String, CaseIterable {
    case top = "Top"
    case outdoor = "Outdoor"
    case indoor = "Indoor"
    case plantCare = "Plant Care"
    case terrariums = "Terrariums"
}

protocol CategoryScrollViewDelegate {
    func categoryButtonPressed(_ sender: UIButton)
}


//
//  PlantInfoViewController.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/14/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class PlantInfoViewController: UIViewController {
    
    let backButton = UIButton()
    let shoppingCartButton = ShoppingCartButton(type: .normal, tint: .systemBackground, background: .lightGreenBackground)
    let categoryLabel = UILabel()
    let nameLabel = UILabel()
    let fromLabel = UILabel()
    let priceLabel = UILabel()
    
    var plant: Plant! {
        didSet {
            categoryLabel.text = plant.category.rawValue.uppercased()
            nameLabel.text = plant.name
            priceLabel.text = "$\(plant.price)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .plantBackground
        
        setupViews()
        setConstraints()
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        // backButton
        backButton.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        view.addSubview(backButton)
        
        // shoppingCartButton
        view.addSubview(shoppingCartButton)
        
        // categoryLabel
        categoryLabel.text = "INDOOR"
        categoryLabel.textColor = .lightGreenText
        categoryLabel.font = getScaledFont(for: .bold, size: .label)
        view.addSubview(categoryLabel)
        
        // nameLabel
        nameLabel.textColor = .white
        nameLabel.font = getScaledFont(for: .bold, size: .title)
        view.addSubview(nameLabel)
        
        // fromLabel
        fromLabel.text = "FROM"
        fromLabel.textColor = .lightGreenText
        fromLabel.font = getScaledFont(for: .bold, size: .label)
        view.addSubview(fromLabel)
        
        // priceLabel
        priceLabel.textColor = .white
        priceLabel.font = getScaledFont(for: .regular, size: .info)
        view.addSubview(priceLabel)
    }
    
    private func setConstraints() {
        view.directionalLayoutMargins = .customMargins

        NSLayoutConstraint.activateWithAutolayout(constraints: [
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            shoppingCartButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            shoppingCartButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            categoryLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            fromLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            fromLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: false)
    }

}

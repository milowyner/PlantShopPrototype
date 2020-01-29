//
//  PlantInfoViewController.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/14/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class PlantInfoViewController: UIViewController {
    
    var shoppingCartButton = ShoppingCartButton(type: .normal, tint: .systemBackground, background: .lightGreenBackground)
    
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "INDOOR"
        label.textColor = .lightGreenText
        label.font = getScaledFont(for: .bold, size: .label)
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = getScaledFont(for: .bold, size: .title)
        return label
    }()
    
    var fromLabel: UILabel = {
        let label = UILabel()
        label.text = "FROM"
        label.textColor = .lightGreenText
        label.font = getScaledFont(for: .bold, size: .label)
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = getScaledFont(for: .regular, size: .info)
        return label
    }()
    
    var plant: Plant! {
        didSet {
            categoryLabel.text = plant.category.rawValue.uppercased()
            nameLabel.text = plant.name
            priceLabel.text = "$\(plant.price)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard plant != nil else {
            fatalError("Plant can't be nil")
        }
        
        view.backgroundColor = .plantBackground
        
        setupViews()
        setConstraints()
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        let topLevelViews = [
            backButton,
            shoppingCartButton,
            categoryLabel,
            nameLabel,
            fromLabel,
            priceLabel,
        ]
        
        for view in topLevelViews {
            self.view.addSubview(view)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activateWithAutolayout(constraints: [
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingConstant / 2),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant - 10),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            shoppingCartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingConstant / 2),
            shoppingCartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -smallerSpacingConstant),

            categoryLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: spacingConstant / 2),
            categoryLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant),
            
            nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant),
            
            fromLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: smallerSpacingConstant),
            fromLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant),
            
            priceLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: false)
    }

}

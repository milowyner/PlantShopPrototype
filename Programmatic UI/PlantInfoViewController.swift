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
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        return backButton
    }()
    
    var indoorLabel: UILabel = {
        let indoorLabel = UILabel()
        indoorLabel.text = "INDOOR"
        return indoorLabel
    }()
    
    var plant: Plant! {
        didSet {
//            label.text = plant.name
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
            indoorLabel,
        ]
        
        for view in topLevelViews {
            self.view.addSubview(view)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activateWithAutolayout(constraints: [
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingConstant),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            shoppingCartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingConstant),
            shoppingCartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacingConstant),

            indoorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indoorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: false)
    }

}

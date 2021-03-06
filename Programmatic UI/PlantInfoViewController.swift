//
//  PlantInfoViewController.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/14/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class PlantInfoViewController: UIViewController {
    
    let verticalScrollView = UIScrollView()
    let backgroundView = UIView()
    let backButton = UIButton()
    let shoppingCartButton = ShoppingCartButton(type: .normal, tint: .systemBackground, background: .lightGreenBackground)
    let categoryLabel = UILabel()
    let fromLabel = UILabel()
    let priceLabel = UILabel()
    let sizesLabel = UILabel()
    let sizesInfoLabel = UILabel()
    let addToCartButton = ShoppingCartButton(type: .add, tint: .systemBackground, background: .label)
    let bottomBackgroundView = UIView()
    let allToKnowLabel = UILabel()
    let descriptionBodyLabel = UILabel()
    let detailsLabel = UILabel()
    let detailsBodyLabel = UILabel()
    let plantImageView = UIImageView()
    let nameLabel = UILabel()
    
    var plant: Plant! {
        didSet {
            categoryLabel.text = plant.category.rawValue
            nameLabel.text = plant.name
            priceLabel.text = "$\(plant.price)"
            sizesInfoLabel.text = plant.sizes[0].rawValue
            descriptionBodyLabel.attributedText = .increasedLineHeight(string: plant.description)
            detailsBodyLabel.attributedText = .increasedLineHeight(string: "Plant height: 35-45cm;\nNursery pot width: 12cm")
            plantImageView.image = plant.image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        setUpViews()
        setConstraints()
    }
    
    // MARK: - View Setup
    
    private func setUpViews() {
        
        for view in [
            backgroundView,
            backButton,
            shoppingCartButton,
            verticalScrollView
            ] {
                self.view.addSubview(view)
        }
        
        for view in [
            categoryLabel,
            fromLabel,
            priceLabel,
            sizesLabel,
            sizesInfoLabel,
            bottomBackgroundView,
            addToCartButton,
            allToKnowLabel,
            descriptionBodyLabel,
            detailsLabel,
            detailsBodyLabel,
            plantImageView,
            nameLabel
            ] {
                verticalScrollView.addSubview(view)
        }
        
        // verticalScrollView
        verticalScrollView.contentInset = UIEdgeInsets(
            top: 0, left: 0, bottom: NSDirectionalEdgeInsets.customMargins.bottom, right: 0
        )
        
        // backgroundView
        backgroundView.backgroundColor = .plantBackground
        
        // backButton
        backButton.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
                
        // categoryLabel
        categoryLabel.textColor = .lightGreenText
        categoryLabel.font = getScaledFont(for: .bold, size: .label)
        
        // fromLabel
        fromLabel.text = "FROM"
        fromLabel.textColor = .lightGreenText
        fromLabel.font = getScaledFont(for: .bold, size: .label)
        
        // priceLabel
        priceLabel.textColor = .white
        priceLabel.font = getScaledFont(for: .regular, size: .info)
        
        // sizesLabel
        sizesLabel.text = "SIZES"
        sizesLabel.textColor = .lightGreenText
        sizesLabel.font = getScaledFont(for: .bold, size: .label)
        
        // sizesInfoLabel
        sizesInfoLabel.textColor = .white
        sizesInfoLabel.font = getScaledFont(for: .regular, size: .info)
        
        // bottomBackgroundView
        bottomBackgroundView.backgroundColor = .systemBackground
        bottomBackgroundView.layer.cornerRadius = 25
        
        // allToKnowLabel
        allToKnowLabel.text = "All to know..."
        allToKnowLabel.textColor = .label
        allToKnowLabel.font = getScaledFont(for: .regular, size: 26)
        
        // allToKnowBodyLabel
        descriptionBodyLabel.textColor = .secondaryLabel
        descriptionBodyLabel.font = getScaledFont(for: .regular, size: .body)
        descriptionBodyLabel.numberOfLines = 0
        
        // detailsLabel
        detailsLabel.text = "Details"
        detailsLabel.textColor = .label
        detailsLabel.font = getScaledFont(for: .regular, size: .headline)
        
        // detailsBodyLabel
        detailsBodyLabel.textColor = .secondaryLabel
        detailsBodyLabel.font = getScaledFont(for: .regular, size: .body)
        detailsBodyLabel.numberOfLines = 0
        
        // plantImageView
        plantImageView.contentMode = .scaleAspectFit
        
        // nameLabel
        nameLabel.textColor = .white
        nameLabel.font = getScaledFont(for: .bold, size: .title)
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setConstraints() {
        view.directionalLayoutMargins = .customMargins
        
        let cornerRadiusOffset = backgroundView.layer.cornerRadius - cos(CGFloat.pi / 4) * backgroundView.layer.cornerRadius
        NSLayoutConstraint.activateWithAutolayout(constraints: [
            verticalScrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            verticalScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -cornerRadiusOffset),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -cornerRadiusOffset),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: cornerRadiusOffset),
            backgroundView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            shoppingCartButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            shoppingCartButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            categoryLabel.topAnchor.constraint(equalTo: verticalScrollView.topAnchor, constant: verticalSpacingConstant / 2),
            categoryLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                        
            fromLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: verticalSpacingConstant * 3/4),
            fromLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            sizesLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: verticalSpacingConstant / 2),
            sizesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            sizesInfoLabel.topAnchor.constraint(equalTo: sizesLabel.bottomAnchor),
            sizesInfoLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            addToCartButton.topAnchor.constraint(equalTo: sizesInfoLabel.bottomAnchor, constant: verticalSpacingConstant * 3/4),
            addToCartButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            bottomBackgroundView.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: verticalSpacingConstant),
            bottomBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -5),
            bottomBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5),
            bottomBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            allToKnowLabel.topAnchor.constraint(equalTo: bottomBackgroundView.topAnchor, constant: 90 * verticalSpacingMultiplier),
            allToKnowLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            allToKnowLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            
            descriptionBodyLabel.topAnchor.constraint(equalTo: allToKnowLabel.bottomAnchor, constant: verticalSpacingConstant / 2),
            descriptionBodyLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            descriptionBodyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            
            detailsLabel.topAnchor.constraint(equalTo: descriptionBodyLabel.bottomAnchor, constant: 50 * verticalSpacingMultiplier),
            detailsLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            detailsBodyLabel.topAnchor.constraint(equalToSystemSpacingBelow: detailsLabel.bottomAnchor, multiplier: 1),
            detailsBodyLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            detailsBodyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            detailsBodyLabel.bottomAnchor.constraint(equalTo: verticalScrollView.bottomAnchor),
            
            plantImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            plantImageView.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.4),
            plantImageView.bottomAnchor.constraint(equalTo: bottomBackgroundView.topAnchor, constant: 150),
            
            nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

}

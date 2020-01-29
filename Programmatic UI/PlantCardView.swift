//
//  PlantCardView.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/7/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class PlantCardView: UIButton {
    
    private var fromLabel = UILabel()
    var backgroundView = UIButton()
    var priceLabel = UILabel()
    var plantImage = UIImageView()
    var categoryLabel = UILabel()
    var nameLabel = UILabel()
    var requirementsBar = UIImageView()
    var addToCartButton = ShoppingCartButton(type: .add, tint: .systemBackground, background: .label)
    
    static let cardWidth: CGFloat = 220
    static let cardHeight: CGFloat = 355
    static let bottomOffset: CGFloat = 40
    
    var plant: Plant!
    
    var delegate: PlantCardViewDelegate?
    
    init(from plant: Plant) {
        super.init(frame: CGRect.zero)
        
        self.plant = plant
                
        setupBackgroundView()
        setupPlantImage(with: plant.image)
        setupFromLabel()
        setupPriceLabel(with: plant.price)
        setupCategoryLabel(with: plant.category.rawValue)
        setupNameLabel(with: plant.name)
        setupRequirementsBar()
        setupAddToCartButton()
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: PlantCardView.cardWidth).isActive = true
        heightAnchor.constraint(equalToConstant: PlantCardView.cardHeight + PlantCardView.bottomOffset).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up subviews
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = .plantBackground
        backgroundView.layer.cornerRadius = 14
        backgroundView.addTarget(self, action: #selector(backgroundPressed(_:)), for: .touchUpInside)
        
        addSubview(backgroundView)
        
        // Set constraints
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PlantCardView.bottomOffset).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupFromLabel() {
        fromLabel.text = "FROM"
        fromLabel.textColor = UIColor.lightGreenText
        fromLabel.font = getScaledFont(for: Font.camptonBold, size: .caption)
        
        addSubview(fromLabel)
        
        // Set constraints
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.topAnchor.constraint(equalTo: topAnchor, constant: smallerSpacingConstant).isActive = true
        fromLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -smallerSpacingConstant * 0.75).isActive = true
    }
    
    private func setupPriceLabel(with price: Int) {
        priceLabel.text = "$\(price)"
        priceLabel.textColor = .white
        priceLabel.font = getScaledFont(for: .regular, size: .price)
        
        addSubview(priceLabel)
        
        // Set constraints
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -smallerSpacingConstant * 0.75).isActive = true
    }
    
    private func setupPlantImage(with image: UIImage) {
        plantImage.image = image
        plantImage.contentMode = .scaleAspectFit
        
        addSubview(plantImage)
        
        // Set constraints
        plantImage.translatesAutoresizingMaskIntoConstraints = false
        plantImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        plantImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        plantImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        plantImage.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 60).isActive = true
    }
    
    private func setupCategoryLabel(with category: String) {
        categoryLabel.text = category.uppercased()
        categoryLabel.textColor = UIColor.lightGreenText
        categoryLabel.font = getScaledFont(for: .bold, size: .caption)
        
        addSubview(categoryLabel)
        
        // Set constraints
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: smallerSpacingConstant).isActive = true

        // Set constraints
    }
    
    private func setupNameLabel(with name: String) {
        nameLabel.text = name
        nameLabel.textColor = .white
        nameLabel.font = getScaledFont(for: .bold, size: .price)
        
        addSubview(nameLabel)
        
        // Set constraints
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: categoryLabel.bottomAnchor, multiplier: 0.5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: smallerSpacingConstant).isActive = true
        nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -smallerSpacingConstant * 0.75).isActive = true
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupRequirementsBar() {
        requirementsBar.image = UIImage(named: "requirements-bar.png")
        requirementsBar.contentMode = .scaleAspectFit
        
        addSubview(requirementsBar)
        
        // Set constraints
        requirementsBar.translatesAutoresizingMaskIntoConstraints = false
        requirementsBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
        requirementsBar.widthAnchor.constraint(equalToConstant: 150).isActive = true
        requirementsBar.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1).isActive = true
        requirementsBar.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -smallerSpacingConstant).isActive = true
        requirementsBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: smallerSpacingConstant).isActive = true
    }
    
    private func setupAddToCartButton() {
        addSubview(addToCartButton)
        
        // Set constraints
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.centerYAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        addToCartButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    // MARK: - Actions
    
//    @objc func addToCartButtonTouchDown() {
//        UIView.animate(withDuration: 0.1, animations: {
//            self.addToCartButton.transform = self.addToCartButton.transform.scaledBy(x: 1.3, y: 1.3)
//        })
//    }
//
//    @objc func addToCartButtonTouchUp() {
//        print(#function)
//        UIView.animate(withDuration: 0.2, animations: {
//            self.addToCartButton.transform = CGAffineTransform.identity
//        })
//    }
    
    @objc func backgroundPressed(_ sender: UIButton) {
        delegate?.plantCardPressed(self)
    }
    
}

protocol PlantCardViewDelegate {
    func plantCardPressed(_ sender: PlantCardView)
}

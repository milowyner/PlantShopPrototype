//
//  PlantCardView.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/7/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class PlantCardView: UIButton {
    
    var fromLabel = UILabel()
    var backgroundView = UIButton()
    var priceLabel = UILabel()
    var plantImage = UIImageView()
    var categoryLabel = UILabel()
    var nameLabel = UILabel()
    var requirementsBar = UIImageView()
    var addToCartButton = ShoppingCartButton(type: .add, tint: .systemBackground, background: .label)
    
    static let cardWidth: CGFloat = 220 * spacingMultiplier
    static let cardHeight: CGFloat = 355 * spacingMultiplier
    
    var plant: Plant!
    
    var delegate: PlantCardViewDelegate?
    
    init(from plant: Plant) {
        super.init(frame: CGRect.zero)
        
        self.plant = plant
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: verticalSpacingConstant * 0.75,
            leading: horizontalSpacingConstant * 0.75,
            bottom: addToCartButton.diameter + verticalSpacingConstant * 0.25,
            trailing: horizontalSpacingConstant * 0.75 * 0.75
        )
        
        setUpViews()
        setUpConstraints()
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: PlantCardView.cardWidth).isActive = true
        heightAnchor.constraint(equalToConstant: PlantCardView.cardHeight + addToCartButton.diameter / 2).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up subviews
    
    private func setUpViews() {
        setUpBackgroundView()
        setUpRequirementsBar()
        setUpPlantImage(with: plant.image)
        setUpFromLabel()
        setUpPriceLabel(with: plant.price)
        setUpCategoryLabel(with: plant.category.rawValue)
        setUpNameLabel(with: plant.name)
        setUpAddToCartButton()
    }
    
    private func setUpConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -addToCartButton.diameter / 2).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        fromLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
        plantImage.translatesAutoresizingMaskIntoConstraints = false
        plantImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        plantImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        plantImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        plantImage.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 60).isActive = true
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: categoryLabel.bottomAnchor, multiplier: 0.5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor).isActive = true
        requirementsBar.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1).isActive = true
        nameLabel.adjustsFontSizeToFitWidth = true
        
        requirementsBar.translatesAutoresizingMaskIntoConstraints = false
        requirementsBar.heightAnchor.constraint(equalToConstant: 35 * spacingMultiplier).isActive = true
        requirementsBar.widthAnchor.constraint(equalToConstant: 150 * spacingMultiplier).isActive = true
        requirementsBar.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        requirementsBar.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.centerYAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        addToCartButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setUpBackgroundView() {
        backgroundView.backgroundColor = .plantBackground
        backgroundView.layer.cornerRadius = 14
        backgroundView.addTarget(self, action: #selector(backgroundPressed(_:)), for: .touchUpInside)
        
        addSubview(backgroundView)
    }
    
    private func setUpFromLabel() {
        fromLabel.text = "FROM"
        fromLabel.textColor = UIColor.lightGreenText
        fromLabel.font = getScaledFont(for: .camptonBold, size: .label)
        
        addSubview(fromLabel)
    }
    
    private func setUpPriceLabel(with price: Int) {
        priceLabel.text = "$\(price)"
        priceLabel.textColor = .white
        priceLabel.font = getScaledFont(for: .regular, size: .info)
        
        addSubview(priceLabel)
    }
    
    private func setUpPlantImage(with image: UIImage) {
        plantImage.image = image
        plantImage.contentMode = .scaleAspectFit
        
        addSubview(plantImage)
    }
    
    private func setUpCategoryLabel(with category: String) {
        categoryLabel.text = category.uppercased()
        categoryLabel.textColor = UIColor.lightGreenText
        categoryLabel.font = getScaledFont(for: .bold, size: .label)
        
        addSubview(categoryLabel)
    }
    
    private func setUpNameLabel(with name: String) {
        nameLabel.text = name
        nameLabel.textColor = .white
        nameLabel.font = getScaledFont(for: .bold, size: .info)
        
        addSubview(nameLabel)
    }
    
    private func setUpRequirementsBar() {
        requirementsBar.image = UIImage(named: "requirements-bar.png")
        requirementsBar.contentMode = .scaleAspectFit
        
        addSubview(requirementsBar)
    }
    
    private func setUpAddToCartButton() {
        addSubview(addToCartButton)
    }
    
    // MARK: - Actions
        
    @objc func backgroundPressed(_ sender: UIButton) {
        delegate?.plantCardPressed(self)
    }
    
}

protocol PlantCardViewDelegate {
    func plantCardPressed(_ sender: PlantCardView)
}

//
//  MainViewController.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/2/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate, PlantCardViewDelegate, CategoryScrollViewDelegate {
    
    var visiblePlants = [Plant]()
    
    let allPlants = [
        Plant(name: "Aloe Vera", price: 25, category: .outdoor, sizes: [.small], image: UIImage(named: "aloe-shadow")!, description: "Aloe vera is a succulent plant species of the genus Aloe. Its medicinal uses and air purifying ability make it the plant that you shouldn't live without."),
        Plant(name: "Monstera Deliciosa", price: 40, category: .indoor, sizes: [.large], image: UIImage(named: "monstera-deliciosa-left")!, description: "Also known as a split leaf philodendron, this easy-to-grow houseplant can get huge and live for many years, and it looks great with many different interior styles."),
        Plant(name: "Ficus", price: 30, category: .indoor, sizes: [.small], image: UIImage(named: "ficus-shadow")!, description: "Ficus trees are a common plant in the home and office, mainly because they look like a typical tree with a single trunk and a spreading canopy."),
    ]
    
    var selectedCategory: PlantCategory = .top
    var selectedPlantCardView: PlantCardView?
    
    // Used to animate the description change of the current plant card being displayed
    var pageIndexOfPlantScrollView = 0
    
    // MARK: Views
    
    let menuButton = UIButton()
    let shoppingCartButton = ShoppingCartButton(type: .normal, tint: .label, background: .secondarySystemFill)
    
    let verticalScrollView = UIScrollView()
    
    let titleLabel = UILabel()
    let categoryScrollView = CategoryScrollView()
    let plantScrollViewContainer = UIView()
    let plantScrollView = PlantScrollView()
    let descriptionLabel = UILabel()
    let descriptionBodyLabel = UILabel()
    let nothingFoundLabel = UILabel()
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        
        setupViews()
        setConstraints()
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        // Add top level views to the main view
        for topLevelView in [
            menuButton,
            shoppingCartButton,
            verticalScrollView
            ] {
                view.addSubview(topLevelView)
        }
        
        // Add scrolling views to the vertical scroll view
        for scrollingView in [
            titleLabel,
            categoryScrollView,
            plantScrollViewContainer,
            descriptionLabel,
            descriptionBodyLabel,
            nothingFoundLabel
            ] {
                verticalScrollView.addSubview(scrollingView)
        }
        
        // Menu button
        menuButton.setImage(UIImage(named: "Menu"), for: .normal)
        
        // Title label
        titleLabel.text = "Top Picks"
        titleLabel.textColor = .label
        titleLabel.font = getScaledFont(for: .regular, size: .title)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        // Category scroll view
        categoryScrollView.categoryDelegate = self
        categoryScrollView.stackView.spacing = horizontalSpacingConstant
        categoryScrollView.stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: NSDirectionalEdgeInsets.customMargins.leading,
            bottom: 0,
            trailing: NSDirectionalEdgeInsets.customMargins.trailing
        )
        
        // Plant scroll view
        visiblePlants = filteredPlants(fromCategory: .top)
        plantScrollView.setPlants(visiblePlants)
        plantScrollView.delegate = self
        plantScrollView.stackView.spacing = horizontalSpacingConstant * 0.75
        plantScrollView.isPagingEnabled = true
        plantScrollView.clipsToBounds = false
        
        // Plant scroll view container
        plantScrollViewContainer.addSubview(plantScrollView)
        plantScrollViewContainer.addGestureRecognizer(plantScrollView.panGestureRecognizer)
        
        // Description label
        descriptionLabel.text = "Description"
        descriptionLabel.textColor = .label
        descriptionLabel.font = getScaledFont(for: .regular, size: .headline)
        
        // Description body label
        descriptionBodyLabel.textColor = .secondaryLabel
        descriptionBodyLabel.font = getScaledFont(for: .regular, size: .body)
        descriptionBodyLabel.numberOfLines = 0
        descriptionBodyLabel.attributedText = .increasedLineHeight(string: visiblePlants[0].description)
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        // Set custom margins
        view.directionalLayoutMargins = .customMargins
        verticalScrollView.contentInset = UIEdgeInsets(
            top: 0, left: 0, bottom: NSDirectionalEdgeInsets.customMargins.bottom, right: 0
        )
        
        let constraints = [
            // Menu button
            menuButton.widthAnchor.constraint(equalToConstant: 50),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            menuButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -10),
            
            // Shopping cart button
            shoppingCartButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            shoppingCartButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // Vertical scroll view
            verticalScrollView.topAnchor.constraint(equalTo: menuButton.bottomAnchor),
            verticalScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: verticalScrollView.topAnchor, constant: -15 + verticalSpacingConstant * 0.75),
            titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            
            // Category scroll view
            categoryScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: verticalSpacingConstant),
            categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Plant scroll view container
            plantScrollViewContainer.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: verticalSpacingConstant / 2),
            plantScrollViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plantScrollViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Plant scroll view
            plantScrollView.topAnchor.constraint(equalTo: plantScrollViewContainer.topAnchor),
            plantScrollView.bottomAnchor.constraint(equalTo: plantScrollViewContainer.bottomAnchor),
            plantScrollView.leadingAnchor.constraint(equalTo: plantScrollViewContainer.leadingAnchor, constant: horizontalSpacingConstant),
            plantScrollView.widthAnchor.constraint(equalToConstant: PlantCardView.cardWidth + plantScrollView.stackView.spacing),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: plantScrollView.bottomAnchor, constant: verticalSpacingConstant / 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            
            // Description body label
            descriptionBodyLabel.topAnchor.constraint(equalToSystemSpacingBelow: descriptionLabel.bottomAnchor, multiplier: 1),
            descriptionBodyLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            descriptionBodyLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            descriptionBodyLabel.bottomAnchor.constraint(equalTo: verticalScrollView.bottomAnchor)
        ]
        
        // Enable autolayout
        for constraint in constraints {
            (constraint.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Activate constraints
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newPageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        if newPageIndex != pageIndexOfPlantScrollView && visiblePlants.count >= newPageIndex + 1 {
            setNewDescription(index: newPageIndex)
            pageIndexOfPlantScrollView = newPageIndex
        }
    }
    
    func categoryButtonPressed(_ sender: UIButton) {
        let category = PlantCategory.init(rawValue: sender.title(for: .normal)!)!
        
        if category != selectedCategory {
            visiblePlants = filteredPlants(fromCategory: category)
            plantScrollView.setPlants(visiblePlants)
            if visiblePlants.isEmpty {
                showNothingFoundLabel()
            } else {
                hideNothingFoundLabel()
                setNewDescription(index: 0)
            }
            selectedCategory = category
        }
    }
    
    func plantCardPressed(_ sender: PlantCardView) {
        selectedPlantCardView = sender
        
        let plantInfoVC = PlantInfoViewController()
        plantInfoVC.plant = sender.plant
        plantInfoVC.backgroundView.layer.cornerRadius = sender.backgroundView.layer.cornerRadius * view.bounds.width / sender.backgroundView.bounds.width
        plantInfoVC.modalPresentationStyle = .custom
        plantInfoVC.transitioningDelegate = TransitioningDelegate.shared
        
        present(plantInfoVC, animated: true)
    }
    
    // MARK: - Private Functions
    
    private func filteredPlants(fromCategory category: PlantCategory) -> [Plant] {
        switch category {
        case .top:
            return allPlants
        case .outdoor:
            return allPlants.filter { $0.category == .outdoor }
        case .indoor:
            return allPlants.filter { $0.category == .indoor }
        case .plantCare:
            return []
        case .terrariums:
            return []
        }
    }
    
    private func showNothingFoundLabel() {
        nothingFoundLabel.text = "Nothing found."
        nothingFoundLabel.textColor = .secondaryLabel
        nothingFoundLabel.font = getScaledFont(for: .bold, size: .info)
        
        view.addSubview(nothingFoundLabel)
        
        // Set constraints
        nothingFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        nothingFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nothingFoundLabel.centerYAnchor.constraint(equalTo: plantScrollView.topAnchor, constant: PlantCardView.cardHeight / 2).isActive = true
        
        descriptionLabel.isHidden = true
        descriptionBodyLabel.isHidden = true
    }
    
    private func hideNothingFoundLabel() {
        nothingFoundLabel.removeFromSuperview()
        descriptionLabel.isHidden = false
        descriptionBodyLabel.isHidden = false
    }
    
    private func setNewDescription(index: Int) {
        let attributes = self.descriptionBodyLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        let attributedString = NSAttributedString(string: visiblePlants[index].description, attributes: attributes)
        descriptionBodyLabel.layer.removeAllAnimations()
        UIView.transition(with: descriptionBodyLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.descriptionBodyLabel.attributedText = attributedString
        }, completion: nil)
    }
    
}

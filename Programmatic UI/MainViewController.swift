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
    
    // Used to animate the description change of the current plant card being displayed
    var pageIndexOfPlantScrollView = 0
    
    // MARK: Views
    
    let menuButton: UIButton = {
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "Menu"), for: .normal)
        return menuButton
    }()
    
    let shoppingCartButton = ShoppingCartButton(type: .normal, tint: .label, background: .secondarySystemFill)
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Top Picks"
        titleLabel.textColor = .label
        titleLabel.font = getScaledFont(for: .regular, size: .title)
        titleLabel.adjustsFontForContentSizeCategory = true
        return titleLabel
    }()
    
    let categoryScrollView = CategoryScrollView()
    
    let plantScrollViewContainer = UIView()
    
    let plantScrollView: PlantScrollView = {
        let plantScrollView = PlantScrollView()
        // Enable paging
        plantScrollView.isPagingEnabled = true
        plantScrollView.clipsToBounds = false
        return plantScrollView
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Description"
        descriptionLabel.textColor = .label
        descriptionLabel.font = getScaledFont(for: .regular, size: .headline)
        return descriptionLabel
    }()
    
    let descriptionBodyLabel: UILabel = {
        let descriptionBodyLabel = UILabel()
        descriptionBodyLabel.textColor = .secondaryLabel
        descriptionBodyLabel.font = getScaledFont(for: .regular, size: .body)
        descriptionBodyLabel.numberOfLines = 0
        return descriptionBodyLabel
    }()
    
    let nothingFoundLabel = UILabel()
    
    // A list of every view that will use autolayout
    lazy var autoLayoutViews = [
        menuButton,
        shoppingCartButton,
        titleLabel,
        categoryScrollView,
        plantScrollViewContainer,
        plantScrollView,
        descriptionLabel,
        descriptionBodyLabel,
        nothingFoundLabel
    ]
    
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
        let topLevelViews = [
            menuButton,
            shoppingCartButton,
            titleLabel,
            categoryScrollView,
            plantScrollViewContainer,
            descriptionLabel,
            descriptionBodyLabel,
            nothingFoundLabel
        ]
        for view in topLevelViews {
            self.view.addSubview(view)
        }
        
        // Category scroll view setup
        categoryScrollView.categoryDelegate = self
        
        // Plant scroll view setup
        visiblePlants = filteredPlants(fromCategory: .top)
        plantScrollView.setPlants(visiblePlants)
        plantScrollView.delegate = self
        
        // Plant scroll view container setup
        plantScrollViewContainer.addSubview(plantScrollView)
        plantScrollViewContainer.addGestureRecognizer(plantScrollView.panGestureRecognizer)
        
        // Description body label setup
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributedString = NSMutableAttributedString(string: visiblePlants[0].description, attributes: [.paragraphStyle: paragraphStyle])
        descriptionBodyLabel.attributedText = attributedString
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
        let plantInfoVC = PlantInfoViewController()
        plantInfoVC.plant = sender.plant
        plantInfoVC.modalPresentationStyle = .fullScreen
        present(plantInfoVC, animated: false)
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
    
    // MARK: - Constraints
    
    private func setConstraints() {
        // Enable autolayout for every view
        for view in autoLayoutViews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Activate constraints
        NSLayoutConstraint.activate([
            // Menu button
            menuButton.widthAnchor.constraint(equalToConstant: 50),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingConstant / 2),
            menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant - 10),
            
            // Shopping cart button
            shoppingCartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingConstant / 2),
            shoppingCartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -smallerSpacingConstant),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: shoppingCartButton.bottomAnchor, constant: spacingConstant / 2),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: spacingConstant),
            
            // Category scroll view
            categoryScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacingConstant),
            categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Plant scroll view container
            plantScrollViewContainer.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: spacingConstant / 2),
            plantScrollViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plantScrollViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Plant scroll view
            plantScrollView.topAnchor.constraint(equalTo: plantScrollViewContainer.topAnchor),
            plantScrollView.bottomAnchor.constraint(equalTo: plantScrollViewContainer.bottomAnchor),
            plantScrollView.leadingAnchor.constraint(equalTo: plantScrollViewContainer.leadingAnchor, constant: spacingConstant),
            plantScrollView.widthAnchor.constraint(equalToConstant: PlantCardView.cardWidth + smallerSpacingConstant),
            
            // Descrtiption label
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: plantScrollView.bottomAnchor, multiplier: 1),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacingConstant),
            
            // Description body label
            descriptionBodyLabel.topAnchor.constraint(equalToSystemSpacingBelow: descriptionLabel.bottomAnchor, multiplier: 1),
            descriptionBodyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant),
            descriptionBodyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacingConstant)
        ])
    }
    
}

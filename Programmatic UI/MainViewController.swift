//
//  MainViewController.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/2/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate, CategoryScrollViewDelegate {

    let menuButton = UIButton()
    let shoppingCartButton = UIButton()
    let titleLabel = UILabel()
    let categoryScrollView = CategoryScrollView()
    let plantScrollView = PlantScrollView()
    let plantScrollViewContainer = UIView()
    let descriptionLabel = UILabel()
    let descriptionBodyLabel = UILabel()
    let nothingFoundLabel = UILabel()
    
    // Used to animate the description change of the current plant card being displayed
    var pageIndexOfPlantScrollView = 0
    
    var selectedCategory: PlantCategory = .top
    
    var visiblePlants = [Plant]()
    
    let allPlants = [
        Plant(name: "Aloe Vera", price: 25, category: .outdoor, sizes: [.small], image: UIImage(named: "aloe-shadow")!, description: "Aloe vera is a succulent plant species of the genus Aloe. Its medicinal uses and air purifying ability make it the plant that you shouldn't live without."),
        Plant(name: "Monstera Deliciosa", price: 40, category: .indoor, sizes: [.large], image: UIImage(named: "monstera-deliciosa-left")!, description: "Also known as a split leaf philodendron, this easy-to-grow houseplant can get huge and live for many years, and it looks great with many different interior styles."),
        Plant(name: "Ficus", price: 30, category: .indoor, sizes: [.small], image: UIImage(named: "ficus-shadow")!, description: "Ficus trees are a common plant in the home and office, mainly because they look like a typical tree with a single trunk and a spreading canopy."),
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        
        // Set up views
        setupMenuButton()
        setupShoppingCartButton()
        setupTitleLabel()
        setupCategoryScrollView()
        setupPlantScrollView()
        setupDescriptionLabel()
        setupDescriptionBodyLabel()
    }
    
    // MARK: - Set Up Views
    
    func setupMenuButton() {
        menuButton.setImage(UIImage(named: "Menu"), for: .normal)

        view.addSubview(menuButton)
        
        // Set constraints
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingConstant / 2).isActive = true
        menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant - 10).isActive = true
    }
    
    func setupShoppingCartButton() {
        shoppingCartButton.setImage(UIImage(systemName: "cart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        shoppingCartButton.tintColor = .label
        shoppingCartButton.backgroundColor = .secondarySystemFill
        shoppingCartButton.layer.cornerRadius = 25
        shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTouchDown), for: .touchDown)
        shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTouchUp), for: .touchUpInside)
        shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTouchUp), for: .touchDragExit)
        
        view.addSubview(shoppingCartButton)
        
        // Set constraints
        shoppingCartButton.translatesAutoresizingMaskIntoConstraints = false
        shoppingCartButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shoppingCartButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shoppingCartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingConstant / 2).isActive = true
        shoppingCartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -smallerSpacingConstant).isActive = true
    }
    
    func setupTitleLabel() {
        titleLabel.text = "Top Picks"
        titleLabel.textColor = .label
        titleLabel.font = getScaledFont(for: Font.regular, size: .title)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        view.addSubview(titleLabel)
        
        // Set constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: shoppingCartButton.bottomAnchor, constant: spacingConstant / 2).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: spacingConstant).isActive = true
    }
    
    func setupCategoryScrollView() {
        view.addSubview(categoryScrollView)
        categoryScrollView.categoryDelegate = self
        
        // Set constraints
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false
        categoryScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacingConstant).isActive = true
        categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
        
    func setupPlantScrollView() {
        // Set up container
        view.addSubview(plantScrollViewContainer)
        
        // Set constraints
        plantScrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        plantScrollViewContainer.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: spacingConstant / 2).isActive = true
        plantScrollViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        plantScrollViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Set up plant scroll view
        visiblePlants = filteredPlants(fromCategory: .top)
        plantScrollView.setPlants(visiblePlants)
        
        plantScrollView.delegate = self
        
        // Enable paging
        plantScrollView.isPagingEnabled = true
        plantScrollView.clipsToBounds = false
        plantScrollViewContainer.addGestureRecognizer(plantScrollView.panGestureRecognizer)

        plantScrollViewContainer.addSubview(plantScrollView)
        
        // Set constraints
        plantScrollView.translatesAutoresizingMaskIntoConstraints = false
        plantScrollView.topAnchor.constraint(equalTo: plantScrollViewContainer.topAnchor).isActive = true
        plantScrollView.bottomAnchor.constraint(equalTo: plantScrollViewContainer.bottomAnchor).isActive = true
        plantScrollView.leadingAnchor.constraint(equalTo: plantScrollViewContainer.leadingAnchor, constant: spacingConstant).isActive = true
        plantScrollView.widthAnchor.constraint(equalToConstant: PlantCardView.cardWidth + smallerSpacingConstant).isActive = true
        
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.text = "Description"
        descriptionLabel.textColor = .label
        descriptionLabel.font = getScaledFont(for: Font.regular, size: .headline)
        
        view.addSubview(descriptionLabel)
        
        // Add constraints
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: plantScrollView.bottomAnchor, multiplier: 1).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacingConstant).isActive = true
    }
    
    func setupDescriptionBodyLabel() {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let attributedString = NSMutableAttributedString(string: visiblePlants[0].description, attributes: [.paragraphStyle: paragraphStyle])
        
        descriptionBodyLabel.attributedText = attributedString
        descriptionBodyLabel.textColor = .secondaryLabel
        descriptionBodyLabel.font = getScaledFont(for: Font.regular, size: .body)
        descriptionBodyLabel.numberOfLines = 0
        
        view.addSubview(descriptionBodyLabel)
        
        // Add constraints
        descriptionBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionBodyLabel.topAnchor.constraint(equalToSystemSpacingBelow: descriptionLabel.bottomAnchor, multiplier: 1).isActive = true
        descriptionBodyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingConstant).isActive = true
        descriptionBodyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacingConstant).isActive = true
    }
    
    func showNothingFoundLabel() {
        nothingFoundLabel.text = "Nothing found."
        nothingFoundLabel.textColor = .secondaryLabel
        nothingFoundLabel.font = getScaledFont(for: .bold, size: .price)
        
        view.addSubview(nothingFoundLabel)
        
        // Set constraints
        nothingFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        nothingFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nothingFoundLabel.centerYAnchor.constraint(equalTo: plantScrollView.topAnchor, constant: PlantCardView.cardHeight / 2).isActive = true
        
        descriptionLabel.isHidden = true
        descriptionBodyLabel.isHidden = true
    }
    
    func hideNothingFoundLabel() {
        nothingFoundLabel.removeFromSuperview()
        descriptionLabel.isHidden = false
        descriptionBodyLabel.isHidden = false
    }
    
    func setNewDescription(index: Int) {
        let attributes = self.descriptionBodyLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        let attributedString = NSAttributedString(string: visiblePlants[index].description, attributes: attributes)
            descriptionBodyLabel.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.descriptionBodyLabel.layer.opacity = 0
            }) { (completed) in
                self.descriptionBodyLabel.attributedText = attributedString
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.descriptionBodyLabel.layer.opacity = 1
                }, completion: nil)
            }
    }
    
    // MARK: - Actions
    
    @objc func shoppingCartButtonTouchDown() {
        UIView.animate(withDuration: 0.1, animations: {
            self.shoppingCartButton.transform = self.shoppingCartButton.transform.scaledBy(x: 1.3, y: 1.3)
        })
    }
    
    @objc func shoppingCartButtonTouchUp() {
        UIView.animate(withDuration: 0.2, animations: {
            self.shoppingCartButton.transform = CGAffineTransform.identity
        })
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
    
    func filteredPlants(fromCategory category: PlantCategory) -> [Plant]{
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
    
}

//
//  FromMainVCToPlantInfoVC.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 2/1/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class TransitionBetweenPlantInfoVCAndMainVC: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var plantInfoVC: PlantInfoViewController!
    private var mainVC: MainViewController!
    private var originalCardView: PlantCardView!
    private var cardView: PlantCardView!
    private var backgroundViewCopy = UIView()
    private var bottomBackgroundViewCopy = UIView()
    
    private var presenting: Bool!
    
    private let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Set variables
        let containerView = transitionContext.containerView
        if let toVC = transitionContext.viewController(forKey: .to) as? PlantInfoViewController {
            presenting = true
            plantInfoVC = toVC
            mainVC = (transitionContext.viewController(forKey: .from) as? UINavigationController)?.viewControllers.first as? MainViewController
        } else if let fromVC = transitionContext.viewController(forKey: .from) as? PlantInfoViewController {
            presenting = false
            plantInfoVC = fromVC
            mainVC = (transitionContext.viewController(forKey: .to) as? UINavigationController)?.viewControllers.first as? MainViewController
        } else {
            fatalError("Can't find PlantInfoViewController")
        }
        if let selectedCardView = mainVC.selectedPlantCardView {
            originalCardView = selectedCardView
        } else {
            fatalError("Can't find mainVC.selectedCardView")
        }
        if mainVC == nil {
            fatalError("Can't find MainViewController")
        }
        
        // Setup
        if presenting {
            // Create copy of plant card view
            cardView = PlantCardView(from: originalCardView.plant)
            containerView.addSubview(cardView)
            
            // Add plantInfoVC to container view and update its subviews' frames
            containerView.addSubview(plantInfoVC.view)
            plantInfoVC.view.layoutIfNeeded()
            
            // Set card view's frame
            cardView.translatesAutoresizingMaskIntoConstraints = true
            cardView.frame = originalCardView.superview!.convert(originalCardView.frame, to: containerView.coordinateSpace)
            cardView.layoutIfNeeded()
            
            // Create copy of plant card view's background view
            backgroundViewCopy.frame = cardView.backgroundView.frame
            backgroundViewCopy.backgroundColor = cardView.backgroundView.backgroundColor
            backgroundViewCopy.layer.cornerRadius = cardView.backgroundView.layer.cornerRadius
            cardView.insertSubview(backgroundViewCopy, at: 0)
            cardView.backgroundView.isHidden = true
            
            // Create copy of bottomBackgroundView
            bottomBackgroundViewCopy.frame = convertFrameOf(plantInfoVC.bottomBackgroundView)
            bottomBackgroundViewCopy.frame = bottomBackgroundViewCopy.frame.offsetBy(dx: 0, dy: mainVC.descriptionLabel.frame.origin.y - plantInfoVC.bottomBackgroundView.frame.origin.y)
            bottomBackgroundViewCopy.backgroundColor = plantInfoVC.bottomBackgroundView.backgroundColor
            bottomBackgroundViewCopy.layer.cornerRadius = plantInfoVC.bottomBackgroundView.layer.cornerRadius
            cardView.insertSubview(bottomBackgroundViewCopy, belowSubview: cardView.plantImage)
        }
        
        // Hide all subviews in plant info VC
        for subview in plantInfoVC.view.subviews {
            subview.layer.opacity = 0
        }
        // Hide original card view
        originalCardView.layer.opacity = 0
        
        // Perform animations
        if presenting {
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                self.presentMainViews()
            })
            
            UIView.animate(withDuration: duration, delay: duration / 2, options: .curveEaseInOut, animations: {
                self.presentFadeInViews()
            }) { (completed) in
                self.completePresentation()
                transitionContext.completeTransition(completed)
            }
        } else {
            plantInfoVC.fromLabel.layer.opacity = 1
            plantInfoVC.priceLabel.layer.opacity = 1
            plantInfoVC.sizesLabel.layer.opacity = 1
            plantInfoVC.sizesInfoLabel.layer.opacity = 1
            
            UIView.animate(withDuration: duration / 2, delay: 0, options: .curveEaseInOut, animations: {
                self.dismissFadeInViews()
            })
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                self.dismissMainViews()
            }) { (completed) in
                self.completeDismissal()
                transitionContext.completeTransition(completed)
            }
        }
    }
    
    private func presentMainViews() {
        bottomBackgroundViewCopy.transform = .init(translationX: 0, y: plantInfoVC.bottomBackgroundView.frame.origin.y - mainVC.descriptionLabel.frame.origin.y)
        
        backgroundViewCopy.frame = convertFrameOf(plantInfoVC.backgroundView)
        backgroundViewCopy.layer.cornerRadius = plantInfoVC.backgroundView.layer.cornerRadius
        
        cardView.fromLabel.layer.opacity = 0
        cardView.priceLabel.layer.opacity = 0
        cardView.requirementsBar.layer.opacity = 0
        translateWithBackground(cardView.fromLabel)
        translateWithBackground(cardView.priceLabel)
        translateWithBackground(cardView.requirementsBar)
                
        translateAndScale(from: cardView.nameLabel, to: plantInfoVC.nameLabel)
        translateAndScale(from: cardView.categoryLabel, to: plantInfoVC.categoryLabel)
        translateAndScale(from: cardView.plantImage, to: plantInfoVC.plantImageView)
        translateAndScale(from: cardView.addToCartButton, to: plantInfoVC.addToCartButton)
    }
    
    private func completePresentation() {
        for subview in plantInfoVC.view.subviews {
            subview.layer.opacity = 1
        }
        originalCardView.layer.opacity = 1
        
        // Possibly temporary
        cardView.isHidden = true
    }
    
    private func dismissMainViews() {
        cardView.isHidden = false
        
        bottomBackgroundViewCopy.transform = .identity
        
        backgroundViewCopy.frame = cardView.backgroundView.frame
        backgroundViewCopy.layer.cornerRadius = cardView.backgroundView.layer.cornerRadius
        
        cardView.fromLabel.layer.opacity = 1
        cardView.priceLabel.layer.opacity = 1
                
        cardView.fromLabel.transform = .identity
        cardView.priceLabel.transform = .identity
        cardView.requirementsBar.transform = .identity
        
        cardView.requirementsBar.layer.opacity = 1
        
        cardView.nameLabel.transform = .identity
        cardView.categoryLabel.transform = .identity
        cardView.plantImage.transform = .identity
        cardView.addToCartButton.transform = .identity
    }
    
    private func completeDismissal() {
        originalCardView.layer.opacity = 1
    }
    
    private func presentFadeInViews() {
        plantInfoVC.fromLabel.layer.opacity = 1
        plantInfoVC.priceLabel.layer.opacity = 1
        plantInfoVC.sizesLabel.layer.opacity = 1
        plantInfoVC.sizesInfoLabel.layer.opacity = 1
    }
    
    private func dismissFadeInViews() {
        plantInfoVC.fromLabel.layer.opacity = 0
        plantInfoVC.priceLabel.layer.opacity = 0
        plantInfoVC.sizesLabel.layer.opacity = 0
        plantInfoVC.sizesInfoLabel.layer.opacity = 0
    }
    
    private func convertFrameOf(_ view: UIView) -> CGRect {
        return plantInfoVC.view.convert(view.frame, to: cardView)
    }
    
    private func convertCenterOf(_ view: UIView) -> CGPoint {
        return plantInfoVC.view.convert(view.center, to: cardView)
    }
    
    private func translateAndScale(from fromView: UIView, to toView: UIView) {
        let translate = (x: convertCenterOf(toView).x - fromView.center.x, y: convertCenterOf(toView).y - fromView.center.y)
        let scale = toView.bounds.width / fromView.bounds.width
        fromView.transform = CGAffineTransform(translationX: translate.x, y: translate.y).scaledBy(x: scale, y: scale)
    }
    
    private func translateWithBackground(_ view: UIView) {
        let oldViewCenter = view.center
        let oldBackgroundViewCenter = CGPoint(x: originalCardView.backgroundView.bounds.midX, y: originalCardView.backgroundView.bounds.midY)
        
        let oldCenterDistanceX = oldViewCenter.x - oldBackgroundViewCenter.x
        let oldCenterDistanceY = oldViewCenter.y - oldBackgroundViewCenter.y
        
        let scaleX = plantInfoVC.backgroundView.bounds.width / originalCardView.backgroundView.bounds.width
        let scaleY = plantInfoVC.backgroundView.bounds.height / originalCardView.backgroundView.bounds.height
        
        let newCenterDistanceX = oldCenterDistanceX * scaleX
        let newCenterDistanceY = oldCenterDistanceY * scaleY
        let newBackgroundViewCenter = convertCenterOf(plantInfoVC.backgroundView)
        
        let newViewCenter = CGPoint(x: newBackgroundViewCenter.x + newCenterDistanceX, y: newBackgroundViewCenter.y + newCenterDistanceY)
        
        let translateX = newViewCenter.x - oldViewCenter.x
        let translateY = newViewCenter.y - oldViewCenter.y
        
        view.transform = CGAffineTransform(translationX: translateX, y: translateY)
    }
    
}

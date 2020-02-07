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
    private var cardView: PlantCardView!
    
    private var presenting: Bool!
    
    private let duration: TimeInterval = 0.5
    
    private var initialFrames = [UIView: CGRect]()
    private var initialCornerRadiuses = [UIView: CGFloat]()
    private var initialOpacities = [UIView: Float]()
    
    private var phaseOneViews = [UIView]()
    private var phaseTwoViews = [UIView]()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Set variables
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
        if let selectedCardView = mainVC.selectedPlantCardView { cardView = selectedCardView } else {
            fatalError("Can't find mainVC.selectedCardView")
        }
        if mainVC == nil {
            fatalError("Can't find MainViewController")
        }
        
        // Add plantInfoVC to container view and update its subviews' frames
        transitionContext.containerView.addSubview(plantInfoVC.view)
        plantInfoVC.view.layoutIfNeeded()
        
        // Remove any animated views
        phaseOneViews.removeAll()
        phaseTwoViews.removeAll()
        
        // If presenting, move views to final position
        if presenting {
            finalPositionPhaseOne()
            finalPositionPhaseTwo()
        }
        
        // Animate phase one
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            if self.presenting {
                // Animate views to starting position
                self.startingPositionPhaseOne()
            } else {
                // Animate views to final position
                self.finalPositionPhaseOne()
            }
        }) { (completed) in
            self.cardView.addToCartButton.layer.opacity = 1
            if !self.presenting {
                transitionContext.completeTransition(completed)
            }
        }
        
        let phaseTwoDuration = presenting ? duration : duration / 2
        let phaseTwoDelay = presenting ? duration / 2 : 0
        
        // Animate phase two
        UIView.animate(withDuration: phaseTwoDuration, delay: phaseTwoDelay, options: .curveEaseOut, animations: {
            if self.presenting {
                // Animate views to starting position
                self.startingPositionPhaseTwo()
            } else {
                // Animate views to final position
                self.finalPositionPhaseTwo()
            }
        }) { (completed) in
            if self.presenting {
                transitionContext.completeTransition(completed)
            }
        }
    }
    
    // Move views to final position for phase one
    func finalPositionPhaseOne() {
        phaseOneViews += [
            plantInfoVC.nameLabel,
            plantInfoVC.categoryLabel,
            plantInfoVC.addToCartButton,
            plantInfoVC.backgroundView,
            plantInfoVC.plantImageView,
            plantInfoVC.descriptionBodyLabel,
            plantInfoVC.allToKnowLabel,
            plantInfoVC.detailsLabel,
            plantInfoVC.detailsBodyLabel,
            plantInfoVC.bottomBackgroundView,
            cardView.nameLabel,
            cardView.categoryLabel,
            cardView.addToCartButton,
            cardView.backgroundView,
            cardView.plantImage,
            cardView.fromLabel,
            mainVC.descriptionLabel,
            mainVC.descriptionBodyLabel
        ]
        
        translateAndScale(from: plantInfoVC.nameLabel, to: cardView.nameLabel)
        translateAndScale(from: plantInfoVC.categoryLabel, to: cardView.categoryLabel)
        translateAndScale(from: plantInfoVC.addToCartButton, to: cardView.addToCartButton)
        
        changeFrameAndCornerRadius(from: plantInfoVC.backgroundView, to: cardView.backgroundView)
        changeFrameAndCornerRadius(from: plantInfoVC.plantImageView, to: cardView.plantImage)
        
        let descriptionTranslate = translateAndScale(from: plantInfoVC.descriptionBodyLabel, to: mainVC.descriptionBodyLabel)
        translate(plantInfoVC.allToKnowLabel, by: descriptionTranslate.y)
        translate(plantInfoVC.detailsLabel, by: descriptionTranslate.y)
        translate(plantInfoVC.detailsBodyLabel, by: descriptionTranslate.y)
        
        fade(view: plantInfoVC.detailsLabel)
        fade(view: plantInfoVC.detailsBodyLabel)
        fade(view: cardView.fromLabel)
        
        crossDissolve(from: plantInfoVC.allToKnowLabel, to: mainVC.descriptionLabel)
        
        initialFrames[plantInfoVC.bottomBackgroundView] = plantInfoVC.bottomBackgroundView.frame
        plantInfoVC.bottomBackgroundView.frame.origin.y = mainVC.plantScrollViewContainer.frame.maxY
        
        cardView.addToCartButton.layer.opacity = 0
    }
    
    // Move views to final position for phase two
    func finalPositionPhaseTwo() {
        phaseTwoViews += [
            plantInfoVC.fromLabel,
            plantInfoVC.priceLabel,
            plantInfoVC.sizesLabel,
            plantInfoVC.sizesInfoLabel
        ]
        
        fade(view: plantInfoVC.fromLabel)
        fade(view: plantInfoVC.priceLabel)
        fade(view: plantInfoVC.sizesLabel)
        fade(view: plantInfoVC.sizesInfoLabel)
    }
    
    private func startingPositionPhaseOne() {
        for view in phaseOneViews {
            resetView(view)
        }
    }
    
    private func startingPositionPhaseTwo() {
        for view in phaseTwoViews {
            resetView(view)
        }
    }
    
    private enum Axis { case x; case y }

    private func translate(from initialView: UIView, to newView: UIView, axis: Axis? = nil) {
        let newViewCenter = newView.superview!.convert(newView.center, to: initialView.superview!.coordinateSpace)
        let translateX = axis != .some(.y) ? newViewCenter.x - initialView.center.x : 0
        let translateY = axis != .some(.x) ? newViewCenter.y - initialView.center.y : 0
        
        initialView.transform = .init(translationX: translateX, y: translateY)
    }
    
    private func translate(_ view: UIView, by translation: CGFloat, axis: Axis? = nil) {
        view.transform = .init(translationX: 0, y: translation)
    }
    
    @discardableResult private func translateAndScale(from initialView: UIView, to newView: UIView, axis: Axis? = nil) -> (x: CGFloat, y: CGFloat) {
        let newViewCenter = newView.superview!.convert(newView.center, to: initialView.superview!.coordinateSpace)
        let translateX = axis != .some(.y) ? newViewCenter.x - initialView.center.x : 0
        let translateY = axis != .some(.x) ? newViewCenter.y - initialView.center.y : 0
        
        let scaleX = newView.bounds.width / initialView.bounds.width
        let scaleY = newView.bounds.height / initialView.bounds.height
        
        initialView.transform = CGAffineTransform(translationX: translateX, y: translateY).scaledBy(x: scaleX, y: scaleY)
        
        return (translateX, translateY)
    }
    
    private func changeFrameAndCornerRadius(from initialView: UIView, to newView: UIView) {
        initialFrames[initialView] = initialView.frame
        initialCornerRadiuses[initialView] = initialView.layer.cornerRadius
        let newViewFrame = newView.superview!.convert(newView.frame, to: initialView.superview!.coordinateSpace)
        initialView.layer.cornerRadius = newView.layer.cornerRadius
        initialView.frame = newViewFrame
    }
    
    private func fade(view: UIView) {
        initialOpacities[view] = view.layer.opacity
        view.layer.opacity = 0
    }
    
    private func fade2(view: UIView) {
        initialOpacities[view] = view.layer.opacity
        view.layer.opacity = 0
    }
    
    private func crossDissolve(from initialView: UIView, to newView: UIView) {
        initialOpacities[initialView] = 1
        initialOpacities[newView] = 0
        initialView.layer.opacity = 0
        newView.layer.opacity = 1
    }
    
    private func resetView(_ view: UIView) {
        view.layer.cornerRadius = initialCornerRadiuses[view] ?? view.layer.cornerRadius
        view.layer.opacity = initialOpacities[view] ?? view.layer.opacity
        
        if !view.transform.isIdentity {
            view.transform = .identity
        } else {
            view.frame = initialFrames[view] ?? view.frame
        }
    }
    
}

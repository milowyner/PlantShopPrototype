//
//  FromMainVCToPlantInfoVC.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 2/1/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class TransitionBetweenPlantInfoVCAndMainVC: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var containerView: UIView!
    private var plantInfoVC: PlantInfoViewController!
    private var mainVC: MainViewController!
    private var originalCardView: PlantCardView!
    private var cardView: PlantCardView!
    
    private var backgroundViewCopy = UIView()
    private var bottomBackgroundViewCopy = UIView()
    
    private var descriptionLabelCopy = UILabel()
    private var descriptionBodyLabelCopy = UILabel()
    
    private var slidingLabels = [UILabel]()
    
    private var maskingBackgroundView = UIView()
    
    private var presenting: Bool!
    private let duration: TimeInterval = 0.5
    private var slidingDistance: CGFloat!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Set variables
        containerView = transitionContext.containerView
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
            
            // Masking
            maskingBackgroundView.frame = cardView.convert(cardView.backgroundView.frame, to: plantInfoVC.view.coordinateSpace)
            maskingBackgroundView.backgroundColor = .gray
            maskingBackgroundView.layer.cornerRadius = backgroundViewCopy.layer.cornerRadius
            containerView.addSubview(maskingBackgroundView)
            plantInfoVC.view.mask = maskingBackgroundView
            
            // Set sliding distance of bottom background view
            slidingDistance = mainVC.descriptionLabel.convertOriginTo(coordinateSpaceOf: plantInfoVC.bottomBackgroundView).y - plantInfoVC.bottomBackgroundView.frame.origin.y
            
            // Create copy of bottomBackgroundView
            bottomBackgroundViewCopy.backgroundColor = plantInfoVC.bottomBackgroundView.backgroundColor
            bottomBackgroundViewCopy.layer.cornerRadius = plantInfoVC.bottomBackgroundView.layer.cornerRadius
            
            cardView.insertSubview(bottomBackgroundViewCopy, belowSubview: cardView.plantImage)
            bottomBackgroundViewCopy.frame = plantInfoVC.bottomBackgroundView.convertFrameTo(coordinateSpaceOf: cardView.backgroundView)
            bottomBackgroundViewCopy.frame.origin.y = mainVC.descriptionLabel.convertOriginTo(coordinateSpaceOf: bottomBackgroundViewCopy).y
            
            // Create copy of mainVC description labels
            containerView.addSubview(descriptionLabelCopy)
            copyLabel(to: descriptionLabelCopy, from: mainVC.descriptionLabel)
            containerView.addSubview(descriptionBodyLabelCopy)
            copyLabel(to: descriptionBodyLabelCopy, from: mainVC.descriptionBodyLabel)
            
            // Create copy of plantInfoVC bottom labels
            slidingLabels = [
                plantInfoVC.allToKnowLabel,
                plantInfoVC.descriptionBodyLabel,
                plantInfoVC.detailsLabel,
                plantInfoVC.detailsBodyLabel
                ].map { (labelCounterpart) -> UILabel in
                    let newLabel = UILabel()
                    containerView.addSubview(newLabel)
                    copyLabel(to: newLabel, from: labelCounterpart)
                    return newLabel
            }
            
            // Set up sliding labels
            for label in slidingLabels {
                label.transform = .init(translationX: 0, y: slidingDistance)
                label.layer.opacity = 0
            }
        }
        
        // Hide all subviews in plant info VC
        for subview in plantInfoVC.view.subviews {
            subview.layer.opacity = 0
        }
        // Unhide top buttons to be masked
        plantInfoVC.shoppingCartButton.layer.opacity = 1
        plantInfoVC.backButton.layer.opacity = 1
        
        // Hide original card view
        originalCardView.layer.opacity = 0
        
        // Perform animations
        if presenting {
            UIView.animate(withDuration: duration * 2 / 3, delay: 0, options: .curveEaseInOut, animations: {
                self.cardView.fromLabel.layer.opacity = 0
                self.cardView.priceLabel.layer.opacity = 0
                self.descriptionLabelCopy.layer.opacity = 0
                self.descriptionBodyLabelCopy.layer.opacity = 0
            })
            
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
            // Set fade in labels to start at full opacity
            plantInfoVC.fromLabel.layer.opacity = 1
            plantInfoVC.priceLabel.layer.opacity = 1
            plantInfoVC.sizesLabel.layer.opacity = 1
            plantInfoVC.sizesInfoLabel.layer.opacity = 1
            for label in slidingLabels {
                label.layer.opacity = 1
            }
            
            // Set masking background view
            plantInfoVC.view.mask = maskingBackgroundView
            
            UIView.animate(withDuration: duration * 2 / 3, delay: duration - duration * 2 / 3, options: .curveEaseInOut, animations: {
                self.cardView.fromLabel.layer.opacity = 1
                self.cardView.priceLabel.layer.opacity = 1
                self.descriptionLabelCopy.layer.opacity = 1
                self.descriptionBodyLabelCopy.layer.opacity = 1
            })
            
            UIView.animate(withDuration: duration, delay: duration - duration * 2 / 3, options: .curveEaseInOut, animations: {
                self.descriptionLabelCopy.layer.opacity = 1
                self.descriptionBodyLabelCopy.layer.opacity = 1
            })
            
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
        bottomBackgroundViewCopy.transform = .init(translationX: 0, y: -slidingDistance)
        
        backgroundViewCopy.frame = plantInfoVC.backgroundView.convertFrameTo(coordinateSpaceOf: backgroundViewCopy)
        backgroundViewCopy.layer.cornerRadius = plantInfoVC.backgroundView.layer.cornerRadius
        
        maskingBackgroundView.frame = plantInfoVC.backgroundView.frame
        maskingBackgroundView.layer.cornerRadius = plantInfoVC.backgroundView.layer.cornerRadius
        
        cardView.requirementsBar.layer.opacity = 0
        translateWithBackground(cardView.fromLabel)
        translateWithBackground(cardView.priceLabel)
        translateWithBackground(cardView.requirementsBar)
        
        translateAndScale(from: cardView.nameLabel, to: plantInfoVC.nameLabel)
        translateAndScale(from: cardView.categoryLabel, to: plantInfoVC.categoryLabel)
        translateAndScale(from: cardView.plantImage, to: plantInfoVC.plantImageView)
        translateAndScale(from: cardView.addToCartButton, to: plantInfoVC.addToCartButton)
        
        for label in slidingLabels {
            label.transform = .identity
        }
    }
    
    private func completePresentation() {
        for subview in plantInfoVC.view.subviews {
            subview.layer.opacity = 1
        }
        originalCardView.layer.opacity = 1
        
        for label in slidingLabels {
            label.layer.opacity = 0
        }
        
        // Remove mask
        plantInfoVC.view.mask = nil
        
        // Possibly temporary
        cardView.isHidden = true
    }
    
    private func dismissMainViews() {
        cardView.isHidden = false
        
        bottomBackgroundViewCopy.transform = .identity
        
        backgroundViewCopy.frame = cardView.backgroundView.frame
        backgroundViewCopy.layer.cornerRadius = cardView.backgroundView.layer.cornerRadius
        
        maskingBackgroundView.frame = cardView.convert(cardView.backgroundView.frame, to: plantInfoVC.view.coordinateSpace)
        maskingBackgroundView.layer.cornerRadius = cardView.backgroundView.layer.cornerRadius
        
        cardView.fromLabel.transform = .identity
        cardView.priceLabel.transform = .identity
        cardView.requirementsBar.transform = .identity
        
        cardView.requirementsBar.layer.opacity = 1
        
        cardView.nameLabel.transform = .identity
        cardView.categoryLabel.transform = .identity
        cardView.plantImage.transform = .identity
        cardView.addToCartButton.transform = .identity
        
        for label in slidingLabels {
            label.transform = CGAffineTransform.identity.translatedBy(x: 0, y: slidingDistance)
        }
    }
    
    private func completeDismissal() {
        originalCardView.layer.opacity = 1
    }
    
    private func presentFadeInViews() {
        plantInfoVC.fromLabel.layer.opacity = 1
        plantInfoVC.priceLabel.layer.opacity = 1
        plantInfoVC.sizesLabel.layer.opacity = 1
        plantInfoVC.sizesInfoLabel.layer.opacity = 1
        
        for label in slidingLabels {
            label.layer.opacity = 1
        }
    }
    
    private func dismissFadeInViews() {
        plantInfoVC.fromLabel.layer.opacity = 0
        plantInfoVC.priceLabel.layer.opacity = 0
        plantInfoVC.sizesLabel.layer.opacity = 0
        plantInfoVC.sizesInfoLabel.layer.opacity = 0
        
        for label in slidingLabels {
            label.layer.opacity = 0
        }
    }
    
    private func translateAndScale(from fromView: UIView, to toView: UIView) {
        let translate = (
            x: toView.convertCenterTo(coordinateSpaceOf: fromView).x - fromView.center.x,
            y: toView.convertCenterTo(coordinateSpaceOf: fromView).y - fromView.center.y
        )
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
        let newBackgroundViewCenter = plantInfoVC.backgroundView.convertCenterTo(coordinateSpaceOf: view)
        
        let newViewCenter = CGPoint(x: newBackgroundViewCenter.x + newCenterDistanceX, y: newBackgroundViewCenter.y + newCenterDistanceY)
        
        let translateX = newViewCenter.x - oldViewCenter.x
        let translateY = newViewCenter.y - oldViewCenter.y
        
        view.transform = CGAffineTransform(translationX: translateX, y: translateY)
    }
    
    private func copyLabel(to: UILabel, from: UILabel) {
        to.textColor = from.textColor
        to.font = from.font
        to.numberOfLines = from.numberOfLines
        if to.attributedText != nil {
            to.text = from.text
        } else {
            to.attributedText = from.attributedText
        }
        to.frame = from.convertFrameTo(coordinateSpaceOf: to)
    }
    
}

extension UIView {
    func convertFrameTo(coordinateSpaceOf view: UIView) -> CGRect {
        return self.superview!.convert(self.frame, to: view.superview!.coordinateSpace)
    }
    
    func convertOriginTo(coordinateSpaceOf view: UIView) -> CGPoint {
        return self.superview!.convert(self.frame.origin, to: view.superview!.coordinateSpace)
    }
    
    func convertCenterTo(coordinateSpaceOf view: UIView) -> CGPoint {
        return self.superview!.convert(self.center, to: view.superview!.coordinateSpace)
    }
}

//
//  FromMainVCToPlantInfoVC.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 2/1/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class TransitionBetweenPlantInfoVCAndMainVC: NSObject, UIViewControllerAnimatedTransitioning {
        
    private let duration: TimeInterval = 0.5
    
    private var initialFrames = [UIView: CGRect]()
    private var initialCornerRadiuses = [UIView: CGFloat]()
    
    private var animatedViews = [UIView]()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        if let plantInfoVC = toVC as? PlantInfoViewController {
            setUpAnimation(presentingPlantInfoVC: true, plantInfoVC: plantInfoVC, otherVC: fromVC, transitionContext: transitionContext)
        } else if let plantInfoVC = fromVC as? PlantInfoViewController {
            setUpAnimation(presentingPlantInfoVC: false, plantInfoVC: plantInfoVC, otherVC: toVC, transitionContext: transitionContext)
        }
    }
    
    private func setUpAnimation(presentingPlantInfoVC: Bool, plantInfoVC: PlantInfoViewController, otherVC: UIViewController?, transitionContext:  UIViewControllerContextTransitioning) {
        
        // Set mainVC and cardView
        guard let mainVC = (otherVC as? UINavigationController)?.viewControllers.first as? MainViewController else {
            print("Can't find MainViewController")
            return transitionContext.completeTransition(true)
        }
        guard let cardView = mainVC.selectedPlantCardView else { fatalError("No card view selected") }
        
        // Here's the main function to animate views in different ways
        func moveViews() {
            animatedViews.removeAll()
            translateAndScale(from: plantInfoVC.nameLabel, to: cardView.nameLabel)
            translateAndScale(from: plantInfoVC.priceLabel, to: cardView.priceLabel)
            changeFrameAndCornerRadius(from: plantInfoVC.backgroundView, to: cardView.backgroundView)
            changeFrameAndCornerRadius(from: plantInfoVC.plantImageView, to: cardView.plantImage)
            animatedViews.append(plantInfoVC.bottomBackgroundView)
            initialFrames[plantInfoVC.bottomBackgroundView] = plantInfoVC.bottomBackgroundView.frame
            plantInfoVC.bottomBackgroundView.frame.origin.y = plantInfoVC.detailsLabel.frame.origin.y - 20
        }
        
        // Add plantInfoVC to container view and update its subviews' frames
        transitionContext.containerView.addSubview(plantInfoVC.view)
        plantInfoVC.view.layoutIfNeeded()
        
        if presentingPlantInfoVC {
            moveViews()
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            if presentingPlantInfoVC {
                for view in self.animatedViews {
                    self.resetView(view)
                }
            } else {
                moveViews()
            }
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
    
    private func translateAndScale(from initialView: UIView, to newView: UIView) {
        animatedViews.append(initialView)
        
        let newViewCenter = newView.superview!.convert(newView.center, to: initialView.superview!.coordinateSpace)
        let translateX = newViewCenter.x - initialView.center.x
        let translateY = newViewCenter.y - initialView.center.y
        
        let scaleX = newView.bounds.width / initialView.bounds.width
        let scaleY = newView.bounds.height / initialView.bounds.height
        
        initialView.transform = CGAffineTransform.identity.translatedBy(x: translateX, y: translateY).scaledBy(x: scaleX, y: scaleY)
    }
    
    private func changeFrameAndCornerRadius(from initialView: UIView, to newView: UIView) {
        animatedViews.append(initialView)
        
        initialFrames[initialView] = initialView.frame
        initialCornerRadiuses[initialView] = initialView.layer.cornerRadius
        let newViewFrame = newView.superview!.convert(newView.frame, to: initialView.superview!.coordinateSpace)
        initialView.layer.cornerRadius = newView.layer.cornerRadius
        initialView.frame = newViewFrame
    }
    
    private func resetView(_ view: UIView) {
        if !view.transform.isIdentity {
            view.transform = .identity
        } else {
            view.frame = initialFrames[view] ?? view.frame
            view.layer.cornerRadius = initialCornerRadiuses[view] ?? view.layer.cornerRadius
        }
    }
    
}

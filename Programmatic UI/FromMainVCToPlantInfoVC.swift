//
//  FromMainVCToPlantInfoVC.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 2/1/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class FromMainVCToPlantInfoVC: NSObject, UIViewControllerAnimatedTransitioning {
        
    private let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let plantInfoVC = transitionContext.viewController(forKey: .to)! as! PlantInfoViewController
        let mainVC: MainViewController
        let cardView: PlantCardView
        let transformedViewPairs: [(UIView, UIView)]
        
        // Set mainVC
        if let fromVC = transitionContext.viewController(forKey: .from) as? MainViewController {
            mainVC = fromVC
        } else if let fromVC = transitionContext.viewController(forKey: .from) as? UINavigationController,
            let rootVC = fromVC.viewControllers[0] as? MainViewController {
            mainVC = rootVC
        } else {
            fatalError("Unknown \"from\" view controller")
        }
        // Set cardView
        cardView = mainVC.selectedPlantCardView!
        
        // Add plantInfoVC to container view and update its subviews' frames
        transitionContext.containerView.addSubview(plantInfoVC.view)
        plantInfoVC.view.layoutIfNeeded()
        
        // Clear background
        plantInfoVC.view.backgroundColor = .clear
        
        // Set up green background view
        let greenBackground = UIView()
        greenBackground.backgroundColor = cardView.backgroundView.backgroundColor
        greenBackground.frame = plantInfoVC.view.frame
        greenBackground.layer.cornerRadius = cardView.backgroundView.layer.cornerRadius *
            greenBackground.bounds.width / cardView.backgroundView.bounds.width
        
        plantInfoVC.view.insertSubview(greenBackground, at: 0)
        
        // Set view pairs to transition to/from
        transformedViewPairs = [
            (greenBackground, cardView.backgroundView),
            (plantInfoVC.nameLabel, cardView.nameLabel),
            (plantInfoVC.priceLabel, cardView.priceLabel)
        ]
                
        // Put each view in the place of the old view
        for (newView, oldView) in transformedViewPairs {
            newView.translateAndScale(to: oldView)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            // Animate each view back to the correct position
            for (view, _) in transformedViewPairs {
                view.transform = .identity
            }
        }) { (completed) in
            // Reset background view
            plantInfoVC.view.backgroundColor = greenBackground.backgroundColor
            greenBackground.removeFromSuperview()
            // Complete transition
            transitionContext.completeTransition(completed)
        }
    }
    
}

extension UIView {
    func translateAndScale(to newView: UIView) {
        let newViewCenter = newView.superview!.convert(newView.center, to: superview!.coordinateSpace)
        let translateX = newViewCenter.x - self.center.x
        let translateY = newViewCenter.y - self.center.y
        self.transform = CGAffineTransform(translationX: translateX, y: translateY)
        
        let scaleX = newView.bounds.width / self.bounds.width
        let scaleY = newView.bounds.height / self.bounds.height
        self.transform = self.transform.scaledBy(x: scaleX, y: scaleY)
    }
}

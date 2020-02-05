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
    
    private var transformedViewPairs = [(UIView, UIView)]()
    
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
        
        guard let mainVC = (otherVC as? UINavigationController)?.viewControllers.first as? MainViewController else {
            print("Can't find MainViewController")
            return transitionContext.completeTransition(true)
        }
        guard let cardView = mainVC.selectedPlantCardView else { fatalError("No card view selected") }
        
        // Add plantInfoVC to container view and update its subviews' frames
        transitionContext.containerView.addSubview(plantInfoVC.view)
        plantInfoVC.view.layoutIfNeeded()
        
        // Set view pairs to transition to/from
        transformedViewPairs = [
            (plantInfoVC.backgroundView, cardView.backgroundView),
            (plantInfoVC.nameLabel, cardView.nameLabel),
            (plantInfoVC.priceLabel, cardView.priceLabel)
        ]
        
        if presentingPlantInfoVC {
            // Transform each plantInfoVC view to its mainVC counterpart
            for (newView, oldView) in transformedViewPairs {
                newView.translateAndScale(to: oldView)
            }
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            if presentingPlantInfoVC {
                // Animate the transformation of each view back to its correct plantInfoVC position
                for (view, _) in self.transformedViewPairs {
                    view.transform = .identity
                }
            } else {
                // Animate the transformation of each plantInfoVC view to its mainVC counterpart
                for (newView, oldView) in self.transformedViewPairs {
                    newView.translateAndScale(to: oldView)
                }
            }
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
    
}

extension UIView {
    func translateAndScale(to newView: UIView, keepingAspectRatio: Bool = false) {
        let newViewCenter = newView.superview!.convert(newView.center, to: superview!.coordinateSpace)
        let translateX = newViewCenter.x - self.center.x
        let translateY = newViewCenter.y - self.center.y
        
        let scaleX: CGFloat
        let scaleY: CGFloat
        
        if keepingAspectRatio {
            let newViewAspectRatio = newView.bounds.width / newView.bounds.height
            let selfAspectRatio = self.bounds.width / self.bounds.height
            if newViewAspectRatio < selfAspectRatio {
                // Set heights equal
                scaleY = newView.bounds.height / self.bounds.height
                scaleX = scaleY
            } else {
                // Set widths equal
                scaleX = newView.bounds.width / self.bounds.width
                scaleY = scaleX
            }
        } else {
            scaleX = newView.bounds.width / self.bounds.width
            scaleY = newView.bounds.height / self.bounds.height
        }

        
        
        self.transform = CGAffineTransform.identity.translatedBy(x: translateX, y: translateY).scaledBy(x: scaleX, y: scaleY)
    }
}

//
//  TransitioningDelegate.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 2/2/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    static let shared = TransitioningDelegate()
    
    let transition = TransitionBetweenPlantInfoVCAndMainVC()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {        
        if source is MainViewController && presented is PlantInfoViewController {
            return transition
        } else {
            fatalError("Unknown transition")
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is PlantInfoViewController {
            return transition
        } else {
            fatalError("Unknown transition")
        }
    }
    
}

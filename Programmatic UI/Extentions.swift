//
//  Extensions.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/28/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    static func activateWithAutolayout(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            if let view = constraint.firstItem as? UIView {
                 view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activate(constraints)
    }
}

extension NSAttributedString {
    static func increasedLineHeight(string: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle])
    }
}

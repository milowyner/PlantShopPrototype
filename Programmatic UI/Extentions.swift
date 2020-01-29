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

extension NSDirectionalEdgeInsets {
    static let customMargins = NSDirectionalEdgeInsets(top: 20, leading: 40, bottom: 0, trailing: 30)
}

extension NSAttributedString {
    static func increasedLineHeight(string: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle])
    }
}

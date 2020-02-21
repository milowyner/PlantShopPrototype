//
//  CustomSpacing.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 2/16/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

fileprivate var safeAreaFrame: CGRect {
    return UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame
}

var spacingMultiplier: CGFloat {
    return sqrt(safeAreaFrame.width * safeAreaFrame.height) / sqrt(375 * 734)
}

var verticalSpacingMultiplier: CGFloat {
    return safeAreaFrame.height / 734
}

var horizontalSpacingMultiplier: CGFloat {
    return safeAreaFrame.width / 375
}

var verticalSpacingConstant: CGFloat {
    return 40 * verticalSpacingMultiplier
}

var horizontalSpacingConstant: CGFloat {
    return 40 * horizontalSpacingMultiplier
}

extension NSDirectionalEdgeInsets {
    static var customMargins: NSDirectionalEdgeInsets {
        let insets = NSDirectionalEdgeInsets(
            top: 20 * verticalSpacingMultiplier,
            leading: 40 * horizontalSpacingMultiplier,
            bottom: 40 * verticalSpacingMultiplier,
            trailing: 30 * horizontalSpacingMultiplier
        )
        return insets
    }
}

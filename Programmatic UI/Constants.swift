//
//  Font.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/6/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

let spacingConstant: CGFloat = 40
let smallerSpacingConstant: CGFloat = 30

enum FontName: String {
    static let regular = FontName.avertaRegular
    static let bold = FontName.camptonBold
    
    case avertaRegular = "AvertaDemoPECuttedDemo-Regular"
    case avertaExtraBold = "AvertaDemoPE-ExtraBold"
    case coreSansRegular = "CoreSansG-Regular"
    case coreSansBold = "CoreSansG-Bold"
    case muliRegular = "Muli-Regular"
    case muliBold = "Muli-Bold"
    case ralewayExtraBold = "Raleway-ExtraBold"
    case ralewayBold = "Raleway-Bold"
    case montserratBold = "Montserrat-Bold"
    case acreMedium = "Acre-Medium"
    case camptonBold = "Campton-BoldDEMO"
}

func getScaledFont(for name: FontName, size: CGFloat) -> UIFont {
    return UIFontMetrics.default.scaledFont(for: UIFont(name: name.rawValue, size: size)!)
}

extension UIColor {
    static let plantBackground = UIColor(named: "Plant Background")!
    static let lightGreenBackground = UIColor(named: "Light Green Background")!
    static let lightGreenText = UIColor(named: "Light Green Text")!
}

extension CGFloat {
    static let title: CGFloat = 32
    static let button: CGFloat = UIFont.buttonFontSize
    static let body: CGFloat = 12
    static let label: CGFloat = 10
    static let info: CGFloat = 20
    static let headline: CGFloat = UIFont.preferredFont(forTextStyle: .headline).pointSize
}

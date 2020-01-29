//
//  Plant.swift
//  Programmatic UI
//
//  Created by Milo Wyner on 1/9/20.
//  Copyright © 2020 Milo Wyner. All rights reserved.
//

import UIKit

struct Plant {
    let name: String
    let price: Int
    let category: CategoryType
    let sizes: [Size]
    let image: UIImage
    let description: String
    
    enum CategoryType: String {
        case indoor = "INDOOR"
        case outdoor = "OUTDOOR"
    }
    
    enum Size: String {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
    }
}

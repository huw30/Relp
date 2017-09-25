//
//  UITransform.swift
//  Yelp
//
//  Created by Raina Wang on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

struct UITransform {
    static func addBorder(layer: CALayer) {
        layer.cornerRadius = 5 //set corner radius here
        layer.borderColor = Colors.cellBorderColor.cgColor  // set cell border color here
        layer.borderWidth = 1 // set border width here
    }
}

//
//  PackableObject.swift
//  alpackaVisualizer
//
//  Created by Ethan John on 1/2/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import UIKit
import Alpacka

struct PackableObject: Sized, Hashable {
    var packingSize: CGSize {
        CGSize(width: width, height: height)
    }
    var origin: CGPoint
    let width: CGFloat
    let height: CGFloat
    let uid: String = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(origin.x)
        hasher.combine(origin.y)
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(uid)
    }
}

//
//  Sprite.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/18/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit

struct Sprite {
    
    var shape: [UIImage]
    var diamond: [UIImage]
    var wall: [UIImage]
    var bottomWall: [UIImage]
    var icon: [UIImage]
    var correctValue: [Int]
    var color: [String]
    
    init(shape: [UIImage], diamond: [UIImage], wall: [UIImage], bottomWall: [UIImage], icon: [UIImage], correctValue: [Int], color: [String]) {
        self.shape = shape
        self.diamond = diamond
        self.wall = wall
        self.bottomWall = bottomWall
        self.icon = icon
        self.correctValue = correctValue
        self.color = color
    }
    
}

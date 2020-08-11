//
//  BottomWall.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/29/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit

struct BottomWall {
    
    var wall: UIImage
    var diamond: UIImage
    var wallValue: Int
    
    init(wall: UIImage, diamond: UIImage, wallValue: Int) {
        self.wall = wall
        self.diamond = diamond
        self.wallValue = wallValue
    }
    
}

//
//  Shape.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/18/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit

struct Shape {
    
    var image: UIImage //Image
    var correctImage: Int //Correct Value
    
    init(image: UIImage, correctImage: Int) {
        
        self.image = image
        self.correctImage = correctImage
        
    }
    
}

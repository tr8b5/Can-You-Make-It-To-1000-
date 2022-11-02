//
//  UIAlertController+Extensions.swift
//  Can You Make It To 1000?
//
//  Created by Ashutosh Bhatt on 02/11/22.
//  Copyright © 2022 William Miller. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    class func show(_ message: String, from controller: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        controller.present(alert, animated: true)
    }
}

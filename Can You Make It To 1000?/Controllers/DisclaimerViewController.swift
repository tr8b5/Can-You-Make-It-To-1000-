//
//  DisclaimerViewController.swift
//  Can You Make It To 1000?
//
//  Created by Ashutosh Bhatt on 03/11/22.
//  Copyright © 2022 William Miller. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Events
    @IBAction func buttonEvent(sender: UIButton) {
        if sender.tag == 1 { //Accepted
            UserDefaults.standard.set("1", forKey: Constants.disclaimerAccepted)
            self.dismiss(animated: true)
        } else {
            UIAlertController.show(message: "Are you sure you want to reject? This will cause the app to exit.", from: self) {
                UserDefaults.standard.set("0", forKey: Constants.disclaimerAccepted)
                exit(0)
            } cancelAction: {
                // do nothing
            }
        }
    }
}

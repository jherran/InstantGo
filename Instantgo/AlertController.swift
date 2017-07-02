//
//  AlertController.swift
//  Instantgo
//
//  Created by Jose A. Herran on 29/06/2017.
//  Copyright © 2017 Jose A. Herran. All rights reserved.
//

import UIKit

class AlertController: NSObject {
    
    func displayAlertWith(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultButton = UIAlertAction(title: Constants.ok, style: .default)
        
        alert.addAction(defaultButton)
        viewController.present(alert, animated: true)
    }
}

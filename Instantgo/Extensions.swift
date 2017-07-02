//
//  Extensions.swift
//  Instantgo
//
//  Created by Jose A. Herran on 01/07/2017.
//  Copyright © 2017 Jose A. Herran. All rights reserved.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    func start() {
        self.isHidden = false
        self.startAnimating()
    }
    
    func stop() {
        self.isHidden = true
        self.stopAnimating()
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from:self)
        return dateString
    }
}



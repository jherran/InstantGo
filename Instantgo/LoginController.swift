//
//  LoginController.swift
//  Instantgo
//
//  Created by Jose A. Herran on 01/07/2017.
//  Copyright © 2017 Jose A. Herran. All rights reserved.
//

import Foundation
import EventKit


protocol LoginControllerDelegate {
    func calendarPermissionsStatus(granted: Bool)
}

class LoginController: NSObject {
    
    var delegate: LoginControllerDelegate?
    
    func requestCalendarPermissions() {
        if (!checkStatus()) {
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if !granted {
                    self.delegate?.calendarPermissionsStatus(granted: granted)
                }
            })
        }
    }
    
    func checkStatus() -> Bool {
        let currentStatus = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        if currentStatus == EKAuthorizationStatus.authorized {
            return true
        }
        return false
    }

}

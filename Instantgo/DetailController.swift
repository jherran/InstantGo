//
//  DetailController.swift
//  Instantgo
//
//  Created by Jose A. Herran on 02/07/2017.
//  Copyright © 2017 Jose A. Herran. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import FirebaseDatabase
import FirebaseAuth

class DetailController: NSObject {
    
    func createCalendarEvent(title: String, startDate: Date, endDate: Date) -> EKEvent? {
        
        let event = EKEvent(eventStore : eventStore)
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        
        do {
            try eventStore.save(event, span: .thisEvent)
            return event
        } catch {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                AlertController().displayAlertWith(title: Constants.error, message: error.localizedDescription, viewController: topController)
            }
            return nil
        }
    }

    func updateCalendarEvent(event: CalendarEvent) -> EKEvent? {
        if let eventToUpdate = eventStore.event(withIdentifier: event.eventIdentifier) {
            eventToUpdate.title = event.title
            eventToUpdate.startDate = event.startDate
            eventToUpdate.endDate = event.endDate
            
            do {
                try eventStore.save(eventToUpdate, span: .thisEvent)
                return eventToUpdate
            } catch {
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    AlertController().displayAlertWith(title: Constants.error, message: error.localizedDescription, viewController: topController)
                }
                return nil
            }
        }
        
        return nil
    }
    
    func updateEventOnFirebase(calendarEvent: CalendarEvent) {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child(uid).child(calendarEvent.identifier).setValue(calendarEvent.asDict())
        }
    }
    
    func createEventOnFirebase(event: EKEvent) {
        let ref = Database.database().reference()
        let eventCal = CalendarEvent(eventIdentifier: event.eventIdentifier, title:event.title, startDate: event.startDate, endDate: event.endDate, organizer: event.organizer?.name ?? "")
        if let uid = Auth.auth().currentUser?.uid {
            ref.child(uid).child(eventCal.identifier).setValue(eventCal.asDict())
        }
    }
}

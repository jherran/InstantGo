//
//  CalendarController.swift
//  Instantgo
//
//  Created by JOSE A. HERRAN on 30/06/2017.
//  Copyright © 2017 Jose A. Herran. All rights reserved.
//

import Foundation
import EventKit
import FirebaseDatabase
import FirebaseAuth
import UIKit

class CalendarController: NSObject {
    
    func getCalendarEvents() -> Array<CalendarEvent> {
        var events = Array<CalendarEvent>()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            let tenYearsAgo = NSDate(timeIntervalSinceNow: -30*12*10*24*3600)
            let tenYearsAfter = NSDate(timeIntervalSinceNow: +30*12*10*24*3600)
            
            let predicate = eventStore.predicateForEvents(withStart: tenYearsAgo as Date, end: tenYearsAfter as Date, calendars: [calendar])
            
            for event in eventStore.events(matching: predicate) {
                let currentEvent = CalendarEvent(eventIdentifier: event.eventIdentifier, title:event.title, startDate: event.startDate, endDate: event.endDate, organizer: event.organizer?.name ?? "")
                events.append(currentEvent)
            }
        }
        
        return events
    }
    
    func eventsToFirebase(events: Array<Any>) {
        let ref = Database.database().reference()
        
        for event in events {
            let eventCal = event as! CalendarEvent
            if let uid = Auth.auth().currentUser?.uid {
                ref.child(uid).child(eventCal.identifier).setValue(eventCal.asDict())
            }
        }
    }
}

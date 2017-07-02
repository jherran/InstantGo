//
//  CalendarEvent.swift
//  Instantgo
//
//  Created by Jose A. Herran on 01/07/2017.
//  Copyright © 2017 Jose A. Herran. All rights reserved.
//

import Foundation

class CalendarEvent: NSObject {
    var identifier: String
    var eventIdentifier: String
    var title: String
    var startDate: Date
    var endDate: Date
    var organizer: String
    
    init(eventIdentifier: String, title: String, startDate: Date, endDate: Date, organizer: String) {
        let okayChars : Set<Character> = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        self.identifier = String(eventIdentifier.characters.filter {okayChars.contains($0) })
        self.eventIdentifier = eventIdentifier
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.organizer = organizer
    }
    
    func asDict() -> Dictionary<String, Any>? {
        return [Constants.eventIdentifier: self.eventIdentifier, Constants.title: self.title, Constants.startDate: self.startDate.toString(), Constants.endDate: self.endDate.toString(), Constants.organizer: self.organizer]
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? CalendarEvent {
            return (self.eventIdentifier == other.eventIdentifier && self.title == other.title && self.startDate == other.startDate && self.endDate == other.endDate && self.organizer == other.organizer)
        } else {
            return false
        }
    }
}

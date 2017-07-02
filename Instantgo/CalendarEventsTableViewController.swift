//
//  CalendarEventsTableViewController.swift
//  Instantgo
//
//  Created by Jose A. Herran on 29/06/2017.
//  Copyright © 2017 Jose A. Herran. All rights reserved.
//

import UIKit
import EventKit
import FirebaseAuth

class CalendarEventsTableViewController: UITableViewController, UINavigationControllerDelegate {

    var events = Array<CalendarEvent>()
    var calendarController = CalendarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.eventsTitle
        navigationController?.delegate = self
        addNavButton()

        events = calendarController.getCalendarEvents()
        calendarController.eventsToFirebase(events: events)
    }
    
    func addNavButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CalendarEventsTableViewController.addEvent))
        navigationItem.rightBarButtonItem = button
    }
    
    func addEvent() {
        performSegue(withIdentifier: Constants.showDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            segue.destination.title = Constants.editEventTitle
            let vc = segue.destination as! DetailViewController
            vc.selectedEvent = events[indexPath.row]
        } else {
            segue.destination.title = Constants.addEventTitle
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! CalendarEventTableViewCell
        
        cell.eventTitle.text = events[indexPath.row].title
        cell.eventStartDate.text = events[indexPath.row].startDate.toString()
        cell.eventEndDate.text = events[indexPath.row].endDate.toString()
        cell.eventOrganizer.text = events[indexPath.row].organizer
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showDetail, sender: self)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: LoginViewController.classForCoder()) {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error while signing out!")
            }
        }
    }
    
}


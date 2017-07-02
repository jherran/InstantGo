//
//  DetailViewController.swift
//  Instantgo
//
//  Created by Jose A. Herran on 01/07/2017.
//  Copyright © 2017 Jose A. Herran. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    var selectedEvent: CalendarEvent?
    var modifiedEvent: CalendarEvent?
    var detailController = DetailController()
    
    @IBOutlet weak var titleString: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        if self.title == Constants.editEventTitle {
            if let selEvent = selectedEvent {
                modifiedEvent = CalendarEvent(eventIdentifier: selEvent.eventIdentifier, title: selEvent.title, startDate: selEvent.startDate, endDate: selEvent.endDate, organizer: selEvent.organizer)
            }
            fillScreenInfo()
            titleString.delegate = self
            addNavButtons(addButton: true)
        } else {
            addNavButtons(addButton: false)
            prepareScreenForNewEvent()
        }
    }
    
    func addNavButtons(addButton: Bool) {
        var buttons = Array<UIBarButtonItem>()
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DetailViewController.saveEvent))
        buttons.append(button)
        if addButton {
            let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(DetailViewController.addEvent))
            buttons.append(button)
        }
        navigationItem.rightBarButtonItems = buttons
    }
    
    func addEvent() {
        prepareScreenForNewEvent()
    }
    
    func saveEvent() {
        if self.title == Constants.editEventTitle {
            if (selectedEvent?.isEqual(modifiedEvent!))! {
                AlertController().displayAlertWith(title: Constants.warning, message: Constants.equalObjects, viewController: self)
            } else {
                if detailController.updateCalendarEvent(event: modifiedEvent!) != nil {
                    detailController.updateEventOnFirebase(calendarEvent: modifiedEvent!)
                    navigationController?.popViewController(animated: true)
                }
            }
        } else {
            if self.titleString.text?.isEmpty == false {
                if let event = detailController.createCalendarEvent(title: titleString.text!, startDate: startDatePicker.date, endDate: endDatePicker.date) {
                    detailController.createEventOnFirebase(event: event)
                    navigationController?.popViewController(animated: true)
                }
            } else {
                AlertController().displayAlertWith(title: Constants.warning, message: Constants.noEventTitle, viewController: self)
            }
        }
    }
    
    func prepareScreenForNewEvent() {
        titleString.text = ""
        startDatePicker.date = Date()
        endDatePicker.date = Date().addingTimeInterval(3600)
    }
    
    func fillScreenInfo() {
        titleString.text = selectedEvent?.title
        startDatePicker.date = (selectedEvent?.startDate)!
        endDatePicker.date = (selectedEvent?.endDate)!
    }
    
    @IBAction func startDateAction(_ sender: Any) {
        modifiedEvent?.startDate = startDatePicker.date
    }
    
    @IBAction func endDateAction(_ sender: Any) {
        modifiedEvent?.endDate = endDatePicker.date
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        modifiedEvent?.title = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let calendarViewController = viewController as? CalendarEventsTableViewController {
            calendarViewController.events = CalendarController().getCalendarEvents()
            calendarViewController.tableView.reloadData()
        }
    }
}

//
//  LoginViewController.swift
//  Instantgo
//
//  Created by Jose A. Herran on 29/06/2017.
//  Copyright © 2017 Jose A. Herran. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, LoginControllerDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var refresControl: UIActivityIndicatorView!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    
    var loginController = LoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.refresControl.isHidden = true
        self.title = Constants.instantGoTitle
        loginController.delegate = self
        loginController.requestCalendarPermissions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func logInAction(_ sender: Any) {
        refresControl.start()
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            if (error == nil) {
                self.performSegue(withIdentifier: Constants.showCalendarEvents, sender: self)
            } else {
                AlertController().displayAlertWith(title: Constants.error, message: (error?.localizedDescription)!, viewController: self)
            }
            self.refresControl.stop()
        }
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        refresControl.start()
        Auth.auth().createUser(withEmail: username.text!, password: password.text!) { (user, error) in
            if (error == nil) {
                print(Auth.auth().currentUser ?? "")
            } else {
                AlertController().displayAlertWith(title: Constants.error, message: (error?.localizedDescription)!, viewController: self)
            }
            self.refresControl.stop()
        }
    }
    
    func calendarPermissionsStatus(granted: Bool) {
        username.isEnabled = granted
        password.isEnabled = granted
        login.isEnabled = granted
        signup.isEnabled = granted
        
        if !granted {
            AlertController().displayAlertWith(title: Constants.warning, message: Constants.calendarInfo, viewController: self)
        }
    }

}



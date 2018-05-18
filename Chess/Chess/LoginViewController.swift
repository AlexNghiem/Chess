//
//  LoginViewController.swift
//  Chess
//
//  Created by Eric Zhu on 4/17/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController{
    
    //MARK: variable initialization
    var margins: UILayoutGuide? = nil
    var portraitHeight: CGFloat = 0
    var portraitWidth: CGFloat = 0
    

    
    let segmentControl = UISegmentedControl(items: ["Login", "Register"])
    let email = UITextField()
    let password = UITextField()
    let loginButton = UIButton()
    let backButton = UIButton()

    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        //Update variables
        margins = view.layoutMarginsGuide
        portraitHeight = view.bounds.height
        portraitWidth = view.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            portraitHeight = view.bounds.width
            portraitWidth = view.bounds.height
        }
        
        super.viewDidLoad()

        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(segmentControl)
        
        segmentControl.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4 + 20).isActive = true
        segmentControl.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4-20).isActive = true
        segmentControl.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/4 - 10).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 50)
        
        
        email.translatesAutoresizingMaskIntoConstraints = false
        email.autocapitalizationType = .none
        self.view.addSubview(email)
        email.layer.borderColor = UIColor.blue.cgColor
        email.layer.borderWidth = 1.0
        email.placeholder = "Email"
        
        email.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4).isActive = true
        email.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4).isActive = true
        email.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/4 + 40).isActive = true
        email.heightAnchor.constraint(equalToConstant: 35).isActive = true
        

        password.translatesAutoresizingMaskIntoConstraints = false
        password.autocapitalizationType = .none
        self.view.addSubview(password)
        password.layer.borderColor = UIColor.blue.cgColor
        password.layer.borderWidth = 1.0
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        
        password.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4).isActive = true
        password.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4).isActive = true
        password.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/4 + 80).isActive = true
        password.heightAnchor.constraint(equalToConstant: 35).isActive = true

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: UIControlState.normal)
        loginButton.backgroundColor = UIColor.blue
        self.view.addSubview(loginButton)
        loginButton.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4+50).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4-50).isActive = true
        loginButton.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/4 + 120).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        loginButton.addTarget(self, action: #selector(self.loginPress(_:)), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", for: UIControlState.normal)
        backButton.backgroundColor = UIColor.blue
        self.view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4+50).isActive = true
        backButton.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4-50).isActive = true
        backButton.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/4 + 180).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.addTarget(self, action: #selector(self.backButtonPushed(_:)), for: .touchUpInside)
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
    @IBAction func loginPress(_ sender: UIButton) {
        if (email.text != "" && password.text != "")
        {
            if(segmentControl.selectedSegmentIndex == 0)
            {
                Auth.auth().signIn(withEmail: email.text!, password: password.text!) {user, error in
                    if (user != nil)
                    {
                        self.performSegue(withIdentifier: "segue", sender: self)
                    }
                    else
                    {
                        print("ERROR : \(error!.localizedDescription)")
                    }
                }
            }
            else
            {
                Auth.auth().createUser(withEmail: email.text!, password: password.text!){user, error in
                    if error == nil && user != nil
                    {
                        self.performSegue(withIdentifier: "segue", sender: self)
                    }
                    else
                    {
                        print("ERROR : \(error!.localizedDescription)")
                    }
                    
                }
            }
        }
    }
    @IBAction func backButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromLoginViewControllerToMainViewControllerID", sender: self)
    }
    
}


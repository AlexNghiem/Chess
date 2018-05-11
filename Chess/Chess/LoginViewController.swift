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
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func action(_ sender: UIButton) {
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
                            /*if let myError = error?.localizedDescription
                            {
                                print(myError)
                            }
                            else
                            {
                                print("ERROR")
                            }*/
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
    override func viewDidLoad() {
        //Update variables
        margins = view.layoutMarginsGuide
        portraitHeight = view.bounds.height
        portraitWidth = view.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            portraitHeight = view.bounds.width
            portraitWidth = view.bounds.height
        }
        
        super.viewDidLoad()
        let registerText = ["Login","Register"]
        let registerButton = UISegmentedControl(items: registerText)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(registerButton)
        
        registerButton.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4).isActive = true
        registerButton.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/4 - 10).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50)
        

        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


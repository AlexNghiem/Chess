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
        super.viewDidLoad()

        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//
//  LoginViewController.swift
//  Chess
//
//  Created by Eric Zhu on 4/17/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import Foundation
import UIKit

//MARK: variable initialization
var margins: UILayoutGuide? = nil
var portraitHeight: CGFloat = 0
var portraitWidth: CGFloat = 0

class LoginViewController: UIViewController{
    
    let usernameField : UITextField = UITextField(frame: CGRect.zero)
    let passwordField : UITextField = UITextField(frame: CGRect.zero)
    let loginButton : UIButton = UIButton(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.blue
    
        //Update variables
        margins = view.layoutMarginsGuide
        portraitHeight = view.bounds.height
        portraitWidth = view.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            portraitHeight = view.bounds.width
            portraitWidth = view.bounds.height
        }
        //username text field
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.placeholder = "Username"
        
        view.addSubview(usernameField)
        
        usernameField.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4).isActive = true
        usernameField.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4).isActive = true
        usernameField.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/4).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: portraitHeight/8)
        
        usernameField.layer.borderWidth = 1
        
        //password text field

        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholder = "Password"
        
        view.addSubview(passwordField)
        
        passwordField.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4).isActive = true
        passwordField.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/5).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: portraitHeight/8)
        passwordField.isSecureTextEntry = true
        passwordField.layer.borderWidth = 1
        
        //login button
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor.gray
        loginButton.setTitle("Login", for: UIControlState.normal)
        loginButton.titleLabel?.font = UIFont(name: "Helvetica", size: portraitHeight/24)
        
        view.addSubview(loginButton)
        
        loginButton.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/8).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/8).isActive = true
        loginButton.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/8).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: portraitHeight/8)
        
    }
    @IBAction func LoginButton (_sender : Any){
        let username = usernameField.text
        let password = passwordField.text
        
        if(username == "" || password == ""){
            return
        }
        
    }
    func Login (_ user:String, _ psw : String)
    {
        let url = URL(string: "http://www.kaleidosblog.com/tutorial/login/api/login")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "username=" + user + "&password=" + psw
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else{
                return
            }
            let json:Any?
            do{
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch{
                return
            }
            
            guard let server_response = json as? NSDictionary else
            {
                return
            }
            
            
            if let data_block = server_response["data"] as? NSDictionary
            {
                if let session_data = data_block["session"] as? String
                {
                    let preferences = UserDefaults.standard
                    preferences.set(session_data, forKey: "session")
                    
                    DispatchQueue.main.async (
                        execute:self.LoginDone
                    )
                }
            }
            
        })
        
        task.resume()
    }
    func LoginToDo()
    {
        usernameField.isEnabled = true
        passwordField.isEnabled = true
        
        loginButton.setTitle("Login", for: .normal)
    }
    
    func LoginDone()
    {
        usernameField.isEnabled = false
        passwordField.isEnabled = false
        
        loginButton.setTitle("Logout", for: .normal)
    }
}

//
//  ViewController.swift
//  Chess
//
//  Created by Alexander Nghiem on 3/29/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {

    //MARK: variable initialization
    var margins: UILayoutGuide = UILayoutGuide()
    var portraitHeight: CGFloat = 0
    var portraitWidth: CGFloat = 0
    let playerBox : UILabel = UILabel(frame:CGRect.zero)
    let loginButton: UIButton = UIButton(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        view.backgroundColor = UIColor.darkGray

        
        //Update variables
        margins = view.layoutMarginsGuide
        portraitHeight = view.bounds.height
        portraitWidth = view.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            portraitHeight = view.bounds.width
            portraitWidth = view.bounds.height
        }
        //Player Box
        playerBox.translatesAutoresizingMaskIntoConstraints = false
        if(user == nil)
        {
            playerBox.text = "Playing as: Guest"
        }
        else
        {
            playerBox.text = "Playing as: " + (user?.email)!
        }
        playerBox.adjustsFontSizeToFitWidth = true
        playerBox.font = UIFont(name: "Helvetica", size: portraitHeight/36) //I like the font this size relative to the screen
        playerBox.textColor = UIColor.white
        playerBox.textAlignment = NSTextAlignment.center
        view.addSubview(playerBox)
        playerBox.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        playerBox.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        playerBox.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: -portraitHeight/4).isActive = true //this number is the height above the center
        //Title box
        
        let titleBox: UILabel = UILabel(frame: CGRect.zero)
        titleBox.translatesAutoresizingMaskIntoConstraints = false
        titleBox.text = "Chess"
        titleBox.font = UIFont(name: "Helvetica", size: portraitHeight/10) //I like the font this size relative to the screen
        titleBox.textColor = UIColor.white
        titleBox.textAlignment = NSTextAlignment.center
        view.addSubview(titleBox)
        titleBox.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -portraitWidth/3).isActive = true //I like it to be 2/3 of the width of the screen
        titleBox.trailingAnchor.constraint(equalTo: margins.centerXAnchor, constant: +portraitWidth/3).isActive = true //I like it to be 2/3 of the width of the screen
        titleBox.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: -portraitHeight/5).isActive = true //the top should be a fifth of the portraitheight above the center

        //Button
        let playButton: UIButton = UIButton(frame: CGRect.zero)
        playButton.backgroundColor = UIColor.black
        playButton.setTitle("Play", for: UIControlState.normal)
        playButton.titleLabel?.font = UIFont(name: "Times New Roman", size: portraitHeight/12) //I like the font this size relative to the screen
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(playButton)
        
        playButton.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -portraitWidth/4).isActive = true //I like it to be 1/2 of the width of the screen
        playButton.trailingAnchor.constraint(equalTo: margins.centerXAnchor, constant: +portraitWidth/4).isActive = true //I like it to be 1/2 of the width of the screen
        playButton.topAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: portraitHeight/10) //the login button is 1/10 of the screen tall
        playButton.addTarget(self, action: #selector(MainViewController.playButtonPushed(_:)), for: UIControlEvents.touchUpInside)
        
        //how to play button
        let howToPlayButton: UIButton = UIButton(frame: CGRect.zero)
        view.addSubview(howToPlayButton)
        
        howToPlayButton.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -portraitWidth/4).isActive = true //the how to play button is half the width of the screen
        howToPlayButton.trailingAnchor.constraint(equalTo: margins.centerXAnchor, constant: +portraitWidth/4).isActive = true //the how to play button is half the width of the screen
        howToPlayButton.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: +portraitHeight/8).isActive = true //the how to play button is an eighth of height of the screen above the center
        howToPlayButton.heightAnchor.constraint(equalToConstant: portraitHeight/16).isActive = true
        
        
        howToPlayButton.backgroundColor = UIColor.black
        howToPlayButton.setTitle("How To Play", for: UIControlState.normal)
        howToPlayButton.titleLabel?.font = UIFont(name: "Times New Roman", size: portraitHeight/24) //I like the font this size relative to the screen
        howToPlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        howToPlayButton.addTarget(self, action: #selector(self.howToPlayButtonPushed(_:)), for: .touchUpInside)
        
        //login stuff
        loginButton.backgroundColor = UIColor.black
        if(user == nil)
        {
            loginButton.setTitle("Login", for: UIControlState.normal)
        }
        else
        {
            loginButton.setTitle("Logout", for: UIControlState.normal)
        }
        loginButton.titleLabel?.font = UIFont(name: "Times New Roman", size: portraitHeight/24) //I like the font this size relative to the screen
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        
        loginButton.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -portraitWidth/4).isActive = true //the login button is half the screen wide
        loginButton.trailingAnchor.constraint(equalTo: margins.centerXAnchor, constant: +portraitWidth/4).isActive = true //the login button is half the screen wide
        loginButton.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: +portraitHeight/5).isActive = true //the login button is 1/5 of the screen height above the center
        loginButton.heightAnchor.constraint(equalToConstant: portraitHeight/10) //the login button is 1/10 of the screen tall
        
        loginButton.addTarget(self, action: #selector(MainViewController.loginButtonPushed(_:)), for: UIControlEvents.touchUpInside)
    }
    
    //this gets called whenever a change of users may be needed
    func fixThings() {
        if(Auth.auth().currentUser == nil)
        {
            playerBox.text = "Playing as: Guest"
            loginButton.setTitle("Login", for: UIControlState.normal)
        }
        else
        {
            playerBox.text = "Playing as: " + (Auth.auth().currentUser?.email)!
            loginButton.setTitle("Logout", for: UIControlState.normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Button Functions
    @IBAction func playButtonPushed(_ sender: UIButton) {
        let view: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoardViewControllerID") as UIViewController
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPushed (_ sender: UIButton) {
        if(Auth.auth().currentUser == nil)
        {
        let view: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewControllerID") as UIViewController
        present(view, animated: true, completion: nil)
        }
        else
        {
            do
            {
                try Auth.auth().signOut()
                fixThings()
            }
            catch let signOutError as NSError
            {
                print(signOutError)
            }
        }
    }
    
    @IBAction func howToPlayButtonPushed(_ sender: UIButton) {
        let view: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HowToPlayID") as UIViewController
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromBoardViewControllerToMainViewController(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromLoginViewControllerToMainViewController(segue: UIStoryboardSegue) {
        fixThings()
    }
    
    @IBAction func unwindFromHowToPlayToMainViewController(segue: UIStoryboardSegue) {
        
    }
}


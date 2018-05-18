//
//  ViewController.swift
//  Chess
//
//  Created by Alexander Nghiem on 3/29/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: variable initialization
    var margins: UILayoutGuide? = nil
    var portraitHeight: CGFloat = 0
    var portraitWidth: CGFloat = 0
    
    // initialize intro label
    let closeButton: UIButton = UIButton(frame: CGRect.zero)
    let introLabel: UILabel = UILabel(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        
        //Update variables
        margins = view.layoutMarginsGuide
        portraitHeight = view.bounds.height
        portraitWidth = view.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            portraitHeight = view.bounds.width
            portraitWidth = view.bounds.height
        }

        //Title box
        let titleBox: UILabel = UILabel(frame: CGRect.zero)
        titleBox.translatesAutoresizingMaskIntoConstraints = false //this allows the later constraints to override the fact that the text view is initialized to a rectangle of size 0
        titleBox.text = "Chess"
        titleBox.font = UIFont(name: "Helvetica", size: portraitHeight/10)
        titleBox.textColor = UIColor.white
        titleBox.textAlignment = NSTextAlignment.center
        view.addSubview(titleBox)
        titleBox.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/3).isActive = true
        titleBox.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/3).isActive = true
        titleBox.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/4).isActive = true
        titleBox.bottomAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/4 + portraitHeight/10).isActive = true

        //Button
        let playButton: UIButton = UIButton(frame: CGRect.zero)
        playButton.backgroundColor = UIColor.black
        playButton.setTitle("Play", for: UIControlState.normal)
        playButton.titleLabel?.font = UIFont(name: "Times New Roman", size: portraitHeight/12)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(playButton)
        
        playButton.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4).isActive = true
        playButton.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4).isActive = true
        playButton.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: portraitHeight/10)
        playButton.addTarget(self, action: #selector(MainViewController.playButtonPushed(_:)), for: UIControlEvents.touchUpInside)
        
        //how to play button
        let howToPlayButton: UIButton = UIButton(frame: CGRect.zero)
        view.addSubview(howToPlayButton)
        
        howToPlayButton.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4).isActive = true
        howToPlayButton.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4).isActive = true
        howToPlayButton.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: +portraitHeight/8).isActive = true
        howToPlayButton.heightAnchor.constraint(equalToConstant: portraitHeight/16).isActive = true
        
        
        howToPlayButton.backgroundColor = UIColor.black
        howToPlayButton.setTitle("How To Play", for: UIControlState.normal)
        howToPlayButton.titleLabel?.font = UIFont(name: "Times New Roman", size: portraitHeight/24)
        howToPlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        howToPlayButton.addTarget(self, action: #selector(self.howToPlayButtonPushed(_:)), for: .touchUpInside)
        
        //initialize introduction stuff
        self.view.addSubview(introLabel)
        
        introLabel.isHidden = true
        introLabel.lineBreakMode = .byWordWrapping
        introLabel.numberOfLines = 0
        introLabel.backgroundColor = UIColor.white
        
        introLabel.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/2 + 10).isActive = true
        introLabel.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/2 - 10).isActive = true
        introLabel.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: -portraitHeight/4).isActive = true
        introLabel.heightAnchor.constraint(equalToConstant: portraitHeight)
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        introLabel.text = "Move your pieces and take your opponents pieces to trap the opponent's King!\nPiece Moves: \nPawn : Can move forwards 1 space and takes pieces diagonally. Can move two spaces if being moved for the first time \n\nKnight : can move in a 3x2 or 2x3 L shape in any direction \n\nBishop : can move along diagonals \n\nRook : can move vertically and horizontally \n\nQueen : can move vertically, horizontally, and along diagonals \n\nKing can move one space in any direction \n\n Press How To Play again to close"
        
        //login stuff
        let loginButton: UIButton = UIButton(frame: CGRect.zero)
        loginButton.backgroundColor = UIColor.black
        loginButton.setTitle("Login", for: UIControlState.normal)
        loginButton.titleLabel?.font = UIFont(name: "Times New Roman", size: portraitHeight/24)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        
        loginButton.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -portraitWidth/4).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: +portraitWidth/4).isActive = true
        loginButton.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: +portraitHeight/5).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: portraitHeight/10)
        
        loginButton.addTarget(self, action: #selector(MainViewController.loginButtonPushed(_:)), for: UIControlEvents.touchUpInside)


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
        let view: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewControllerID") as UIViewController
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func howToPlayButtonPushed(_ sender: UIButton) {
        let view: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HowToPlayID") as UIViewController
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromBoardViewControllerToMainViewController(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromHowToPlayToMainViewController(segue: UIStoryboardSegue) {
        
    }
}


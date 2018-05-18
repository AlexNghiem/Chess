//
//  HowToPlay.swift
//  Chess
//
//  Created by Alexander Nghiem on 5/17/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import Foundation
import UIKit

class HowToPlay: UIViewController {

    var margins: UILayoutGuide = UILayoutGuide()
    var portraitHeight: CGFloat = 0
    var portraitWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        margins = view.layoutMarginsGuide
        portraitHeight = view.bounds.height
        portraitWidth = view.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            portraitHeight = view.bounds.width
            portraitWidth = view.bounds.height
        }
        
        let scrollView: UIScrollView = UIScrollView(frame: CGRect.zero)
        scrollView.backgroundColor = UIColor.blue
        scrollView.layer.borderWidth = 2
        scrollView.layer.borderColor = UIColor.green.cgColor
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: margins.centerXAnchor, constant: -portraitWidth/3).isActive = true
        scrollView.rightAnchor.constraint(equalTo: margins.centerXAnchor, constant: portraitWidth/3).isActive = true
        scrollView.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: -portraitHeight/3).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: portraitHeight*2/3).isActive = true


        let rulesLabel: UILabel = UILabel(frame: CGRect.zero)
        rulesLabel.translatesAutoresizingMaskIntoConstraints = false //this allows the later constraints to override the fact that the text view is initialized to a rectangle of size 0
        rulesLabel.text = "Move your pieces and take your opponents pieces to trap the opponent's King!\nPiece Moves: \nPawn : Can move forwards 1 space and takes pieces diagonally. Can move two spaces if being moved for the first time \n\nKnight : can move in a 3x2 or 2x3 L shape in any direction \n\nBishop : can move along diagonals \n\nRook : can move vertically and horizontally \n\nQueen : can move vertically, horizontally, and along diagonals \n\nKing can move one space in any direction \n\n Press How To Play again to close"
        rulesLabel.font = UIFont(name: "Helvetica", size: portraitHeight/10)
        rulesLabel.textColor = UIColor.white
        
        //initialize introduction stuff
        let introLabel: UILabel = UILabel(frame: CGRect.zero)
        self.view.addSubview(introLabel)
        
        introLabel.isHidden = true
        introLabel.lineBreakMode = .byWordWrapping
        introLabel.numberOfLines = 0
        introLabel.backgroundColor = UIColor.white
        
        introLabel.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -portraitWidth/2 + 10).isActive = true
        introLabel.trailingAnchor.constraint(equalTo: margins.centerXAnchor, constant: +portraitWidth/2 - 10).isActive = true
        introLabel.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: -portraitHeight/4).isActive = true
        introLabel.heightAnchor.constraint(equalToConstant: portraitHeight)
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        
        introLabel.text = "Move your pieces and take your opponents pieces to trap the opponent's King!\nPiece Moves: \nPawn : Can move forwards 1 space and takes pieces diagonally. Can move two spaces if being moved for the first time \n\nKnight : can move in a 3x2 or 2x3 L shape in any direction \n\nBishop : can move along diagonals \n\nRook : can move vertically and horizontally \n\nQueen : can move vertically, horizontally, and along diagonals \n\nKing can move one space in any direction \n\n Press How To Play again to close"
        
        let backButton = UIButton(frame: CGRect.zero)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("back", for: UIControlState.normal)
        backButton.titleLabel?.font = UIFont(name: "Calibri", size: portraitHeight/10)
        backButton.backgroundColor = UIColor.lightGray
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: portraitWidth/10).isActive = true
        backButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -portraitWidth/10).isActive = true
        backButton.topAnchor.constraint(equalTo: margins.bottomAnchor, constant: -portraitHeight/5).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: portraitHeight/10)
        backButton.addTarget(self, action: #selector(self.backButtonPushed(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @IBAction func backButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromHowToPlayToMainViewControllerID", sender: self)
    }
}

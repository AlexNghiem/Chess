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
        view.backgroundColor = UIColor.darkGray
        margins = view.layoutMarginsGuide
        portraitHeight = view.bounds.height
        portraitWidth = view.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            portraitHeight = view.bounds.width
            portraitWidth = view.bounds.height
        }
        
        showRules()
        
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
    
    func showRules() {
        let buffer = portraitWidth/25
        
        let scrollView: UIScrollView = UIScrollView()
        scrollView.layer.borderWidth = 2
        scrollView.layer.borderColor = UIColor.black.cgColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let rulesLabel: UILabel = UILabel()
        rulesLabel.translatesAutoresizingMaskIntoConstraints = false
        rulesLabel.text = "Move your pieces and take your opponents pieces to trap the oppon ent's Ki ng!as dl;fjasdl; fffff fffffff fffffjkk kkkkkkkkk kkkkkkkkkkkkkk kkkkkkkkkkkkkk\nPiece Moves: \nPawn : Can move forwards 1 space and takes pieces diagonally. Can move two spaces if being moved for the first time \n\nKnight : can move in a 3x2 or 2x3 L shape in any direction \n\nBishop : can move along diagonals \n\nRook : can move vertically and horizontally \n\nQueen : can move vertically, horizontally, and along diagonals \n\nKing can move one space in any direction \n\n Press How To Play again to close\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest"
        rulesLabel.font = UIFont(name: "Helvetica", size: portraitHeight/50)
        rulesLabel.numberOfLines = 0
        rulesLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        rulesLabel.textColor = UIColor.black
        rulesLabel.sizeToFit()
        scrollView.contentSize.height = rulesLabel.frame.height + (buffer * 2)
        
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: portraitHeight*3/4).isActive = true
        
        scrollView.addSubview(rulesLabel)
        rulesLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: buffer).isActive = true
        rulesLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: buffer).isActive = true
        rulesLabel.widthAnchor.constraint(equalToConstant: portraitWidth - buffer * 2)
    }
    
    @IBAction func backButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromHowToPlayToMainViewControllerID", sender: self)
    }
}

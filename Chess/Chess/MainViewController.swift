//
//  ViewController.swift
//  Chess
//
//  Created by Alexander Nghiem on 3/29/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: variable initialization
    var margins: UILayoutGuide? = nil
    var portraitHeight: CGFloat = 0
    var portraitWidth: CGFloat = 0
    
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
        let playButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


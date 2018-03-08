//
//  BoardViewController2.swift
//  FoodTracker2
//
//  Created by Alexander Nghiem on 3/8/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import Foundation
import UIKit

class BoardViewController2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        let margins = view.layoutMarginsGuide
        var portraitHeight: CGFloat = view.bounds.height //this is the height in portrait mode... it will be updated if the app is launched in landscape mode (view.bounds.height gives the height IN the current orientation --> will be wrong initially if launched in landscape)
        var portraitWidth: CGFloat = view.bounds.width //this is the width in portrait mode
        if UIApplication.shared.statusBarOrientation.isLandscape {
            //print("debug: app was launched in landscape mode") //for debug
            portraitHeight = view.bounds.width //this updates the values if necessary
            portraitWidth = view.bounds.height //this updates the values if necessary
        }
        
        let backButton = UIButton(frame: CGRect.zero)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("back", for: UIControlState.normal)
        backButton.titleLabel?.font = UIFont(name: "Calibri", size: portraitHeight/10)
        backButton.backgroundColor = UIColor.white
        backButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        //backButton.titleLabel?.textColor = UIColor.black //no this doesn't work
        
        view.addSubview(backButton)
        
        backButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: portraitWidth/10).isActive = true
        backButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -portraitWidth/10).isActive = true
        backButton.topAnchor.constraint(equalTo: margins.bottomAnchor, constant: -portraitHeight/5).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: portraitHeight/10)
        
        backButton.addTarget(self, action: #selector(self.backButtonPushed(_:)), for: UIControlEvents.touchUpInside)
        
        
    }
    
    //MARK: Actions
    @IBAction func backButtonPushed(_ sender: UIButton) {
        //print("debug... action backButtonPushed in boardviewcontroller2 is being completed")
        performSegue(withIdentifier: "unwindToBoardViewController", sender: self)
    }
}

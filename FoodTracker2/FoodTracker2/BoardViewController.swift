//
//  BoardViewController.swift
//  FoodTracker2
//
//  Created by Alexander Nghiem on 2/22/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

//import Foundation //this came enabled.. not sure what this does --> tested.. seemingly does nothing?
import UIKit

class BoardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.green
        
        var portraitHeight: CGFloat = view.bounds.height //this is the height in portrait mode... it will be updated if the app is launched in landscape mode (view.bounds.height gives the height IN the current orientation --> will be wrong initially if launched in landscape)
        var portraitWidth: CGFloat = view.bounds.width //this is the width in portrait mode
        if UIApplication.shared.statusBarOrientation.isLandscape {
            //print("debug: app was launched in landscape mode") //for debug
            portraitHeight = view.bounds.width //this updates the values if necessary
            portraitWidth = view.bounds.height //this updates the values if necessary
        }
        
        let nameTextRectangle: CGRect = CGRect.zero //sets the specifications of the rectangle that the text field sits in... this will later be changed by constraints
        let nameText: UILabel = UILabel(frame: nameTextRectangle) //sets the uitextview to be inside the rectangle specified by nametext
        nameText.text = "testLabel: gray background, green font, times new roman, size 15, top starts 1/10 of way down page, bottom ends 1/2 of the way down page, left is 100 units right of the edge of the screen, right is 100 units left of the edge of the screen, text is centered, max lines = 15 --> the rest turn into '...', there are no '\\n's in this text.. it is autoformatting. FILLERFILLERFILLERFILLERFILLERFILLERFILLERFILLERFILLERFILLER" //sets the text to display testlabel
        //nameText.isEditable = false //this defaults to true... while false the user canNOT edit the text !!THIS IS NOT APPLICABLE BECAUSE IT IS NOW A LABEL, NOT A TEXTVIEW!!
        nameText.font = UIFont(name: "Times New Roman", size: 15) //self explanatory
        nameText.textColor = UIColor.blue //this sets the color to blue !!!!THIS IS REDUNDANT GIVEN THE LINE RIGHT AFTER THIS!!!!
        nameText.textColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1) //this sets the color to green. the alpha value is how opaque the color is. all values are 0 to 1
        nameText.textAlignment = NSTextAlignment.center //centers the text
        //nameText.isSelectable = false //the user cannot highlight ('select') the text !!THIS IS NOT APPLICABLE BECAUSE IT IS NOW A LABEL, NOT A TEXTVIEW!!
        nameText.backgroundColor = UIColor.gray //sets the background color to gray
        nameText.numberOfLines = 15
        
        //add the view
        view.addSubview(nameText) //tells the 'self' (which is viewcontroller) to add the subview on top of itself --> shows the uitextview !you can add 'self.' to the beginning of this and it works the same it seems
        
        //constraints
        nameText.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide //this gets the view's margins so we can make constraints based on the view that we're in currently !NOTE: not sure which view this refers to exactly... perhaps the view controlled directly by viewcontroller if thats a thing..?!
        nameText.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 100.0).isActive = true
        nameText.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -100.0).isActive = true
        nameText.topAnchor.constraint(equalTo: margins.topAnchor, constant: view.bounds.height/10).isActive = true //the 1/10 is the fraction of the total way down the page that the text box begins !!NOTE THE TOP BANNER THAT HAS THE TIME IS NOT INCLUDED IN THIS DISTANCE --> THE VIEW 'STARTS' BELOW THAT BANNER!!
        nameText.bottomAnchor.constraint(equalTo: margins.topAnchor, constant: view.bounds.height/2).isActive = true //the 1/2 is the fraction of the total way down the page that the text box ends
        
        let backButton: UIButton = UIButton(frame: CGRect.zero)
        backButton.setTitle("go back", for: UIControlState.normal)
        backButton.titleLabel?.font = UIFont(name: "Times New Roman", size: portraitHeight/10)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.backgroundColor = UIColor.blue
        
        view.addSubview(backButton)
        
        backButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: portraitWidth/10).isActive = true
        backButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -portraitWidth/10).isActive = true
        backButton.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: portraitHeight/5).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: portraitHeight/5).isActive = true
        backButton.addTarget(self, action: #selector(self.backButtonPushed(_:)), for: UIControlEvents.touchUpInside)
        
        let nextButton: UIButton = UIButton(frame: CGRect.zero)
        nextButton.setTitle("next --> go to actual board", for: UIControlState.normal)
        nextButton.titleLabel?.font = UIFont(name: "Calibri", size: portraitHeight/15)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = UIColor.cyan
        
        view.addSubview(nextButton)
        
        nextButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: portraitWidth/20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -portraitWidth/20).isActive = true
        nextButton.topAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: portraitHeight/5).isActive = true
        
        nextButton.addTarget(self, action: #selector(self.nextButtonPushed(_:)), for: UIControlEvents.touchUpInside)
    }
    
    //MARK: Actions
    @IBAction func backButtonPushed(_ sender: UIButton) {
        print("debug: back button was pushed --> backButtonPushed is being completed")
        /*let startPage: UIViewController = ViewController()
        present(startPage, animated: false) {
            print("hey we went back to the start screen!")
        }*/
        performSegue(withIdentifier: "unwindToMainViewController", sender: self)
    }
    
    @IBAction func nextButtonPushed(_ sender: UIButton) {
        let boardView: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoardViewController2ID") as UIViewController
        present(boardView, animated: true) {
            print("debug: next button was pushed --> nextButtonPushed is being completed")
        }
    }
    
    //MARK: Navigation
    @IBAction func unwindToBoardViewController(segue: UIStoryboardSegue) {
        
    }
}

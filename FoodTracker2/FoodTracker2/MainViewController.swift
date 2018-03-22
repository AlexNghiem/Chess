//
//  ViewController.swift
//  FoodTracker2
//
//  Created by Alexander Nghiem on 2/16/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import UIKit //gives us some good resources for UI stuff

class MainViewController: UIViewController {

    //MARK: Properties
    //@IBOutlet weak var nameTextField: UITextField! //this connects the ui to the code
    
    override func viewDidLoad() { //
        super.viewDidLoad() //this does some magic
        
        //print("width = " + view.bounds.width.description) //this can be used to find out what the width of the view is
        //print("height = " + view.bounds.height.description) //this can be used to find out what the height of the view is
        var portraitHeight: CGFloat = view.bounds.height //this is the height in portrait mode... it will be updated if the app is launched in landscape mode (view.bounds.height gives the height IN the current orientation --> will be wrong initially if launched in landscape)
        var portraitWidth: CGFloat = view.bounds.width //this is the width in portrait mode
        if UIApplication.shared.statusBarOrientation.isLandscape {
            //print("debug: app was launched in landscape mode") //for debug
            portraitHeight = view.bounds.width //this updates the values if necessary
            portraitWidth = view.bounds.height //this updates the values if necessary
        } else {
            //print("debug: app was launched in portrait mode") //for debug
        }
        let margins = view.layoutMarginsGuide

        let rectangleFrame: CGRect = CGRect.zero
        let rectangle: UITextView = UITextView(frame: rectangleFrame)
        rectangle.backgroundColor = UIColor.black
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(rectangle)
        
        /*print(view.layoutMargins.left-view.layoutMargins.right)
        //print(view.layoutMargins.right)
        rectangle.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -10).isActive = true
        rectangle.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        rectangle.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        rectangle.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true*/

        //VV THIS IS THE CODE FOR A TEXT LABEL, JUST FOR REFERENCE VV
        /*
        //setting up the rectangle
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
        //nameText.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.25).isActive = true //not sure if this is necessary... i can see using either setting constraints for top and bottom, or setting height, but i see no reason to do both
         */
         //^^ THIS IS THE CODE FOR A TEXT LABEL, JUST FOR REFERENCE ^^
        
        //LETS SET THIS UP RN.. I think that i only have to set this up once
        
        let titleText: UILabel = UILabel(frame: CGRect.zero)
        titleText.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        titleText.text = "Chess"
        titleText.font = UIFont(name: "MarkerFelt-Thin", size: portraitHeight/10) //this sets the font and font size. The font size is the height of the app over 10 (font size corresponds to the height of the font --> the font will be 1/10 as tall as the screen)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.textAlignment = NSTextAlignment.center
        
        view.addSubview(titleText)
        
        titleText.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -portraitWidth/3).isActive = true //it is centered, with a width 2/3 of the portrait width
        titleText.trailingAnchor.constraint(equalTo: margins.centerXAnchor, constant: +portraitWidth/3).isActive = true
        titleText.topAnchor.constraint(equalTo: margins.topAnchor, constant: portraitHeight/10).isActive = true //it starts a tenth of the way down the screen
        titleText.heightAnchor.constraint(equalToConstant: portraitHeight/8).isActive = true //it is 1/8 the height of the app... just taller than the font
        
        let startButton: UIButton = UIButton(frame: CGRect.zero)
        startButton.backgroundColor = UIColor.black
        startButton.setTitle("play", for: UIControlState.normal)
        startButton.titleLabel?.font = UIFont(name: "Times New Roman", size: portraitHeight/12)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(startButton)
        
        startButton.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -portraitWidth/4).isActive = true
        startButton.trailingAnchor.constraint(equalTo: margins.centerXAnchor, constant: +portraitWidth/4).isActive = true
        startButton.topAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: portraitHeight/10)
        //startButton.addTarget(self, action: "startButtonPushed:", for: UIControlEvents.touchUpInside) //this is the deprecated version
        startButton.addTarget(self, action: #selector(MainViewController.startButtonPushed(_:)), for: UIControlEvents.touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func startButtonPushed(_ sender: UIButton) {
        print("debug: startButton was pushed.. action in startButtonPushed is being completed")
        //let boardView = BoardViewController() //BIG NOOOOOOO DON'T DO THIS
        let boardView: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoardViewControllerID") as UIViewController
        present(boardView, animated: true, completion: nil)
    }
    
    //MARK: Navigation
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        
    }
}

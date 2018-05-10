//
//  SecondViewController.swift
//  Chess
//
//  Created by Eric Zhu on 5/9/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import UIKit
import FirebaseAuth

class SecondViewController: UIViewController {

    
    @IBOutlet weak var logout: UIButton!
    @IBAction func logout(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "home", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

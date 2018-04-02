//
//  BoardViewController.swift
//  Chess
//
//  Created by Alexander Nghiem on 4/2/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import Foundation
import UIKit

class BoardViewController: UIViewController {
    
    //MARK: variable initialization
    var margins: UILayoutGuide? = nil
    var portraitHeight: CGFloat = 0
    var portraitWidth: CGFloat = 0
    var pieceArray: [[UIButton?]] = [[UIButton?](repeating: nil, count: 8)]
    var pieceIsSelected = false
    var rowSelected = 0
    var colSelected = 0
    var squareSize: CGFloat = 0.0
    let selectedBox: UIButton = UIButton(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        
        //Update variables
        margins = view.layoutMarginsGuide
        portraitHeight = view.bounds.height
        portraitWidth = view.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            portraitHeight = view.bounds.width
            portraitWidth = view.bounds.height
        }
        
        let backButton = UIButton(frame: CGRect.zero)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("back", for: UIControlState.normal)
        backButton.titleLabel?.font = UIFont(name: "Calibri", size: portraitHeight/10)
        backButton.backgroundColor = UIColor.white
        backButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: margins!.leadingAnchor, constant: portraitWidth/10).isActive = true
        backButton.trailingAnchor.constraint(equalTo: (margins?.trailingAnchor)!, constant: -portraitWidth/10).isActive = true
        backButton.topAnchor.constraint(equalTo: (margins?.bottomAnchor)!, constant: -portraitHeight/5).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: portraitHeight/10)
        backButton.addTarget(self, action: #selector(self.backButtonPushed(_:)), for: UIControlEvents.touchUpInside)
        
        let board: UIImageView = UIImageView(image: #imageLiteral(resourceName: "chessBoard.png"))
        board.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(board)
        board.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: -4*squareSize).isActive = true
        board.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: (-4-2)*squareSize).isActive = true
        board.heightAnchor.constraint(equalToConstant: squareSize*8).isActive = true
        board.widthAnchor.constraint(equalToConstant: squareSize*8).isActive = true
        
        for row in 0...7 {
            var tempRow = [UIButton?](repeating: nil, count: 8)
            for col in 0...7 {
                let testPiece = piece(row: row, col: col)
                testPiece.translatesAutoresizingMaskIntoConstraints = false
                
                view.addSubview(testPiece)
                
                testPiece.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: CGFloat(col-4)*squareSize).isActive = true
                testPiece.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: CGFloat(row-4-2)*squareSize).isActive = true
                testPiece.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
                testPiece.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
                
                testPiece.addTarget(self, action: #selector(self.chessPiecePushed(_:)), for: UIControlEvents.touchUpInside)
                
                tempRow[col] = testPiece
            }
            pieceArray.append(tempRow)
        }
        
        let url = "http://1718.lakeside-cs.org/Chess_Project_(better_than_checkers)/spaghetti.php"
        func getServerResponse(url: String, parameters: [String: String]) {
            
        }
        var components: URLComponents = URLComponents(string: url)!
        //components.queryItems = ["toMove": "white", "pieces": "RNBQKBNRPPPP PPP            P       p           pppppppprnbqkbnr"].map { (arg) -> URLQueryItem in
        components.queryItems = ["toMove": "white", "pieces": "________________________________________________________________"].map { (arg) -> URLQueryItem in

            let (key, value) = arg
            return URLQueryItem(name: key, value: value)
        }
        let request: URLRequest = URLRequest(url: components.url!)
        //SERVER STUFF
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if(error != nil) {
                print(error as Any)
            }
            else {
                if let content = data {
                    do {
                        print(content)
                        //let Json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        let Json = try JSONSerialization.jsonObject(with: content, options: .allowFragments) as AnyObject
                        print(Json)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    //MARK: Chess
    
    class piece: UIButton {
        var rowCoord = 0
        var colCoord = 0
        init(row: Int, col: Int) {
            super.init(frame: CGRect.zero)
            let testPiece: UIButton = UIButton(frame: CGRect.zero)
            testPiece.contentMode = .scaleAspectFit
            testPiece.clipsToBounds = true
            rowCoord = row
            colCoord = col
            testPiece.translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder decoder: NSCoder) {
            super.init(coder: decoder)
        }
    }
    
    @IBAction func chessPiecePushed(_ sender: piece) {
        //print("debug... chess button pushed... action in chessPiecePushed is now being completed")
        print("row: " + String((sender).rowCoord) + ", col: " + String((sender).colCoord))
        if (sender.backgroundImage(for: UIControlState.normal) == #imageLiteral(resourceName: "KW")) {
            print("This is white")
            sender.setBackgroundImage(#imageLiteral(resourceName: "KB"), for: UIControlState.normal)
        }
        else {
            sender.setBackgroundImage(#imageLiteral(resourceName: "KW"), for: UIControlState.normal)
        }
        if (!pieceIsSelected) {
            selectSquare(row: (sender).rowCoord, col: (sender).colCoord)
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        print("clearing")
        sender.isHidden = true
        pieceIsSelected = false
    }
    
    func selectSquare(row: Int, col: Int) {
        let selectedBox: UIButton = UIButton(frame: CGRect.zero)
        selectedBox.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        selectedBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectedBox)
        selectedBox.isHidden = true
        print("selecting square " + String(row))
        selectedBox.isHidden = false
        selectedBox.leadingAnchor.constraint(equalTo: (margins?.centerXAnchor)!, constant: squareSize*CGFloat((col-4))).isActive = true
        selectedBox.topAnchor.constraint(equalTo: (margins?.centerYAnchor)!, constant: squareSize*CGFloat((row-4-2))).isActive = true
        selectedBox.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
        selectedBox.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
        selectedBox.addTarget(self, action: #selector(self.clear(_:)), for: UIControlEvents.touchUpInside)
        pieceIsSelected = true
        rowSelected = row
        colSelected = col
    }
    
    //MARK: Misc Actions
    
    @IBAction func backButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToMainViewController", sender: self)
    }
    
}

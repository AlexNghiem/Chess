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
        
        //print("debug... portrait width is + /(portraitWidth)")
        //print("debug... portrait height is + /(portraitHeight)")

        //let board: UIImage = UIImage(image: #imageLiteral(resourceName: "chessBoard.png"))
        let squareSize = portraitWidth/10
        /*let topLeftCornerTopCoordinate = portraitHeight/2 - squareSize*4 //will be centered
        let topLeftCornerLeadingCoordinate = portraitWidth/2 - squareSize*4 //will be centered*/
        /*let testImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "defaultPhoto")) //instantiates the uiimageview object of a bishop
        testImageView.frame = CGRect.zero
        testImageView.translatesAutoresizingMaskIntoConstraints = false
        testImageView.contentMode = .scaleAspectFit
        testImageView.clipsToBounds = true

        view.addSubview(testImageView)
        
        testImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: topLeftCornerLeadingCoordinate).isActive = true
        testImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: topLeftCornerTopCoordinate).isActive = true
        testImageView.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
        testImageView.widthAnchor.constraint(equalToConstant: squareSize).isActive = true*/
        
        /*let testPiece: UIButton = UIButton(frame: CGRect.zero)
        testPiece.translatesAutoresizingMaskIntoConstraints = false
        testPiece.contentMode = .scaleAspectFit
        testPiece.clipsToBounds = true
        
        view.addSubview(testPiece)
        
        testPiece.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: topLeftCornerLeadingCoordinate).isActive = true
        testPiece.topAnchor.constraint(equalTo: margins.topAnchor, constant: topLeftCornerTopCoordinate).isActive = true
        testPiece.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
        testPiece.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
        testPiece.setBackgroundImage(#imageLiteral(resourceName: "defaultPhoto"), for: UIControlState.normal)
        
        testPiece.addTarget(self, action: #selector(self.chessPiecePushed(_:)), for: UIControlEvents.touchUpInside)*/
        
        //FOR THE LINE OF CODE INITIALIZING THE PIECE ARRAY, SEE BELOW (it is initialized outside viewdidload)
        //this hopefully means that the piece array can be accessed from anywhere
        
        for row in 0...7 {
            var tempRow = [UIButton?](repeating: nil, count: 8)
            for col in 0...7 {
                /*let testPiece: UIButton = UIButton(frame: CGRect.zero)
                testPiece.translatesAutoresizingMaskIntoConstraints = false
                testPiece.contentMode = .scaleAspectFit
                testPiece.clipsToBounds = true*/
                let testPiece = piece(row: row, col: col)
                testPiece.setBackgroundImage(#imageLiteral(resourceName: "KW"), for: UIControlState.normal)
                /*if (row == 3) { //this is totally arbitrary and just for testing
                    print("hey I'm in the random debug thing") //GOOD THIS WORKS
                    testPiece.setBackgroundImage(#imageLiteral(resourceName: "chess rook"), for: UIControlState.normal)
                }*/
                testPiece.translatesAutoresizingMaskIntoConstraints = false
                
                view.addSubview(testPiece)
                
                testPiece.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: CGFloat(col-4)*squareSize).isActive = true
                testPiece.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: CGFloat(row-4-2)*squareSize).isActive = true
                testPiece.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
                testPiece.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
                
                testPiece.addTarget(self, action: #selector(self.chessPiecePushed(_:)), for: UIControlEvents.touchUpInside)
                
                tempRow[col] = testPiece
            }
            pieceArray.append(tempRow)
        }
        
    }
    
    var pieceArray: [[UIButton?]] = [[UIButton?](repeating: nil, count: 8)]

    
    //MARK: Piece
    
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
    
    //MARK: Chess Board Functions
    /*func redrawBoard(pieces: [[UIButton?]]) {
        for piece in pieces {
            
        }
    }*/
    
    //MARK: Actions
    @IBAction func backButtonPushed(_ sender: UIButton) {
        //print("debug... action backButtonPushed in boardviewcontroller2 is being completed")
        performSegue(withIdentifier: "unwindToBoardViewController", sender: self)
    }
    
    //this method knows what square got clicked
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
    }
}

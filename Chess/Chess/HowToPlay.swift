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
        view.backgroundColor = UIColor.gray
        margins = view.layoutMarginsGuide
        portraitHeight = view.bounds.height
        portraitWidth = view.bounds.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            portraitHeight = view.bounds.width
            portraitWidth = view.bounds.height
        }
        
        showRules()
        
        let chessRulesLabel = UILabel()
        chessRulesLabel.translatesAutoresizingMaskIntoConstraints = false
        chessRulesLabel.text = "Rules of Chess"
        chessRulesLabel.font = UIFont(name: "Helvetica", size: portraitHeight/25) //I like the font this size relative to the screen height
        chessRulesLabel.textColor = UIColor.black
        
        view.addSubview(chessRulesLabel)
        chessRulesLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        chessRulesLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        chessRulesLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: portraitHeight/25).isActive = true //the label needs to be big enough to fit the font
        
        let backButton = UIButton(frame: CGRect.zero)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("back", for: UIControlState.normal)
        backButton.titleLabel?.font = UIFont(name: "Calibri", size: portraitHeight/10) //I like the font this size relative to the screen
        backButton.backgroundColor = UIColor.lightGray
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: portraitWidth/10).isActive = true
        backButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -portraitWidth/10).isActive = true
        backButton.topAnchor.constraint(equalTo: margins.bottomAnchor, constant: -portraitHeight/10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: portraitHeight/10) //sets the height of the back button to 1/10 of the screen
        backButton.addTarget(self, action: #selector(self.backButtonPushed(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func showRules() {
        let buffer = portraitWidth/25 //this looks pretty decent
        
        let scrollView: UIScrollView = UIScrollView()
        scrollView.layer.borderWidth = 2
        scrollView.layer.borderColor = UIColor.black.cgColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let rulesLabel: UILabel = UILabel()
        rulesLabel.translatesAutoresizingMaskIntoConstraints = false
        rulesLabel.text = "How the pieces move:\nEach of the 6 different kinds of pieces moves differently. Pieces cannot move through other pieces (though the knight can jump over other pieces), and can never move onto a square with one of their own pieces. However, they can be moved to take the place of an opponent's piece which is then captured.\nMoving the KING:\nThe king is the most important piece, but is one of the weakest. The king can only move one square in any direction - up, down, to the sides, and diagonally.\nMoving the QUEEN:\nThe queen is the most powerful piece. She can move in any one straight direction - forward, backward, sideways, or diagonally - as far as possible as long as she does not move through any of her own pieces. And, like with all pieces, if the queen captures an opponent's piece her move is over.\nMoving the ROOK:\nThe rook may move as far as it wants, but only forward, backward, and to the sides.\nMoving the BISHOP:\nThe bishop may move as far as it wants, but only diagonally. Each bishop starts on one color (light or dark) and must always stay on that color.\nMoving the KNIGHT:\nKnights move in a very different way from the other pieces – going two squares in one direction, and then one more move at a 90 degree angle, just like the shape of an “L”. Knights are also the only pieces that can move over other pieces.\nMoving the PAWN:\nPawns are unusual because they move and capture in different ways: they move forward, but capture diagonally. Pawns can only move forward one square at a time, except for their very first move where they can move forward two squares. Pawns can only capture one square diagonally in front of them. They can never move or capture backwards. If there is another piece directly in front of a pawn he cannot move past or capture that piece.\nSPECIAL RULES:\nThere are a few extra important rules in chess that only apply in certain circumstances.\nPROMOTION:\nPawns have another special ability and that is that if a pawn reaches the other side of the board it can become any other chess piece (called promotion). A pawn may be promoted to any piece. A common misconception is that pawns may only be exchanged for a piece that has been captured. That is NOT true. A pawn is usually promoted to a queen. Only pawns may be promoted.\nCASTLING:\nOne other special chess rule is called castling. On a player's turn he may move his king two squares over to one side and then move the rook from that side's corner to the opposite side of the king. However, in order to castle, the following conditions must be met:\n1) it must be that king's very first move\n2) it must be that rook's very first move\n3) there cannot be any pieces between the king and rook to move\n4) the king may not be in check or pass through check\nWhen you castle towards the side the king is already on, that is called castling 'kingside'. Castling to the other side, through where the queen sat, is called castling 'queenside'. Regardless of which side, the king always moves only two squares when castling, and the rook always ends up adjacent to the king on the opposite side.\nWinning:\nThe purpose of the game is to checkmate the opponent's king. This happens when the king is put into check and cannot get out of check. There are only three ways a king can get out of check: move out of the way, block the check with another piece, or capture the piece threatening the king. If a king cannot escape checkmate then the game is over. Customarily the king is not captured or removed from the board, the game is simply declared over."
        rulesLabel.font = UIFont(name: "Times New Roman", size: portraitHeight/40) //I like the font this size relative to the screen
        rulesLabel.numberOfLines = 0
        rulesLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        rulesLabel.textColor = UIColor.black
        scrollView.contentSize.height = 1910 //magic number so that it works in the simulator
        //use this VVV if actually putting it on a device
        /*rulesLabel.sizeToFit()
        scrollView.contentSize.height = rulesLabel.frame.height + buffer * 2
        print(rulesLabel.frame.height)*/
        
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor, constant: portraitHeight/10).isActive = true //just below the top of the screen
        scrollView.heightAnchor.constraint(equalToConstant: portraitHeight*3/4).isActive = true //height leaves room for the back button
        
        scrollView.addSubview(rulesLabel)
        rulesLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: buffer).isActive = true
        rulesLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: buffer).isActive = true
        rulesLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -buffer * 2).isActive = true
    }
    
    @IBAction func backButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromHowToPlayToMainViewControllerID", sender: self)
    }
}

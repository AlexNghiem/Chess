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
    let startPiecesString = "rnbqkbnrpppppppp                                PPPPPPPPRNBQKBNR"
    var margins: UILayoutGuide = UILayoutGuide()
    var portraitHeight: CGFloat = 0
    var portraitWidth: CGFloat = 0
    
    var pieceIsSelected = false
    var rowSelected = 0
    var colSelected = 0
    var squareSize: CGFloat = 0.0
    
    var pieceButtonArray = [[UIButton]]()
    let selectedBox: UIButton = UIButton(frame: CGRect.zero)
    var moveOptions = [[UIButton]]()
    let board = chessBoard()
    
    let isPlayingAsWhite = true
    var whiteHasMovedKing = false
    var blackHasMovedKing = false
    
    let upperCaseCharacterSet = CharacterSet.uppercaseLetters
    
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
        squareSize = portraitWidth/10
        
        selectedBox.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        selectedBox.translatesAutoresizingMaskIntoConstraints = false
        selectedBox.isHidden = true
        
        let backButton = UIButton(frame: CGRect.zero)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("back", for: UIControlState.normal)
        backButton.titleLabel?.font = UIFont(name: "Calibri", size: portraitHeight/10)
        backButton.backgroundColor = UIColor.white
        backButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: portraitWidth/10).isActive = true
        backButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -portraitWidth/10).isActive = true
        backButton.topAnchor.constraint(equalTo: margins.bottomAnchor, constant: -portraitHeight/5).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: portraitHeight/10)
        backButton.addTarget(self, action: #selector(self.backButtonPushed(_:)), for: UIControlEvents.touchUpInside)
        
        let board: UIImageView = UIImageView(image: #imageLiteral(resourceName: "chessBoardImage"))
        board.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(board)
        board.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -4*squareSize).isActive = true
        board.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: (-4-2)*squareSize).isActive = true
        board.heightAnchor.constraint(equalToConstant: squareSize*8).isActive = true
        board.widthAnchor.constraint(equalToConstant: squareSize*8).isActive = true
        
        for row in 0...7 {
            var tempButtonRow = [UIButton]()
            var tempViewRow = [UIButton]()
            for col in 0...7 {
                let newPiece = piece(row: row, col: col)
                newPiece.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(newPiece)
                newPiece.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: CGFloat(col-4)*squareSize).isActive = true
                newPiece.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: CGFloat(row-4-2)*squareSize).isActive = true
                newPiece.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
                newPiece.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
                newPiece.addTarget(self, action: #selector(self.chessPiecePushed(_:)), for: UIControlEvents.touchUpInside)
                tempButtonRow.append(newPiece)
                
                let moveOption = option(row: row, col: col)
                moveOption.translatesAutoresizingMaskIntoConstraints = false
                moveOption.isHidden = true
                moveOption.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
                view.addSubview(moveOption)
                moveOption.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: CGFloat(col-4)*squareSize).isActive = true
                moveOption.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: CGFloat(row-4-2)*squareSize).isActive = true
                moveOption.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
                moveOption.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
                moveOption.addTarget(self, action: #selector(self.moveOptionSelected(_:)), for: UIControlEvents.touchUpInside)
                tempViewRow.append(moveOption)
            }
            pieceButtonArray.append(tempButtonRow)
            moveOptions.append(tempViewRow)
        }
        
        //setUpBoard()
        setUpBoardFromString(pieces: startPiecesString)
        refreshBoard()
        
        let url = "http://1718.lakeside-cs.org/Chess_Project_(better_than_checkers)/spaghetti.php"
        func getServerResponse(url: String, parameters: [String: String]) {
            
        }
        var components: URLComponents = URLComponents(string: url)!
        //components.queryItems = ["toMove": "white", "pieces": "RNBQKBNRPPPP PPP            P       p           pppppppprnbqkbnr"].map { (arg) -> URLQueryItem in
        //components.queryItems = ["toMove": "white", "pieces": "RNBQKBNRPPPPPPPP________________________________pppppppprnbqkbnr"].map { (arg) -> URLQueryItem in
        components.queryItems = ["toMove": "white", "pieces": "spaghet", "castleWhiteKingside" : "true", "castleWhiteQueenside" : "true", "castleBlackKingside" : "true", "castleBlackQueenside" : "true"].map { (arg) -> URLQueryItem in
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
            rowCoord = row
            colCoord = col
        }
        
        required init?(coder decoder: NSCoder) {
            super.init(coder: decoder)
        }
    }
    
    class chessBoard {
        var pieceArray = [[Character]](repeating: [Character](repeating: " ", count: 8), count: 8)
        init() {
            
        }
    }
    
    class square {
        var row = 0
        var col = 0
        init(row: Int, col: Int) {
            self.row = row
            self.col = col
        }
    }
    
    class option: UIButton {
        var row = 0
        var col = 0
        init(row: Int, col: Int) {
            super.init(frame: CGRect.zero)
            self.row = row
            self.col = col
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func checkMoveLegal(rowClicked: Int, colClicked: Int) -> Bool {
        return true
    }
    
    func inCheck() {
        
    }
    
    func boardContainsSquare(row: Int, col: Int) -> Bool {
        return ((row >= 0) && (row <= 7) && (col >= 0) && (col <= 7))
    }
    
    //returns the array of squares that the piece in the specified square can make
    func getMoveArray(row: Int, col: Int) -> [square] {
        if board.pieceArray[row][col] == "R" {
            return rookMoveArray(row: row, col: col)
        }
        if board.pieceArray[row][col] == "N" {
            return knightMoveArray(row: row, col: col)
        }
        if board.pieceArray[row][col] == "B" {
            return bishopMoveArray(row: row, col: col)
        }
        if board.pieceArray[row][col] == "Q" {
            return rookMoveArray(row: row, col: col) + bishopMoveArray(row:row, col:col)
        }
        if board.pieceArray[row][col] == "K" {
            return kingMoveArray(row: row, col: col)
        }
        if board.pieceArray[row][col] == "P" {
            return pawnMoveArray(row: row, col: col)
        }
        return [square]()
    }
    
    func rookMoveArray(row: Int, col: Int) -> [square] {
        let uppercase = CharacterSet.uppercaseLetters
        var moveArray: [square] = [square]()
        var colIterator = col
        posColIterator: while (true) {
            colIterator = colIterator + 1
            if (!boardContainsSquare(row: row, col: colIterator) || uppercase.contains(board.pieceArray[row][colIterator].unicodeScalars.first!)) {
                break posColIterator
            }
            else {
                moveArray.append(square(row: row, col: colIterator))
                if (board.pieceArray[row][colIterator] != " ") {
                    break posColIterator
                }
            }
        }
        colIterator = col
        negColIterator: while (true) {
            colIterator = colIterator - 1
            if (!boardContainsSquare(row: row, col: colIterator) || uppercase.contains(board.pieceArray[row][colIterator].unicodeScalars.first!)) {
                break negColIterator
            }
            else {
                moveArray.append(square(row: row, col: colIterator))
                if (board.pieceArray[row][colIterator] != " ") {
                    break negColIterator
                }
            }
        }
        var rowIterator = row
        posRowIterator: while (true) {
            rowIterator = rowIterator + 1
            if (!boardContainsSquare(row: rowIterator, col: col) || uppercase.contains(board.pieceArray[rowIterator][col].unicodeScalars.first!)) {
                break posRowIterator
            }
            else {
                moveArray.append(square(row: rowIterator, col: col))
                if (board.pieceArray[rowIterator][col] != " ") {
                    break posRowIterator
                }
            }
        }
        rowIterator = row
        negRowIterator: while (true) {
            rowIterator = rowIterator - 1
            if (!boardContainsSquare(row: rowIterator, col: col) || uppercase.contains(board.pieceArray[rowIterator][col].unicodeScalars.first!)) {
                break negRowIterator
            }
            else {
                moveArray.append(square(row: rowIterator, col: col))
                if (board.pieceArray[rowIterator][col] != " ") {
                    break negRowIterator
                }
            }
        }
        return moveArray
    }
    
    func knightMoveArray(row: Int, col: Int) -> [square] {
        let uppercase = CharacterSet.uppercaseLetters
        var moveArray = [square]()
        //the first four options are tall, the second four are wide
        //each grouping of four options starts in the NE quadrant and cycles counterclockwise
        for option in 0...7 {
            var rowChange = 1 + (option / 4)
            var colChange = 2 - (option / 4)
            if ((option / 2) % 2 == 0) {
                rowChange = -rowChange
            }
            if (((option + 1) / 2) % 2 == 1) {
                colChange = -colChange
            }
            if (boardContainsSquare(row: row + rowChange, col: col + colChange) && !uppercase.contains(board.pieceArray[row + rowChange][col + colChange].unicodeScalars.first!)) {
                moveArray.append(square(row: row + rowChange, col: col + colChange))
            }
        }
        return moveArray
    }
    
    func bishopMoveArray(row: Int, col: Int) -> [square] {
        let uppercase = CharacterSet.uppercaseLetters
        var moveArray: [square] = [square]()
        var rowIterator = row
        var colIterator = col
        NEIterator: while (true) {
            colIterator = colIterator + 1
            rowIterator = rowIterator - 1
            if (!boardContainsSquare(row: rowIterator, col: colIterator) || uppercase.contains(board.pieceArray[rowIterator][colIterator].unicodeScalars.first!)) {
                break NEIterator
            }
            else {
                moveArray.append(square(row: rowIterator, col: colIterator))
                if (board.pieceArray[rowIterator][colIterator] != " ") {
                    break NEIterator
                }
            }
        }
        rowIterator = row
        colIterator = col
        SEIterator: while (true) {
            colIterator = colIterator + 1
            rowIterator = rowIterator + 1
            if (!boardContainsSquare(row: rowIterator, col: colIterator) || uppercase.contains(board.pieceArray[rowIterator][colIterator].unicodeScalars.first!)) {
                break SEIterator
            }
            else {
                moveArray.append(square(row: rowIterator, col: colIterator))
                if (board.pieceArray[rowIterator][colIterator] != " ") {
                    break SEIterator
                }
            }
        }
        rowIterator = row
        colIterator = col
        SWIterator: while (true) {
            colIterator = colIterator - 1
            rowIterator = rowIterator + 1
            if (!boardContainsSquare(row: rowIterator, col: colIterator) || uppercase.contains(board.pieceArray[rowIterator][colIterator].unicodeScalars.first!)) {
                break SWIterator
            }
            else {
                moveArray.append(square(row: rowIterator, col: colIterator))
                if (board.pieceArray[rowIterator][colIterator] != " ") {
                    break SWIterator
                }
            }
        }
        rowIterator = row
        colIterator = col
        NWIterator: while (true) {
            colIterator = colIterator - 1
            rowIterator = rowIterator - 1
            if (!boardContainsSquare(row: rowIterator, col: colIterator) || uppercase.contains(board.pieceArray[rowIterator][colIterator].unicodeScalars.first!)) {
                break NWIterator
            }
            else {
                moveArray.append(square(row: rowIterator, col: colIterator))
                if (board.pieceArray[rowIterator][colIterator] != " ") {
                    break NWIterator
                }
            }
        }
        return moveArray
    }
    
    func kingMoveArray(row: Int, col: Int) -> [square] {
        let uppercase = CharacterSet.uppercaseLetters
        var moveArray: [square] = [square]()
        for rowChange in -1...1 {
            for colChange in -1...1 {
                if (boardContainsSquare(row: row + rowChange, col: col + colChange) && !uppercase.contains(board.pieceArray[row + rowChange][col + colChange].unicodeScalars.first!)) {
                    moveArray.append(square(row: row + rowChange, col: col + colChange))
                }
            }
        }
        return moveArray
    }
    
    func pawnMoveArray(row: Int, col: Int) -> [square] {
        let lowercase = CharacterSet.lowercaseLetters
        var moveArray: [square] = [square]()
        if (board.pieceArray[row - 1][col] == " ") {
            moveArray.append(square(row: row - 1, col: col))
            if (row == 6 && board.pieceArray[row-2][col] == " ") {
                moveArray.append(square(row: row - 2, col: col))
            }
        }
        if (boardContainsSquare(row: row - 1, col: col - 1) && lowercase.contains(board.pieceArray[row - 1][col - 1].unicodeScalars.first!)) {
            moveArray.append(square(row: row - 1, col: col - 1))
        }
        if (boardContainsSquare(row: row - 1, col: col + 1) && lowercase.contains(board.pieceArray[row - 1][col + 1].unicodeScalars.first!)) {
            moveArray.append(square(row: row - 1, col: col + 1))
        }
        return moveArray
    }

    func setUpBoardFromString(pieces: String) {
        for row in 0...7 {
            for col in 0...7 {
                board.pieceArray[row][col] = pieces[pieces.index(pieces.startIndex, offsetBy: row * 8 + col)]
            }
        }
    }
    
    func refreshBoard() {
        for row in 0...7 {
            for col in 0...7 {
                if board.pieceArray[row][col] == "R" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "RW"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "N" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "NW"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "B" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "BW"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "Q" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "QW"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "K" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "KW"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "P" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "PW"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "r" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "RB"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "n" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "NB"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "b" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "BB"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "q" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "QB"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "k" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "KB"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == "p" {
                    pieceButtonArray[row][col].setBackgroundImage(#imageLiteral(resourceName: "PB"), for: UIControlState.normal)
                }
                if board.pieceArray[row][col] == " " {
                    pieceButtonArray[row][col].setBackgroundImage(nil, for: UIControlState.normal)
                }
            }
        }
    }
    
    //MARK: Selecting square
    
    @IBAction func moveOptionSelected(_ sender: option) {
        clearOptions()
        board.pieceArray[sender.row][sender.col] = board.pieceArray[rowSelected][colSelected]
        board.pieceArray[rowSelected][colSelected] = " "
        clearSelectedBox(nil)
        refreshBoard()
    }
    
    @IBAction func chessPiecePushed(_ sender: piece) {
        print("row: " + String((sender).rowCoord) + ", col: " + String((sender).colCoord))
        if (!pieceIsSelected) {
            if (board.pieceArray[sender.rowCoord][sender.colCoord] != " ") {
                selectSquare(row: (sender).rowCoord, col: (sender).colCoord)
            }
        }
    }
    
    @IBAction func clearSelectedBox(_ sender: Any?) {
        selectedBox.isHidden = true
        pieceIsSelected = false
        clearOptions()
    }
    
    func selectSquare(row: Int, col: Int) {
        selectedBox.removeFromSuperview()
        view.addSubview(selectedBox)
        selectedBox.isHidden = false
        pieceIsSelected = true
        selectedBox.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: squareSize*CGFloat((col-4))).isActive = true
        selectedBox.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: squareSize*CGFloat((row-4-2))).isActive = true
        selectedBox.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
        selectedBox.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
        selectedBox.addTarget(self, action: #selector(self.clearSelectedBox(_:)), for: UIControlEvents.touchUpInside)
        pieceIsSelected = true
        rowSelected = row
        colSelected = col
        displayOptions(row: row, col: col)
    }
    
    func displayOptions(row: Int, col: Int) {
        for square in getMoveArray(row: row, col: col) {
            moveOptions[square.row][square.col].isHidden = false
        }
    }
    
    func clearOptions() {
        for row in moveOptions {
            for square in row {
                square.isHidden = true
            }
        }
    }
    
    //MARK: Misc Actions
    
    @IBAction func backButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToMainViewController", sender: self)
    }
    
}

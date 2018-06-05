//
//  BoardViewController.swift
//  Chess
//
//  Created by Alexander Nghiem on 4/2/18.
//  Copyright © 2018 Alex, Justin, Eric. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

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
    
    let playerBox : UILabel = UILabel() //shows user id
    
    var pieceButtonArray = [[UIButton]]() //the piece buttons
    let selectedBox: UIButton = UIButton() //the orange box which shows which piece is being selected
    var moveOptions = [[UIButton]]() //the buttons which show up when a piece is selected showing legal moves
    var board = chessBoard()
    var tempBoard: chessBoard = chessBoard()
    
    //promotion options
    let cancelPromoteOption: UIButton = UIButton()
    let knightPromoteOption: UIButton = UIButton()
    let bishopPromoteOption: UIButton = UIButton()
    let rookPromoteOption: UIButton = UIButton()
    let queenPromoteOption: UIButton = UIButton()
    var colToPromote: Int = 0
    var promoteOptionSize: CGFloat = 0
    
    //random important things to store
    let isPlayingAsWhite = true
    var whiteCanCastleKing = true
    var whiteCanCastleQueen = true
    var blackCanCastleKing = true
    var blackCanCastleQueen = true
    var waiting = false //whether the player is waiting for the computer to make a move
    
    let upperCaseCharacterSet = CharacterSet.uppercaseLetters
    let lowerCaseCharacterSet = CharacterSet.lowercaseLetters
    
    let DEBUGMODE: Bool = true //set to true to make illegal moves, or moves while the computer is thinking (for testing), otherwise for actual play set to false
    
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
        squareSize = portraitWidth/10 //this is the size of a square on the board
        promoteOptionSize = squareSize * 1.5 //size of the promotion option buttons
        
        showPlayerName()
        
        selectedBox.backgroundColor = UIColor.yellow.withAlphaComponent(0.5) //slightly translucent yellow box
        selectedBox.translatesAutoresizingMaskIntoConstraints = false
        selectedBox.isHidden = true
        
        //back button
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("back", for: UIControlState.normal)
        backButton.titleLabel?.font = UIFont(name: "Calibri", size: portraitHeight/10) // 1/10 of the height tall
        backButton.backgroundColor = UIColor.white
        backButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: portraitWidth/10).isActive = true // 1/10 of the way from the margin
        backButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -portraitWidth/10).isActive = true // 1/10 of the way from the margin
        backButton.topAnchor.constraint(equalTo: margins.bottomAnchor, constant: -portraitHeight/5).isActive = true // 1/5 of the way above the bottom
        backButton.heightAnchor.constraint(equalToConstant: portraitHeight/10) // 1/10 of the height tall
        backButton.addTarget(self, action: #selector(self.backButtonPushed(_:)), for: UIControlEvents.touchUpInside)
        
        let boardImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "chessBoardImage"))
        boardImage.transform = CGAffineTransform(scaleX: -1, y: 1) //the picture is not mirrored properly so this transforms it
        boardImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardImage)
        boardImage.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -4*squareSize).isActive = true //center of screen is to the top left of (4,6) on the board
        boardImage.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: (-4-2)*squareSize).isActive = true //center of screen is to the top left of (4,6) on the board
        //chess boards are 8x8
        boardImage.heightAnchor.constraint(equalToConstant: squareSize*8).isActive = true
        boardImage.widthAnchor.constraint(equalToConstant: squareSize*8).isActive = true

        //places the buttons on each square
        for row in 0...7 {
            var tempButtonRow = [UIButton]()
            var tempViewRow = [UIButton]()
            for col in 0...7 {
                let newPiece = piece(row: row, col: col)
                newPiece.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(newPiece)
                newPiece.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: CGFloat(col-4)*squareSize).isActive = true //center of screen is to the top left of (4,6) on the board
                newPiece.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: CGFloat(row-4-2)*squareSize).isActive = true //center of screen is to the top left of (4,6) on the board
                newPiece.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
                newPiece.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
                newPiece.addTarget(self, action: #selector(self.chessPiecePushed(_:)), for: UIControlEvents.touchUpInside)
                tempButtonRow.append(newPiece)
                
                let moveOption = option(row: row, col: col)
                moveOption.translatesAutoresizingMaskIntoConstraints = false
                moveOption.isHidden = true
                moveOption.backgroundColor = UIColor.orange.withAlphaComponent(0.5) //changes how opaque/transparent the move options are
                view.addSubview(moveOption)
                moveOption.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: CGFloat(col-4)*squareSize).isActive = true //center of screen is to the top left of (4,6) on the board
                moveOption.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: CGFloat(row-4-2)*squareSize).isActive = true //center of screen is to the top left of (4,6) on the board
                moveOption.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
                moveOption.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
                moveOption.addTarget(self, action: #selector(self.moveOptionSelected(_:)), for: UIControlEvents.touchUpInside)
                tempViewRow.append(moveOption)
            }
            pieceButtonArray.append(tempButtonRow)
            moveOptions.append(tempViewRow)
        }
        //creates the promotion options
        cancelPromoteOption.isHidden = true
        knightPromoteOption.isHidden = true
        bishopPromoteOption.isHidden = true
        rookPromoteOption.isHidden = true
        queenPromoteOption.isHidden = true
        view.addSubview(cancelPromoteOption)
        view.addSubview(knightPromoteOption)
        view.addSubview(bishopPromoteOption)
        view.addSubview(rookPromoteOption)
        view.addSubview(queenPromoteOption)
        cancelPromoteOption.translatesAutoresizingMaskIntoConstraints = false
        knightPromoteOption.translatesAutoresizingMaskIntoConstraints = false
        bishopPromoteOption.translatesAutoresizingMaskIntoConstraints = false
        rookPromoteOption.translatesAutoresizingMaskIntoConstraints = false
        queenPromoteOption.translatesAutoresizingMaskIntoConstraints = false
        knightPromoteOption.setBackgroundImage(#imageLiteral(resourceName: "NW"), for: UIControlState.normal)
        bishopPromoteOption.setBackgroundImage(#imageLiteral(resourceName: "BW"), for: UIControlState.normal)
        rookPromoteOption.setBackgroundImage(#imageLiteral(resourceName: "RW"), for: UIControlState.normal)
        queenPromoteOption.setBackgroundImage(#imageLiteral(resourceName: "QW"), for: UIControlState.normal)
        let height = CGFloat(Double(squareSize)*(-6)) - promoteOptionSize //this is the height of the top of the promotion options
        cancelPromoteOption.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        cancelPromoteOption.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        cancelPromoteOption.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        cancelPromoteOption.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        knightPromoteOption.heightAnchor.constraint(equalToConstant: promoteOptionSize).isActive = true
        knightPromoteOption.widthAnchor.constraint(equalToConstant: promoteOptionSize).isActive = true
        knightPromoteOption.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: height).isActive = true
        bishopPromoteOption.heightAnchor.constraint(equalToConstant: promoteOptionSize).isActive = true
        bishopPromoteOption.widthAnchor.constraint(equalToConstant: promoteOptionSize).isActive = true
        bishopPromoteOption.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: height).isActive = true
        rookPromoteOption.heightAnchor.constraint(equalToConstant: promoteOptionSize).isActive = true
        rookPromoteOption.widthAnchor.constraint(equalToConstant: promoteOptionSize).isActive = true
        rookPromoteOption.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: height).isActive = true
        queenPromoteOption.heightAnchor.constraint(equalToConstant: promoteOptionSize).isActive = true
        queenPromoteOption.widthAnchor.constraint(equalToConstant: promoteOptionSize).isActive = true
        queenPromoteOption.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: height).isActive = true
        knightPromoteOption.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -2*promoteOptionSize).isActive = true
        bishopPromoteOption.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -promoteOptionSize).isActive = true
        rookPromoteOption.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        queenPromoteOption.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: promoteOptionSize).isActive = true
        cancelPromoteOption.addTarget(self, action: #selector(self.cancelPromotion(_:)), for: UIControlEvents.touchUpInside)
        knightPromoteOption.addTarget(self, action: #selector(self.promoteKnight(_:)), for: UIControlEvents.touchUpInside)
        bishopPromoteOption.addTarget(self, action: #selector(self.promoteBishop(_:)), for: UIControlEvents.touchUpInside)
        rookPromoteOption.addTarget(self, action: #selector(self.promoteRook(_:)), for: UIControlEvents.touchUpInside)
        queenPromoteOption.addTarget(self, action: #selector(self.promoteQueen(_:)), for: UIControlEvents.touchUpInside)
        
        //setUpBoard()
        board = setUpBoardFromString(boardToSet: board, pieces: startPiecesString)
        refreshBoard()
    }
    
    //MARK: Errors
    
    enum ChessError: Error {
        case kingNotFound
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
        func getString(useUnderscores: Bool) -> String {
            var pieces = ""
            for row in 0...7 {
                for col in 0...7 {
                    if (useUnderscores && self.pieceArray[row][col] == " ") {
                        pieces = pieces + "_"
                    }
                    else {
                        pieces = pieces + String(self.pieceArray[row][col])
                    }
                }
            }
            return pieces
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
    
    //MARK: Server Logic
    
    func updateBoardFromServerResponse() {
        waiting = true //stop the player from making moves
        //check if can castle
        if (board.pieceArray[7][0] != "R" || board.pieceArray[7][4] != "K") {
            whiteCanCastleQueen = false
        }
        if (board.pieceArray[7][4] != "K" || board.pieceArray[7][7] != "R") {
            whiteCanCastleKing = false
        }
        //this is the url which contains the code we want to run
        let url = "http://1718.lakeside-cs.org/Chess_Project_(better_than_checkers)/spaghetti.php"
        // ok tbh the next few lines are mostly black magic...
        var components: URLComponents = URLComponents(string: url)!
        //these variables in the query are simply taken from the variables stored on the client side
        components.queryItems = ["pieces": board.getString(useUnderscores: true), "castleWhiteKingside" : (whiteCanCastleKing ? "true" : "false"), "castleWhiteQueenside" : (whiteCanCastleQueen ? "true" : "false"), "castleBlackKingside" : (blackCanCastleKing ? "true" : "false"), "castleBlackQueenside" : (blackCanCastleQueen ? "true" : "false")].map { (arg) -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value)
        }
        let request: URLRequest = URLRequest(url: components.url!)
        print(request)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if(error != nil) {
                print(error as Any)
            }
            else {
                if let content = data {
                    do {
                        let Json = try JSONSerialization.jsonObject(with: content, options: .allowFragments) as AnyObject
                        let returnString: String? = Json as? String
                        if let unwrappedReturnString = returnString {
                            //more black magic here
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                print(unwrappedReturnString)
                                self.board = self.setUpBoardFromString(boardToSet: self.board, pieces: unwrappedReturnString)
                                if (self.inCheck(boardToCheck: self.board, white: false)) { //if the board is returned such that the opponent is in check, then the player wins
                                    self.gameOver(won: true)
                                }
                                else if (self.playerCheckmated(boardToCheck: self.board)) { //if the player has been checkmated, then the player loses
                                    self.gameOver(won: false)
                                }
                                else { //only refresh the board if the game is still going
                                    self.refreshBoard()
                                }
                                self.waiting = false //let the player make a move again
                            }
                        }
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func playerCheckmated(boardToCheck: chessBoard) -> Bool {
        refreshBoard()
        if (inCheck(boardToCheck: boardToCheck, white: true)) {
            for row in 0...7 {
                for col in 0...7 {
                    if (upperCaseCharacterSet.contains(board.pieceArray[row][col].unicodeScalars.first!)) {
                        if (getMoveArray(row: row, col: col).count != 0) {
                            return false //return false if there are any pieces which have legal moves
                        }
                    }
                }
            }
            return true
        }
        return false
    }
    
    //MARK: Board Logic
    
    func checkMoveLegal(rowFrom: Int, colFrom: Int, rowToCheck: Int, colToCheck: Int) -> Bool {
        tempBoard = setUpBoardFromString(boardToSet: chessBoard(), pieces: board.getString(useUnderscores: false))
        tempBoard.pieceArray[rowToCheck][colToCheck] = tempBoard.pieceArray[rowFrom][colFrom]
        tempBoard.pieceArray[rowFrom][colFrom] = " "
        return !inCheck(boardToCheck: tempBoard, white: true)
    }
    
    //I am deeply sorry for this method... it has a bunch of junky hard-coding, but to be fair it is hard to eliminate all redundancy and magic numbers from this kind of method. The rules of chess are just resistant to programmatic encoding. I just did whatever made sense to me at the time. If I had to come back to this, I would probably just re-write it honestly
    func inCheck(boardToCheck: chessBoard, white: Bool) -> Bool {
        if let king = try? findKing(boardToCheck: boardToCheck, white: white) {
            //ROOKS
            var piece: Character = " "
            var colIterator = king.col
            posColIterator: while (true) {
                colIterator = colIterator + 1
                if (!boardContainsSquare(row: king.row, col: colIterator)) {
                    break posColIterator
                }
                else {
                    piece = boardToCheck.pieceArray[king.row][colIterator]
                    if (piece != " ") {
                        if ((white && (piece == "r" || piece == "q")) || (!white && (piece == "R" || piece == "Q"))) {
                            return true
                        }
                        break posColIterator
                    }
                }
            }
            colIterator = king.col
            negColIterator: while (true) {
                colIterator = colIterator - 1
                if (!boardContainsSquare(row: king.row, col: colIterator)) {
                    break negColIterator
                }
                else {
                    piece = boardToCheck.pieceArray[king.row][colIterator]
                    if (piece != " ") {
                        if ((white && (piece == "r" || piece == "q")) || (!white && (piece == "R" || piece == "Q"))) {
                            return true
                        }
                        break negColIterator
                    }
                }
            }
            var rowIterator = king.row
            posRowIterator: while (true) {
                rowIterator = rowIterator + 1
                if (!boardContainsSquare(row: rowIterator, col: king.col)) {
                    break posRowIterator
                }
                else {
                    piece = boardToCheck.pieceArray[rowIterator][king.col]
                    if (piece != " ") {
                        if ((white && (piece == "r" || piece == "q")) || (!white && (piece == "R" || piece == "Q"))) {
                            return true
                        }
                        break posRowIterator
                    }
                }
            }
            rowIterator = king.row
            negRowIterator: while (true) {
                rowIterator = rowIterator - 1
                if (!boardContainsSquare(row: rowIterator, col: king.col)) {
                    break negRowIterator
                }
                else {
                    piece = boardToCheck.pieceArray[rowIterator][king.col]
                    if (piece != " ") {
                        if ((white && (piece == "r" || piece == "q")) || (!white && (piece == "R" || piece == "Q"))) {
                            return true
                        }
                        break negRowIterator
                    }
                }
            }
            //KNIGHTS
            for option in 0...7 {
                var rowChange = 1 + (option / 4)
                var colChange = 2 - (option / 4)
                if ((option / 2) % 2 == 0) {
                    rowChange = -rowChange
                }
                if (((option + 1) / 2) % 2 == 1) {
                    colChange = -colChange
                }
                if (boardContainsSquare(row: king.row + rowChange, col: king.col + colChange) && ((white && boardToCheck.pieceArray[king.row + rowChange][king.col + colChange] == "n") || (!white && boardToCheck.pieceArray[king.row + rowChange][king.col + colChange] == "N"))) {
                    return true
                }
            }
            //BISHOPS
            for direction in 0...3 { //0 starts in NE quadrant and goes CCW
                rowIterator = king.row
                colIterator = king.col
                directionIterator: while (true) {
                    rowIterator = rowIterator + (direction / 2 == 0 ? (-1) : (+1))
                    colIterator = colIterator + (((direction + 1) % 4) / 2 == 0 ? (+1) : (-1))
                    if (!boardContainsSquare(row: rowIterator, col: colIterator)) {
                        break directionIterator
                    }
                    else {
                        piece = boardToCheck.pieceArray[rowIterator][colIterator]
                        if (piece != " ") {
                            if ((white && (piece == "b" || piece == "q")) || (!white && (piece == "B" || piece == "Q"))) {
                                return true
                            }
                            break directionIterator
                        }
                    }
                }
            }
            //PAWNS
            if ((boardContainsSquare(row: king.row - 1, col: king.col - 1) && ((white && boardToCheck.pieceArray[king.row - 1][king.col - 1] == "p") || (!white && boardToCheck.pieceArray[king.row - 1][king.col - 1] == "P"))) || (boardContainsSquare(row: king.row - 1, col: king.col + 1) && ((white && boardToCheck.pieceArray[king.row - 1][king.col + 1] == "p") || (!white && boardToCheck.pieceArray[king.row - 1][king.col + 1] == "P")))) {
                return true
            }
            //KINGS
            for rowChange in -1...1 {
                for colChange in -1...1 {
                    if (boardContainsSquare(row: king.row + rowChange, col: king.col + colChange)) {
                        if ((white && (boardToCheck.pieceArray[king.row + rowChange][king.col + colChange] == "k")) || (!white && (boardToCheck.pieceArray[king.row + rowChange][king.col + colChange] == "K"))) {
                            return true
                        }
                    }
                }
            }
            return false
        }
        else {
            return true
        }
    }
    
    //gets the square the king is on
    func findKing(boardToCheck: chessBoard, white: Bool) throws -> square {
        for row in 0...7 {
            for col in 0...7 {
                if ((white && boardToCheck.pieceArray[row][col] == "K") || (!white && boardToCheck.pieceArray[row][col] == "k")) {
                    return square(row: row, col: col)
                }
            }
        }
        throw ChessError.kingNotFound
    }
    
    //checks if the board contains the given square
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
    
    //rip this is kind of redundant but it makes a lot of sense to do it this way
    func rookMoveArray(row: Int, col: Int) -> [square] {
        var moveArray: [square] = [square]()
        var colIterator = col
        posColIterator: while (true) {
            colIterator = colIterator + 1
            if (!boardContainsSquare(row: row, col: colIterator) || upperCaseCharacterSet.contains(board.pieceArray[row][colIterator].unicodeScalars.first!)) {
                break posColIterator
            }
            else {
                if (checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: row, colToCheck: colIterator)) {
                    moveArray.append(square(row: row, col: colIterator))
                }
                if (board.pieceArray[row][colIterator] != " ") {
                    break posColIterator
                }
            }
        }
        colIterator = col
        negColIterator: while (true) {
            colIterator = colIterator - 1
            if (!boardContainsSquare(row: row, col: colIterator) || upperCaseCharacterSet.contains(board.pieceArray[row][colIterator].unicodeScalars.first!)) {
                break negColIterator
            }
            else {
                if (checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: row, colToCheck: colIterator)) {
                    moveArray.append(square(row: row, col: colIterator))
                }
                if (board.pieceArray[row][colIterator] != " ") {
                    break negColIterator
                }
            }
        }
        var rowIterator = row
        posRowIterator: while (true) {
            rowIterator = rowIterator + 1
            if (!boardContainsSquare(row: rowIterator, col: col) || upperCaseCharacterSet.contains(board.pieceArray[rowIterator][col].unicodeScalars.first!)) {
                break posRowIterator
            }
            else {
                if (checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: rowIterator, colToCheck: col)) {
                    moveArray.append(square(row: rowIterator, col: col))
                }
                if (board.pieceArray[rowIterator][col] != " ") {
                    break posRowIterator
                }
            }
        }
        rowIterator = row
        negRowIterator: while (true) {
            rowIterator = rowIterator - 1
            if (!boardContainsSquare(row: rowIterator, col: col) || upperCaseCharacterSet.contains(board.pieceArray[rowIterator][col].unicodeScalars.first!)) {
                break negRowIterator
            }
            else {
                if (checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: rowIterator, colToCheck: col)) {
                    moveArray.append(square(row: rowIterator, col: col))
                }
                if (board.pieceArray[rowIterator][col] != " ") {
                    break negRowIterator
                }
            }
        }
        return moveArray
    }
    
    func knightMoveArray(row: Int, col: Int) -> [square] {
        var moveArray = [square]()
        //the first four options are tall, the second four are wide
        //each grouping of four options starts in the NE quadrant and cycles counterclockwise
        for option in 0...7 {
            var rowChange = 1 + (option / 4) //sorry that this math is super confusing... basically its decoding the information from the index of the for loop
            var colChange = 2 - (option / 4)
            if ((option / 2) % 2 == 0) {
                rowChange = -rowChange
            }
            if (((option + 1) / 2) % 2 == 1) {
                colChange = -colChange
            }
            if (boardContainsSquare(row: row + rowChange, col: col + colChange) && checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: row + rowChange, colToCheck: col + colChange) && !upperCaseCharacterSet.contains(board.pieceArray[row + rowChange][col + colChange].unicodeScalars.first!)) {
                moveArray.append(square(row: row + rowChange, col: col + colChange))
            }
        }
        return moveArray
    }
    
    func bishopMoveArray(row: Int, col: Int) -> [square] {
        var moveArray: [square] = [square]()
        var rowIterator = row
        var colIterator = col
        NEIterator: while (true) {
            colIterator = colIterator + 1
            rowIterator = rowIterator - 1
            if (!boardContainsSquare(row: rowIterator, col: colIterator) || upperCaseCharacterSet.contains(board.pieceArray[rowIterator][colIterator].unicodeScalars.first!)) {
                break NEIterator
            }
            else {
                if (checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: rowIterator, colToCheck: colIterator)) {
                    moveArray.append(square(row: rowIterator, col: colIterator))
                }
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
            if (!boardContainsSquare(row: rowIterator, col: colIterator) || upperCaseCharacterSet.contains(board.pieceArray[rowIterator][colIterator].unicodeScalars.first!)) {
                break SEIterator
            }
            else {
                if (checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: rowIterator, colToCheck: colIterator)) {
                    moveArray.append(square(row: rowIterator, col: colIterator))
                }
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
            if (!boardContainsSquare(row: rowIterator, col: colIterator) || upperCaseCharacterSet.contains(board.pieceArray[rowIterator][colIterator].unicodeScalars.first!)) {
                break SWIterator
            }
            else {
                if (checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: rowIterator, colToCheck: colIterator)) {
                    moveArray.append(square(row: rowIterator, col: colIterator))
                }
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
            if (!boardContainsSquare(row: rowIterator, col: colIterator) || upperCaseCharacterSet.contains(board.pieceArray[rowIterator][colIterator].unicodeScalars.first!)) {
                break NWIterator
            }
            else {
                if (checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: rowIterator, colToCheck: colIterator)) {
                    moveArray.append(square(row: rowIterator, col: colIterator))
                }
                if (board.pieceArray[rowIterator][colIterator] != " ") {
                    break NWIterator
                }
            }
        }
        return moveArray
    }
    
    func kingMoveArray(row: Int, col: Int) -> [square] {
        var moveArray: [square] = [square]()
        for rowChange in -1...1 {
            for colChange in -1...1 {
                if (boardContainsSquare(row: row + rowChange, col: col + colChange) && !upperCaseCharacterSet.contains(board.pieceArray[row + rowChange][col + colChange].unicodeScalars.first!) && checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: row + rowChange, colToCheck: col + colChange)) {
                    moveArray.append(square(row: row + rowChange, col: col + colChange))
                }
            }
        }
        //dumb hard-coded castling stuff (I couldn't think of a more efficient way to do this)
        if (whiteCanCastleKing && !inCheck(boardToCheck: board, white: true) && board.pieceArray[7][5] == " " && board.pieceArray[7][6] == " " && checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: 7, colToCheck: 5) && checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: 7, colToCheck: 6)) {
            moveArray.append(square(row: 7, col: 6))
        }
        if (whiteCanCastleQueen && !inCheck(boardToCheck: board, white: true) && board.pieceArray[7][3] == " " && board.pieceArray[7][2] == " " && board.pieceArray[7][1] == " " && checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: 7, colToCheck: 3) && checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: 7, colToCheck: 2)) {
            moveArray.append(square(row: 7, col: 2))
        }
        return moveArray
    }
    
    func pawnMoveArray(row: Int, col: Int) -> [square] {
        var moveArray: [square] = [square]()
        if (board.pieceArray[row - 1][col] == " " && checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: row - 1, colToCheck: col)) {
            moveArray.append(square(row: row - 1, col: col))
            if (row == 6 && board.pieceArray[row-2][col] == " " && checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: row - 2, colToCheck: col)) {
                moveArray.append(square(row: row - 2, col: col))
            }
        }
        if (boardContainsSquare(row: row - 1, col: col - 1) && lowerCaseCharacterSet.contains(board.pieceArray[row - 1][col - 1].unicodeScalars.first!) && checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: row - 1, colToCheck: col - 1)) {
            moveArray.append(square(row: row - 1, col: col - 1))
        }
        if (boardContainsSquare(row: row - 1, col: col + 1) && lowerCaseCharacterSet.contains(board.pieceArray[row - 1][col + 1].unicodeScalars.first!) && checkMoveLegal(rowFrom: row, colFrom: col, rowToCheck: row - 1, colToCheck: col + 1)) {
            moveArray.append(square(row: row - 1, col: col + 1))
        }
        return moveArray
    }

    func setUpBoardFromString(boardToSet: chessBoard, pieces: String) -> chessBoard{
        for row in 0...7 { //iterates through board
            for col in 0...7 {
                boardToSet.pieceArray[row][col] = pieces[pieces.index(pieces.startIndex, offsetBy: row * 8 + col)] //gets the piece at the specific row and col from the piece string
                if (pieces[pieces.index(pieces.startIndex, offsetBy: row * 8 + col)] == "_") {
                    boardToSet.pieceArray[row][col] = " "
                }
            }
        }
        return boardToSet
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
        if (board.pieceArray[rowSelected][colSelected] == "P") {
            if (sender.row == 0) {
                colToPromote = sender.col
                showPromoteOptions()
                return
            }
        }
        clearSelectedBox(nil)
        if (board.pieceArray[7][0] != "R" || board.pieceArray[7][4] != "K") {
            whiteCanCastleQueen = false
        }
        if (board.pieceArray[7][4] != "K" || board.pieceArray[7][7] != "R") {
            whiteCanCastleKing = false
        }
        board.pieceArray[sender.row][sender.col] = board.pieceArray[rowSelected][colSelected]
        board.pieceArray[rowSelected][colSelected] = " "
        if (sender.row == 7 && rowSelected == 7) { //if going from last row to last row
            if (whiteCanCastleKing && colSelected == 4 && sender.col == 6) { //if trying to move king in a kingside castle
                board.pieceArray[7][4] = " "
                board.pieceArray[7][5] = "R"
                board.pieceArray[7][6] = "K"
                board.pieceArray[7][7] = " "
                whiteCanCastleQueen = false
                whiteCanCastleKing = false
            }
            if (whiteCanCastleQueen && colSelected == 4 && sender.col == 2) { //if trying to move king in a queenside castle
                board.pieceArray[7][0] = " "
                board.pieceArray[7][1] = " "
                board.pieceArray[7][2] = "K"
                board.pieceArray[7][3] = "R"
                board.pieceArray[7][4] = " "
                whiteCanCastleQueen = false
                whiteCanCastleKing = false
            }
        }
        refreshBoard()
        updateBoardFromServerResponse()
    }
    
    //when a chess piece is pushed --> this is a lot simpler if debugmode didnt exist... it would essentially collapse down into the one statement of selecting the square if a couple conditions are met
    @IBAction func chessPiecePushed(_ sender: piece) {
        print("row: " + String((sender).rowCoord) + ", col: " + String((sender).colCoord))
        if (!pieceIsSelected) {
            if (DEBUGMODE && board.pieceArray[sender.rowCoord][sender.colCoord] != " ") {
                selectSquare(row: (sender).rowCoord, col: (sender).colCoord)
            }
            if (!waiting && upperCaseCharacterSet.contains(board.pieceArray[sender.rowCoord][sender.colCoord].unicodeScalars.first!)) {
                selectSquare(row: (sender).rowCoord, col: (sender).colCoord) //this is the only line that can be triggered if debugmode is off
            }
        }
        else if (DEBUGMODE) {
            clearOptions()
            board.pieceArray[sender.rowCoord][sender.colCoord] = board.pieceArray[rowSelected][colSelected]
            board.pieceArray[rowSelected][colSelected] = " "
            clearSelectedBox(nil)
            refreshBoard()
        }
    }
    
    @IBAction func clearSelectedBox(_ sender: Any?) {
        selectedBox.isHidden = true
        pieceIsSelected = false
        clearOptions()
    }
    
    func showPromoteOptions() {
        moveOptions[0][colToPromote].isHidden = false
        cancelPromoteOption.isHidden = false
        knightPromoteOption.isHidden = false
        bishopPromoteOption.isHidden = false
        rookPromoteOption.isHidden = false
        queenPromoteOption.isHidden = false
    }
    
    @IBAction func cancelPromotion(_ sender: UIButton) {
        cancelPromoteOption.isHidden = true
        knightPromoteOption.isHidden = true
        bishopPromoteOption.isHidden = true
        rookPromoteOption.isHidden = true
        queenPromoteOption.isHidden = true
        selectSquare(row: rowSelected, col: colSelected)
    }
    
    @IBAction func promoteKnight(_ sender: UIButton) {
        promote(piece: "N")
    }
    
    @IBAction func promoteBishop(_ sender: UIButton) {
        promote(piece: "B")
    }
    
    @IBAction func promoteRook(_ sender: UIButton) {
        promote(piece: "R")
    }
    
    @IBAction func promoteQueen(_ sender: UIButton) {
        promote(piece: "Q")
    }
    
    func promote(piece: Character) {
        cancelPromoteOption.isHidden = true
        knightPromoteOption.isHidden = true
        bishopPromoteOption.isHidden = true
        rookPromoteOption.isHidden = true
        queenPromoteOption.isHidden = true
        board.pieceArray[rowSelected][colSelected] = " "
        board.pieceArray[0][colToPromote] = piece
        selectedBox.isHidden = true
        pieceIsSelected = false
        clearOptions()
        refreshBoard()
        updateBoardFromServerResponse()
    }
    
    func selectSquare(row: Int, col: Int) {
        selectedBox.removeFromSuperview()
        view.addSubview(selectedBox)
        selectedBox.isHidden = false
        pieceIsSelected = true
        selectedBox.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: squareSize*CGFloat((col-4))).isActive = true //center of screen is to the top left of (4,6) on the board
        selectedBox.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: squareSize*CGFloat((row-6))).isActive = true //center of screen is to the top left of (4,6) on the board
        selectedBox.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
        selectedBox.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
        selectedBox.addTarget(self, action: #selector(self.clearSelectedBox(_:)), for: UIControlEvents.touchUpInside)
        pieceIsSelected = true
        rowSelected = row
        colSelected = col
        if (!waiting) {
            displayOptions(row: row, col: col)
        }
    }
    
    func displayOptions(row: Int, col: Int) {
        clearOptions()
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
    
    func showPlayerName() {
        playerBox.translatesAutoresizingMaskIntoConstraints = false
        if(Auth.auth().currentUser == nil)
        {
            playerBox.text = "Playing as: Guest"
        }
        else
        {
            playerBox.text = "Playing as: " + (Auth.auth().currentUser?.email)!
        }
        playerBox.adjustsFontSizeToFitWidth = true
        playerBox.font = UIFont(name: "Helvetica", size: portraitHeight/36) //font size
        playerBox.textColor = UIColor.white
        playerBox.textAlignment = NSTextAlignment.center
        view.addSubview(playerBox)
        playerBox.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        playerBox.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        playerBox.topAnchor.constraint(equalTo: margins.topAnchor, constant: portraitHeight/30).isActive = true //sets the height of the top of the player name
    }
    
    @IBAction func backButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromBoardViewControllerToMainViewControllerID", sender: self)
    }
    
    func gameOver(won: Bool) {
        waiting = true
        let gameOverMessage = UILabel()
        gameOverMessage.translatesAutoresizingMaskIntoConstraints = false
        gameOverMessage.text = "You won!"
        if (!won) {
            gameOverMessage.text = "You lost..."
        }
        gameOverMessage.font = UIFont(name: "Helvetica", size: portraitHeight/15) //i like this font size
        gameOverMessage.textColor = UIColor.white
        view.addSubview(gameOverMessage)
        gameOverMessage.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        gameOverMessage.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: portraitWidth/4).isActive = true //this places the game over message right below the board
    }
}

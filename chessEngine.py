# Eric Zhu Justin Sanders
# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""


from enum import Enum
import time
import itertools
import json as js
import sys

def isOnBoard(x,y):
    return (x >= 0 and x <= 7 and y >= 0 and y<=7)

totalTime = 0
totalTime2 = 0
timesCalled = 0


class Color(Enum):
     WHITE = 1
     BLACK = 2
     NONE = 3

class Piece:
    value = 0
    color = Color.WHITE
    def __init__(self,color):
        self.color=color

class Empty(Piece):
    printStr = '_'
    def __init__(self,color):
        super(Empty, self).__init__(color)

class Queen(Piece):
    printStr = 'Q'
    def __init__(self,color):
        super(Queen, self).__init__(color)
        self.value = 9

class King(Piece):
    hasMoved = False
    printStr = 'K'
    def __init__(self,color):
        super(King, self).__init__(color)
        self.value = 100000
    
class Rook(Piece):
    hasMoved = False
    printStr = 'R'
    def __init__(self,color):
        super(Rook, self).__init__(color)
        self.value = 5
    
class Night(Piece):
    printStr = 'N'
    def __init__(self,color):
        super(Night, self).__init__(color)
        self.value = 3

class Bishop(Piece):
    printStr = 'B'
    def __init__(self,color):
        super(Bishop, self).__init__(color)
        self.value = 3
    

class Pawn(Piece):
    hasMoved = False
    printStr = 'P'
    def __init__(self,color):
        super(Pawn, self).__init__(color)
        self.value = 1

class Board:
    
    def resetBoard(self):
        for i in range (0,8):
            self.position[1][i] = Pawn(Color.WHITE)
            self.position[6][i] = Pawn(Color.BLACK)
            for j in range (2,6):
                self.position[j][i] = Empty(Color.NONE)
        self.position[0][0] = Rook(Color.WHITE)
        self.position[0][7] = Rook(Color.WHITE)
        self.position[0][1] = Night(Color.WHITE)
        self.position[0][6] = Night(Color.WHITE)
        self.position[0][2] = Bishop(Color.WHITE)
        self.position[0][5] = Bishop(Color.WHITE)
        self.position[0][3] = Queen(Color.WHITE)
        self.position[0][4] = King(Color.WHITE)
        self.position[7][0] = Rook(Color.BLACK)
        self.position[7][7] = Rook(Color.BLACK)
        self.position[7][1] = Night(Color.BLACK)
        self.position[7][6] = Night(Color.BLACK)
        self.position[7][2] = Bishop(Color.BLACK)
        self.position[7][5] = Bishop(Color.BLACK)
        self.position[7][3] = Queen(Color.BLACK)
        self.position[7][4] = King(Color.BLACK)
    
    def getNextBoards(self):
        if(self.over == False):
            for i in range (0,8):
                for j in range (0,8):
                    if(self.position[i][j].color == self.currentTurn):
                        #Defines how a King moves
                        if (type(self.position[i][j]) is King):
                            self.tryAddBoard(i,j,i+1,j+1)
                            self.tryAddBoard(i,j,i+1,j)
                            self.tryAddBoard(i,j,i+1,j-1)
                            self.tryAddBoard(i,j,i,j+1)
                            self.tryAddBoard(i,j,i,j-1)
                            self.tryAddBoard(i,j,i-1,j-1) 
                            self.tryAddBoard(i,j,i-1,j)
                            self.tryAddBoard(i,j,i-1,j+1)
                        
                        #Defines how a Queen moves
                        if (type(self.position[i][j]) is Queen):
                            x = i
                            y = j
                            while (True):
                                x += 1
                                y += 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,x,y)):
                                    break
                            x = i
                            y = j
                            while (True):
                                x -= 1
                                y -= 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,x,y)):
                                    break
                            x = i
                            y = j
                            while (True):
                                x += 1
                                y -= 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,x,y)):
                                    break
                            x = i
                            y = j
                            while (True):
                                x -= 1
                                y += 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,x,y)):
                                    break
                            upi = i
                            downi = i
                            rightj = j
                            leftj = j
                            while (True):
                                upi += 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,upi,j)):
                                    break
                            while (True):
                                downi -= 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,downi,j)):
                                    break
                            while (True):
                                rightj += 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,i,rightj)):
                                    break
                            while (True):
                                leftj -= 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,i,leftj)):
                                    break
                            
                        #Defines how a rook moves
                        if (type(self.position[i][j]) is Rook):
                            upi = i
                            downi = i
                            rightj = j
                            leftj = j
                            while (True):
                                upi += 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,upi,j)):
                                    break
                            while (True):
                                downi -= 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,downi,j)):
                                    break
                            while (True):
                                rightj += 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,i,rightj)):
                                    break
                            while (True):
                                leftj -= 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,i,leftj)):
                                    break                            
                        
                        #Defines how a kNight moves
                        if (type(self.position[i][j]) is Night):
                            if(self.tryAddBoard(i,j,i+2,j+1)):
                                self.bonusScore[1] += 0.01
                            if(self.tryAddBoard(i,j,i+2,j-1)):
                                self.bonusScore[1] += 0.01
                            if(self.tryAddBoard(i,j,i+1,j+2)):
                                self.bonusScore[1] += 0.01
                            if(self.tryAddBoard(i,j,i+1,j-2)):
                                self.bonusScore[1] += 0.01
                            if(self.tryAddBoard(i,j,i-1,j+2)):
                                self.bonusScore[1] += 0.01
                            if(self.tryAddBoard(i,j,i-1,j-2)):
                                self.bonusScore[1] += 0.01
                            if(self.tryAddBoard(i,j,i-2,j+1)):
                                self.bonusScore[1] += 0.01
                            if(self.tryAddBoard(i,j,i-2,j-1)):
                                self.bonusScore[1] += 0.01
                            
                        #Defines how a Bishop moves
                        if (type(self.position[i][j]) is Bishop):
                            x = i
                            y = j
                            while (True):
                                x += 1
                                y += 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,x,y)):
                                    break
                            x = i
                            y = j
                            while (True):
                                x -= 1
                                y -= 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,x,y)):
                                    break
                            x = i
                            y = j
                            while (True):
                                x += 1
                                y -= 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,x,y)):
                                    break
                            x = i
                            y = j
                            while (True):
                                x -= 1
                                y += 1
                                self.bonusScore[1] += 0.015
                                if(not self.tryAddBoard(i,j,x,y)):
                                    break
                        
                        #Defines how a Pawn moves
                        if (type(self.position[i][j]) is Pawn):
                            if(self.currentTurn == Color.WHITE):
                                self.bonusScore[1] += 0.003*i
                                if(type(self.position[i+1][j]) is Empty):
                                    if(i+1 < 7):
                                        self.tryAddBoard(i,j,i+1,j)                                   
                                    if(i+1 == 7):
                                        newBoard = self.deepCopy()
                                        newBoard.nextBoards = []
                                        newBoard.position[i][j] = self.empty
                                        newBoard.position[i+1][j] = Queen(self.currentTurn)
                                        #newBoard.countScore()
                                        if(self.currentTurn == Color.WHITE):
                                            newBoard.currentTurn = Color.BLACK
                                        else:
                                            newBoard.currentTurn = Color.WHITE
                                        self.nextBoards.append(newBoard)
                                        
                                if(isOnBoard(i+1,j+1) and self.position[i+1][j+1].color != self.currentTurn and self.position[i+1][j+1].color != Color.NONE):
                                    if(i+1 < 7):
                                        self.tryAddBoard(i,j,i+1,j+1)                                  
                                    if(i+1 == 7):
                                        newBoard = self.deepCopy()
                                        newBoard.nextBoards = []
                                        newBoard.position[i][j] = self.empty
                                        newBoard.position[i+1][j+1] = Queen(self.currentTurn)
                                        #newBoard.countScore()
                                        if(self.currentTurn == Color.WHITE):
                                            newBoard.currentTurn = Color.BLACK
                                        else:
                                            newBoard.currentTurn = Color.WHITE
                                        self.nextBoards.append(newBoard)
                                        
                                if(isOnBoard(i+1,j-1) and self.position[i+1][j-1].color != self.currentTurn and self.position[i+1][j-1].color != Color.NONE):
                                    if(i+1 < 7):
                                        self.tryAddBoard(i,j,i+1,j-1)                                  
                                    if(i+1 == 7):
                                        newBoard = self.deepCopy()
                                        newBoard.nextBoards = []
                                        newBoard.position[i][j] = self.empty
                                        newBoard.position[i+1][j-1] = Queen(self.currentTurn)
                                        #newBoard.countScore()
                                        if(self.currentTurn == Color.WHITE):
                                            newBoard.currentTurn = Color.BLACK
                                        else:
                                            newBoard.currentTurn = Color.WHITE
                                        self.nextBoards.append(newBoard)
                            
                            elif(self.currentTurn == Color.BLACK):
                                self.bonusScore[1] += 0.003*(i-7)
                                if(type(self.position[i-1][j]) is Empty):
                                    if(i-1 > 0):
                                        self.tryAddBoard(i,j,i-1,j)                                   
                                    if(i-1 == 0):
                                        newBoard = self.deepCopy()
                                        newBoard.nextBoards = []
                                        newBoard.position[i][j] = self.empty
                                        newBoard.position[i-1][j] = Queen(self.currentTurn)
                                        #newBoard.countScore()
                                        if(self.currentTurn == Color.WHITE):
                                            newBoard.currentTurn = Color.BLACK
                                        else:
                                            newBoard.currentTurn = Color.WHITE
                                        self.nextBoards.append(newBoard)
                                        
                                if(isOnBoard(i-1,j+1) and self.position[i-1][j+1].color != self.currentTurn and self.position[i-1][j+1].color != Color.NONE):
                                    if(i-1 > 0):
                                        self.tryAddBoard(i,j,i-1,j+1)                                  
                                    if(i-1 == 0):
                                        newBoard = self.deepCopy()
                                        newBoard.nextBoards = []
                                        newBoard.position[i][j] = self.empty
                                        newBoard.position[i-1][j+1] = Queen(self.currentTurn)
                                        #newBoard.countScore()
                                        if(self.currentTurn == Color.WHITE):
                                            newBoard.currentTurn = Color.BLACK
                                        else:
                                            newBoard.currentTurn = Color.WHITE
                                        self.nextBoards.append(newBoard)
                                        
                                if(isOnBoard(i-1,j-1) and self.position[i-1][j-1].color != self.currentTurn and self.position[i-1][j-1].color != Color.NONE):
                                    if(i-1 > 0):
                                        self.tryAddBoard(i,j,i-1,j-1)                                  
                                    if(i-1 == 0):
                                        newBoard = self.deepCopy()
                                        newBoard.nextBoards = []
                                        newBoard.position[i][j] = self.empty
                                        newBoard.position[i-1][j-1] = Queen(self.currentTurn)
                                        #newBoard.countScore()
                                        if(self.currentTurn == Color.WHITE):
                                            newBoard.currentTurn = Color.BLACK
                                        else:
                                            newBoard.currentTurn = Color.WHITE
                                        self.nextBoards.append(newBoard)                                    
                            else:
                                print("Malformed board")
                                print(self.currentTurn)
                            if(i == 6 and self.currentTurn == Color.BLACK and type(self.position[i-1][j]) is Empty and type(self.position[i-2][j]) is Empty):
                                self.tryAddBoard(i,j,i-2,j)
                            elif(i == 1 and self.currentTurn == Color.WHITE and type(self.position[i+1][j]) is Empty and type(self.position[i+2][j]) is Empty):
                                self.tryAddBoard(i,j,i+2,j)
    
    def tryAddBoard(self,i,j,x,y):
        if(isOnBoard(x,y) and self.position[x][y].color != self.currentTurn):
            #startTime = time.time()
            newBoard = self.deepCopy()
            position = self.position

            #totalTime += time.time() - startTime
            newBoard.nextBoards = []
            b = (type(position[x][y]) is Empty)
            if(type(position[i][j]) is Pawn or type(position[i][j]) is Rook or type(self.position[i][j]) is King):
                newBoard.position[i][j].hasMoved = True
            if(type(position[x][y]) is King):
                newBoard.over = True
            newBoard.position[x][y] = newBoard.position[i][j]
            newBoard.position[i][j] = self.empty
            
            #slow cause happens every time...
            #print(newBoard.score)
            newBoard.score = sum([piece.value if piece.color == newBoard.playingAs else piece.value*-1 for piece in itertools.chain.from_iterable(newBoard.position)])
            
            #print(newBoard.score)
            
            if(self.currentTurn == Color.WHITE):
                newBoard.currentTurn = Color.BLACK
                newBoard.givenScore = self.givenScore
                newBoard.bonusScore = [0,0]
            else:
                newBoard.currentTurn = Color.WHITE
                newBoard.givenScore = self.bonusScore
                newBoard.bonusScore = [0,0]
            self.nextBoards.append(newBoard)
            return b 
        return False
               
    def countScore(self):
        #self.score = sum([sum([piece.value for piece in row if piece.color == self.playingAs]) for row in self.position])
        self.score = sum([piece.value if piece.color == self.playingAs else piece.value*-1 for piece in itertools.chain.from_iterable(self.position)])
        
        '''
        for i in range (0,8):
            for j in range (0,8):
                if(self.position[i][j].color == Color.WHITE):
                    self.whiteScore += self.position[i][j].value
                elif (self.position[i][j].color == Color.BLACK):
                    self.blackScore += self.position[i][j].value
        
        if(self.playingAs == Color.WHITE):
            self.score = self.whiteScore - self.blackScore
        if(self.playingAs == Color.BLACK):
            self.score = self.blackScore - self.whiteScore
        '''

        
    def gameOver(self):
        whiteking = True
        blackking = True
        for i in range (0,8):
            for j in range (0,8):
                if (type(self.position[i][j]) is King):
                    if(self.position[i][j].color == Color.BLACK):
                        blackking = False
                    elif(self.position[i][j].color == Color.WHITE):
                        whiteking = False
        if(whiteking or blackking):
            self.over = True
    
    def deepCopy(self):
        #global totalTime
        #global totalTime2
        #global timesCalled
        #startTime = time.time()
        current = Board(self.playingAs,self.empty)
        #totalTime += time.time() - startTime
        #startTime = time.time()
        #print("Before")
        #printBoard(self)
        
        
        
        current.position = list(map(list,self.position))
        #[x[:] for x in self.position]
        
        #for i in range (0,len(self.position)):
            #for j in range (0,len(self.position[i])):
                #current.position[i][j] = self.position[i][j]
                
                
                
        #print("After")
        #printBoard(current)
        #sys.exit()
        #for i in range (0,8):
         #   current.position[] = x[:]   
        #totalTime2 += time.time() - startTime
        return current
    
    def __init__(self,playingAs,empty):
        #TODO might be slow
        #global totalTime
        #global totalTime2
        #global timesCalled
        blah = self
        blah.playingAs = playingAs
        blah.position = [[[],[],[],[],[],[],[],[]],
                         [[],[],[],[],[],[],[],[]],
                         [[],[],[],[],[],[],[],[]],
                         [[],[],[],[],[],[],[],[]],
                         [[],[],[],[],[],[],[],[]],
                         [[],[],[],[],[],[],[],[]],
                         [[],[],[],[],[],[],[],[]],
                         [[],[],[],[],[],[],[],[]]]
        #[[[] for i in range(8)] for k in range(8)]
        blah.score = 0
        blah.over = False
        blah.inCheck = Color.NONE #is a Color if true
        blah.currentTurn = playingAs
        blah.nextBoards = []
        blah.bonusScore = [0,0]
        blah.givenScore = [0,0]
        blah.empty = empty
        #startTime = time.time()        
        #self.position = np.array(self.position)
        #totalTime += time.time() - startTime
        
def printBoard(current):
    for i in range(0,8):
        for j in range (0,8):
            print(current.position[i][j].printStr,end = '')   
        print()
    #print(current.score)
    #print("--------------------")
    print()
    
def stringBoard(current):
    string = ""
    for i in range(0,8):
        for j in range (0,8):
            if(current.position[i][j].color == Color.BLACK):
                string += current.position[i][j].printStr.lower()
            else:
                string += current.position[i][j].printStr
    return string[::-1]



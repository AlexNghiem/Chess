# Eric Zhu Justin Sanders
# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
from enum import Enum
import time
import itertools



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
    blackScore = 0
    whiteScore = 0
    score = 0
    position = 1
    over = False
    inCheck = Color.NONE #is a Color if true
    currentTurn = Color.WHITE
    nextBoards = []
    playingAs = Color.WHITE
    bonusScore = [0,0]
    givenScore = [0,0]
    
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
        #self.gameOver()
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
                                        newBoard.position[i][j] = Empty(Color.NONE)
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
                                        newBoard.position[i][j] = Empty(Color.NONE)
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
                                        newBoard.position[i][j] = Empty(Color.NONE)
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
                                        newBoard.position[i][j] = Empty(Color.NONE)
                                        newBoard.position[i-1][j] = Queen(self.currentTurn)
                                        #newBoard.countScore()
                                        if(self.currentTurn == Color.WHITE):
                                            newBoard.currentTurn = Color.BLACK
                                        else:
                                            newBoard.currentTurn = Color.WHITE
                                        self.nextBoards.append(newBoard)
                                        
                                if(isOnBoard(i-1,j+1) and self.position[i-1][j+1].color != self.currentTurn and self.position[i-1][j+1].color != Color.NONE):
                                    if(i-1 > 0):
                                        self.tryAddBoard(i,j,i+1,j+1)                                  
                                    if(i-1 == 0):
                                        newBoard = self.deepCopy()
                                        newBoard.nextBoards = []
                                        newBoard.position[i][j] = Empty(Color.NONE)
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
                                        newBoard.position[i][j] = Empty(Color.NONE)
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
        global totalTime
        global timesCalled
        if(isOnBoard(x,y) and self.position[x][y].color != self.currentTurn):
            #startTime = time.time()
            newBoard = self.deepCopy()
            #totalTime += time.time() - startTime
            newBoard.nextBoards = []
            b = (type(self.position[x][y]) is Empty)
            if(type(self.position[i][j]) is Pawn or type(self.position[i][j]) is Rook or type(self.position[i][j]) is King):
                newBoard.position[i][j].hasMoved = True
            newBoard.position[x][y] = newBoard.position[i][j]
            newBoard.position[i][j] = Empty(Color.NONE)
            
            #slow cause happens every time...
            #print(newBoard.score)
            newBoard.countScore()
            #print(newBoard.score)
            newBoard.givenScore = self.bonusScore
            newBoard.bonusScore = [0,0]
            
            
            if(self.currentTurn == Color.WHITE):
                newBoard.currentTurn = Color.BLACK
            else:
                newBoard.currentTurn = Color.WHITE
            self.nextBoards.append(newBoard)
            timesCalled += 1
            return b 
        return False
               
    def countScore(self):
        self.blackScore = 0
        self.whiteScore = 0
        #self.score = sum([sum([piece.value for piece in row if piece.color == self.playingAs]) for row in self.position])
        self.score = sum([piece.value for piece in itertools.chain.from_iterable(self.position) if piece.color == self.playingAs])
        
        
        '''for i in range (0,8):
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

    def wipeBoard(self):
        for i in range (0,8):
            for j in range (0,8):
                self.position[i][j] = Empty(Color.NONE)
    
    def deepCopy(self):
        #global totalTime
        #global totalTime2
        #global timesCalled
        #startTime = time.time()
        current = Board(self.playingAs)
        #totalTime += time.time() - startTime
        #startTime = time.time()
        #print("Before")
        #printBoard(self)
        
        
        
        current.position = [x[:] for x in self.position]
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
    
    def __init__(self,playingAs):
        #TODO might be slow
        #global totalTime
        #global totalTime2
        #global timesCalled
        self.playingAs = playingAs
        self.position = [[[]for i in range(8)] for k in range(8)]
        #startTime = time.time()        
        #self.position = np.array(self.position)
        #totalTime += time.time() - startTime
        
def printBoard(current):
    for i in range(0,8):
        for j in range (0,8):
            print(current.position[i][j].printStr,end = '')
        print()
    print()
    print("--------------------")
    print()

number = 0
current = Board(Color.WHITE)
current.resetBoard()
#current.wipeBoard()
current.position[1][4] = Empty(Color.NONE)
current.position[6][4] = Empty(Color.NONE)
current.position[3][4] = Pawn(Color.WHITE)
current.position[4][4] = Pawn(Color.BLACK)
printBoard(current)
current.getNextBoards()

'''
for x in current.nextBoards:
    print(x.givenScore)
    print(x.bonusScore)

'''

start = time.time()
current.getNextBoards()#White moves
for x in current.nextBoards:
    x.getNextBoards() #Black moves
    if (len(x.nextBoards) == 0):
            printBoard(x)
    lowesty = 10000000
    for y in x.nextBoards:
        y.getNextBoards() #White moves
        if (len(y.nextBoards) == 0):
            printBoard(y)
        highestz = 0
        for z in y.nextBoards:          
            z.getNextBoards() #Black moves
            #print(z.bonusScore)
            #print(z.nextBoards[0].givenScore[1])
            #print(z.nextBoards[4].givenScore[1])
            #print(z.nextBoards[8].givenScore[1])
            if(len(z.nextBoards) > 0):
                lowestw = z.nextBoards[0].score + z.nextBoards[0].givenScore[1]
            for w in z.nextBoards:
                if (w.score + w.givenScore[1] < lowestw):
                    lowestw = w.score + w.givenScore[1]
                    #print(w.givenScore[1])
            z.score = lowestw
            #print (z.score)
            if (z.score > highestz):
                highestz = z.score
        y.score = highestz
        if (y.score < lowesty):
            lowesty = y.score
    x.score = lowesty   
    print(x.score)  
    printBoard(x)
        
print("tryAddBoard number: " + str(timesCalled))
print("loop time: " + str(totalTime2))
print("constructor time: " + str(totalTime))
end = time.time()
print("Total time: " + str(end - start))
    




'''

print(current.whiteScore)
current.countScore()
print(current.whiteScore)
print(current.score)
'''


    
#print(current.i)
#print(current.position)

# -*- coding: utf-8 -*-
"""
Created on Fri Mar  9 09:06:39 2018

@author: justi
"""
from chessEngine import *
import sys
import json as js

#arg v : , board, whiteQueenside, whiteKingside, blackQueenside, blackQueenside

def solveTree(current,depth,a,b,maximize):
    if(current.over or depth == 0):
        return (current.score + current.givenScore[1])
    
    if(maximize):
        #print("Hi")
        val = -10000000000
        current.getNextBoards()
        for board in current.nextBoards:
            #print("Hello")
            val = maxValue(val,solveTree(board,depth-1,a,b,False))
            a = maxValue(a,val)
            if (b <= a):
                break
        current.score = val
        return val
    else:
        #print("Hi2")
        val = 10000000000
        current.getNextBoards()
        for board in current.nextBoards:
            #print("Hello")
            val = minValue(val,solveTree(board,depth-1,a,b,True))
            a = minValue(a,val)
            if (b <= a):
                break
        current.score = val
        return val

def maxValue(a,b):
    if(a > b):
        return a
    return b

def minValue(a,b):
    if(a < b):
        return a
    return b

if(sys.argv[2] == 'true'):
    whiteQueenside = True
else:
    whiteQueenside = False

if(sys.argv[3] == 'true'):
    whiteKingside = True
else:
    whiteKingside = False
    
if(sys.argv[4] == 'true'):
    blackQueenside = True
else:
    blackQueenside = False

if(sys.argv[5] == 'true'):
    blackKingside = True
else:
    blackKingside = False
    
InputBoard = sys.argv[1]

current = Board(Color.BLACK)

for x in range(0,8):
    for y in range(0,8):
        char = inputBoard[x*8+y]
        if(char == "P"):
            current.position[7-x][7-y] = Pawn(Color.WHITE)
        if(char == "p"):
            current.position[7-x][7-y] = Pawn(Color.BLACK)
        if(char == "R"):
            current.position[7-x][7-y] = Rook(Color.WHITE)
        if(char == "r"):
            current.position[7-x][7-y] = Rook(Color.BLACK)
        if(char == "B"):
            current.position[7-x][7-y] = Bishop(Color.WHITE)
        if(char == "b"):
            current.position[7-x][7-y] = Bishop(Color.BLACK)
        if(char == "Q"):
            current.position[7-x][7-y] = Queen(Color.WHITE)
        if(char == "q"):
            current.position[7-x][7-y] = Queen(Color.BLACK)
        if(char == "K"):
            current.position[7-x][7-y] = King(Color.WHITE)
        if(char == "k"):
            current.position[7-x][7-y] = King(Color.BLACK)
        if(char == "N"):
            current.position[7-x][7-y] = Night(Color.WHITE)
        if(char == "n"):
            current.position[7-x][7-y] = Night(Color.BLACK)
        if(char == "_"):
            current.position[7-x][7-y] = Empty(Color.NONE)

#print("current:")
#printBoard(current)

#print("bestMoveVal:")
solveTree(current,4,-100000000000,100000000000,True)

bestBoard = current.nextBoards[0]
for board in current.nextBoards:
    if(board.score > bestBoard.score):
        bestBoard = board
#print("bestMove:")
print(js.dumps(stringBoard(bestBoard)))
#print(js.dumps("spahet"))


    
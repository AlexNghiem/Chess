# -*- coding: utf-8 -*-
"""
Created on Fri Mar  9 09:06:39 2018

@author: justi
"""
from Git.chessEngine import *

current = Board(Color.WHITE)
current.resetBoard()
current.position[1][4] = Empty(Color.NONE)
current.position[6][4] = Empty(Color.NONE)
current.position[3][4] = Pawn(Color.WHITE)
current.position[4][4] = Pawn(Color.BLACK)
printBoard(current)
current.getNextBoards()#White moves
for x in current.nextBoards:
    x.getNextBoards() #Black moves
    lowesty = x.nextBoards[0].score
    for y in x.nextBoards:
        y.getNextBoards() #White moves
        highestz = y.nextBoards[0].score
        for z in y.nextBoards:          
            z.getNextBoards() #Black moves
            if(len(z.nextBoards) > 0):
                lowestw = z.nextBoards[0].score
            for w in z.nextBoards:
                if (w.score < lowestw):
                    lowestw = w.score
            z.score = lowestw
            if (z.score > highestz):
                highestz = z.score
        y.score = highestz
        if (y.score < lowesty):
            lowesty = y.score
    x.score = lowesty   
    #print(x.score)  
    #printBoard(x)
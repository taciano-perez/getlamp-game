
 10 REM INIT VARIABLES
 15 REM LOCATION DESCRIPTION (LD), LOCATION (L)
 20 DIM LD$ ( 4 ) : DIM LE ( 4, 4 ) 
 25 L=1 
 30 DATA "an empty office. There is a door to the south and a locked door to the east.","the stock room. There is a door to the north."
 32 DATA "a dark room. You cannot see a thing.","the world outside!" 
 40 FOR I=1 TO 4
 50 READ LD$ ( I ) 
 60 NEXT I
 46 REM LOCATION EXITS (LE)
 48 REM N(1),S(2),E(3),W(4)
 50 DATA 0,2,0,0
 52 DATA 1,0,0,0
 54 DATA 0,0,0,1
 56 DATA 3,0,0,0
 58 FOR I=1 TO 4
 60 FOR J=1 TO 4
 62 READ LE ( I, J )
 64 NEXT J
 66 NEXT I
 70 REM OBJECTS OBJ COUNT (OC), OBJ DESCRIPTION (OD$), OBJ LOCATION (OL) OL=0=PLAYER
 72 OC = 2 : DIM OD$ ( OC ) : DIM OL ( OC )
 74 DATA 1, "a lamp", 2, "a key"
 76 FOR I=1 TO OC
 78 READ OL ( I ) : READ OD$ ( I )
 80 NEXT I
 90 HOME
 95 PRINT "   *** GET LAMP - A (SHORT) TEXT ADVENTURE ***"
 100 REM MAIN LOOP
 105 PRINT ""
 110 PRINT "You are in " ;LD$( L ) 
 115 GOSUB 1100 : REM DISPLAY OBJECTS
 120 INPUT "> " ;IN$
 130 OK = 0
 140 IF LEFT$ ( IN$, 2 ) = "GO" THEN OK = 1 : GOSUB 1000 : REM GO COMMAND
 150 IF LEFT$ ( IN$, 3 ) = "INV" THEN OK = 1 : GOSUB 1200 : REM INVENTORY COMMAND
 152 IF LEFT$ ( IN$, 4 ) = "TAKE" OR LEFT$ ( IN$, 3 ) = "GET" THEN OK = 1 : GOSUB 1300 : REM TAKE COMMAND
 154 IF LEFT$ ( IN$, 4 ) = "DROP" THEN OK = 1 : GOSUB 1400 : REM DROP COMMAND
 156 IF IN$ = "LIGHT LAMP" THEN OK = 1 : GOSUB 1600 : REM LIGHT LAMP COMMAND
 158 IF IN$ = "UNLOCK DOOR" THEN OK = 1 : GOSUB 1700 : REM UNLOCK DOOR COMMAND
 160 IF IN$ = "HELP" THEN OK = 1 : GOSUB 1800 : REM HELP COMMAND
 170 IF OK = 0 THEN PRINT "What?"
 200 REM CONTINUE GAME?
 210 IF L <> 4 GOTO 100
 220 PRINT "You are in " ;LD$( L ) 
 230 PRINT "Congratulations, you have won the game!"
 250 END
 1000 REM *** GO COMMAND SUBROUTINE ***
 1030 BUF=L
 1040 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 5 ) = "NORTH" THEN L=LE ( L, 1 )
 1042 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 5 ) = "SOUTH" THEN L=LE ( L, 2 )
 1044 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 4 ) = "EAST" THEN L=LE ( L, 3 )
 1046 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 4 ) = "WEST" THEN L=LE ( L, 4 )
 1048 IF L = 0 THEN L=BUF : PRINT "You cannot go in that direction."
 1090 RETURN
 1100 REM *** DISPLAY OBJECTS SUBROUTINE ***
 1110 FOR I=1 TO OC
 1112 IF OL ( I ) = L THEN PRINT "You see "; OD$ ( I ) 
 1130 NEXT I
 1150 RETURN
 1200 REM *** INVENTORY COMMAND SUBROUTINE ***
 1210 PRINT "You are carrying:"
 1220 FOR I=1 TO OC
 1230 IF OL ( I ) = 0 THEN PRINT " "; OD$ ( I ) 
 1240 NEXT I
 1250 RETURN
 1300 REM *** TAKE COMMAND SUBROUTINE ***
 1305 GOSUB 1500 : REM IDENTIFY OBJECT
 1310 IF OL ( OBJ ) = L THEN OL ( OBJ ) = 0 : PRINT "You have picked up "; OD$ ( OBJ ) : RETURN
 1380 PRINT "You don't see that object in here." : REM Either we do not know this object or it is not here
 1390 RETURN
 1400 REM *** DROP COMMAND SUBROUTINE ***
 1405 GOSUB 1500 : REM IDENTIFY OBJECT
 1410 IF OL ( OBJ ) = 0 THEN OL ( OBJ ) = L : PRINT "You have dropped "; OD$ ( OBJ ) : RETURN
 1480 PRINT "You don't have that object." : REM Either we do not know this object or you do not have it
 1490 RETURN
 1500 REM *** IDENTIFY OBJECT SUBROUTINE ***
 1510 OBJ = 0
 1520 IF RIGHT$ ( IN$, 4 ) = "LAMP" THEN OBJ=1
 1530 IF RIGHT$ ( IN$, 3 ) = "KEY" THEN OBJ=2
 1550 RETURN
 1600 REM *** LIGHT LAMP COMMAND SUBROUTINE ***
 1610 IF OL ( 1 ) <> 0 THEN PRINT "You don't have a lamp." : RETURN
 1615 REM update map and object state
 1620 OD$ ( 1 ) = "a lit lamp" : LE ( 3, 2 ) = 4 : LE ( 3, 4 ) = 1 : LD$ ( 3 ) = "an empty room. You see doors leading west and south."
 1630 PRINT "Now you have a lit lamp."
 1650 RETURN
 1700 REM *** UNLOCK DOOR COMMAND SUBROUTINE ***
 1710 IF L <> 1 THEN PRINT "There is no door to unlock here." : RETURN
 1720 IF L = 1 AND LE ( 1, 3 ) = 3 THEN PRINT "The door is already unlocked." : RETURN
 1730 IF OL ( 2 ) <> 0 THEN PRINT "With what?" : RETURN
 1740 LD$ ( 1 ) = "an empty office. There are doors to the south and to the east." : LE ( 1, 3 ) = 3
 1750 PRINT "You have unlocked the door."
 1790 RETURN
 1800 REM *** HELP COMMAND SUBROUTINE ***
 1810 PRINT "Try some of the following commands: GO, TAKE, DROP, INVENTORY, LIGHT, UNLOCK"
 1890 RETURN

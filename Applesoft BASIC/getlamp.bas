
 10 REM INIT VARIABLES
 15 REM LOCATION DESCRIPTION (LD), LOCATION (L)
 20 DIM LD$ ( 4 ) : DIM LE ( 4, 4 ) 
 25 L=1 
 30 DATA "an empty office","the stock room","a dark room","the world outside" 
 40 FOR I=1 TO 4
 50 READ LD$ ( I ) 
 60 NEXT I
 46 REM LOCATION EXITS (LE)
 48 REM N(1),S(2),E(3),W(4)
 50 DATA 0,2,3,0
 52 DATA 1,0,4,0
 54 DATA 0,4,0,1
 56 DATA 3,0,0,2
 58 FOR I=1 TO 4
 60 FOR J=1 TO 4
 62 READ LE ( I, J )
 64 NEXT J
 66 NEXT I
 100 REM MAIN LOOP
 110 PRINT "You are in " ;LD$( L ) 
 120 INPUT "> " ;IN$
 125 REM PRINT IN$
 128 REM GO COMMAND
 130 BUF=L
 140 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 5 ) = "NORTH" THEN L=LE ( L, 1 )
 142 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 5 ) = "SOUTH" THEN L=LE ( L, 2 )
 144 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 4 ) = "EAST" THEN L=LE ( L, 3 )
 146 IF LEFT$ ( IN$, 2 ) = "GO" AND RIGHT$ ( IN$, 4 ) = "WEST" THEN L=LE ( L, 4 )
 148 IF L = 0 THEN L=BUF : PRINT "You cannot go in that direction."
 200 GOTO 100
 1000 END
 
# Turbo Prolog

## How to build dev environment

1. Download and install DOSBox from https://www.dosbox.com/download.php?main=1.
1. Download Borland Turbo Prolog as a ZIP file from https://s4ifbn.com/programs.html and extract it to a local folder (e.g. C:\prolog).
1. Extract to external C: folder as C:\PROLOG

1. Start DOSBOX and mount the local folder (e.g. C:\prolog) to a virtual drive (C:) on DOS:
`mount c c:\prolog`

1. You can now go to directory `C:\PROLOG` run `PROLOG` in order to start Turbo Prolog.

## Resources

- Book/tutorial [Adventure in Prolog](https://www.amzi.com/AdventureInProlog/)
- Presentation [Turbo Prolog 2.0 Basics](https://www.slideshare.net/soham28/turbo-prolog-20-basics)
- [Code Examples](https://github.com/UltraHopeful/Turbo-Prolog-2.0)
- Book [Turbo Prolog 2.0 Reference Guide](https://winworldpc.com/product/turbo-prolog/2x)

## Tutorial

### Step 1: Rooms

```
domains
	location=symbol
predicates
	room(location)
clauses
	room(empty_office).
	room(stock_room).
	room(dark_room).
	room(world_outside).
```

### Step 2: Add room description and print current location

```
domains
	location=symbol
predicates
	room(location)
	here(location)
	description(symbol, string)
	printlocation
clauses
	room(empty_office).
	room(stock_room).
	room(dark_room).
	room(world_outside).

	here(empty_office).
	
	description(empty_office, "an empty office. There is a door to the south and a locked door to the east.").
	description(stock_room, "in the stock room.").
	description(dark_room, "in a dark room.").
	description(world_outside, "in the world outside.").

	printlocation() :-
		here(Location),
		description(Location, Description),
		write("You are in ", Description), nl.
```

### Step 3: Connect rooms and move around

```
domains
	word,location,direction=symbol
predicates
	room(Location)
	description(symbol, string)
	exitfromto(location, symbol, location)
	look()
	goto(word)
	move(location)
database
	here(location)
clauses
	room(empty_office).
	room(stock_room).
	room(dark_room).
	room(world_outside).
	
	description(empty_office, "an empty office. There is a door to the south and a locked door to the east.").
	description(stock_room, "in the stock room.").
	description(dark_room, "in a dark room.").
	description(world_outside, "in the world outside.").
		
	exitfromto(empty_office, "south", stock_room).
	exitfromto(stock_room, "north", empty_office).
	
	here(empty_office).
	
	look() :-
		here(Location),
		description(Location, Description),
		write("You are in ", Description), nl.
	
	goto(Direction) :-
		here(From),
		exitfromto(From, Direction, To),
		move(To).
	goto(_) :- write("You can't go in this direction"), nl, fail.
		
	move(X) :- 
		retract(here(_)),
		assert(here(X)).
```

from https://www.amzi.com/AdventureInProlog/a5rules.php

We now have an understanding of the fundamentals of Prolog, and it is worth summarizing what we have learned so far. We have seen the following about rules in Prolog.

A Prolog program is a logicbase of interrelated facts and rules.
The rules communicate with each other through unification, Prolog's built-in pattern matcher.
The rules communicate with the user through built-in predicates such as write/1.
The rules can be queried (called) individually from the listener.
We have seen the following about Prolog's control flow.

The execution behavior of the rules is controlled by Prolog's built-in backtracking search mechanism.
We can force backtracking with the built-in predicate fail.
We can force success of a predicate by adding a final clause with dummy variables as arguments and no body.
We now understand the following aspects of Prolog programming.

Facts in the logicbase (locations, doors, etc.) replace conventional data definition.
The backtracking search (list_things/1) replaces the coding of many looping constructs.
Passing of control through pattern matching (connect/2) replaces conditional test and branch structures.
The rules can be tested individually, encouraging modular program development.
Rules that call rules encourage the programming practices of procedure abstraction and data abstraction. (For example, look/0 doesn't know how list_things/1 works, or how the location data is stored.)


From https://www.amzi.com/AdventureInProlog/a7manage.php

As we have seen, the variables in a clause are local to that clause. There are no global variables in Prolog, as there are in many other languages. The Prolog logicbase serves that purpose. It allows all clauses to share information on a wider basis, replacing the need for global variables. 'asserts' and 'retracts' are the tools used to manipulate this global data.

As with any programming language, global data can be a powerful concept, easily overused. They should be used with care, since they hide the communication of information between clauses. The same code will behave differently if the global data is changed. This can lead to hard-to-find bugs.

Eliminating global data and the 'assert' and 'retract' capabilities of Prolog is a goal of many logic programmers. It is possible to write Prolog programs without dynamically modifying the logicbase, thus eliminating the problem of global variables. This is done by carrying the information as arguments to the predicates. In the case of an adventure game, the complete state of the game could be represented as predicate arguments, with each command called with the current state and returning a new modified state. This approach will be discussed in more detail in chapter 14.

Although the database-like approach presented here may not be the purest method from a logical standpoint, it does allow for a very natural representation of this game application.

Various Prologs provide varying degrees of richness in the area of logicbase manipulation. The built-in versions are usually unaffected by backtracking. That is, like the other I/O predicates, they perform their function when called and do nothing when entered from the redo port.

### Step 4 Adding objects and object manipulation commands

```
domains
	word,location,direction=symbol
predicates
	room(location)
	description(symbol, string)
	exitfromto(location, symbol, location)
	look
	object(word)
	list_things(location)
	goto(word)
	move(location)
	take(word)
	drop(word)
	change_location(word, location)
	inventory
database
	here(location)
	location(word, location)
clauses
	room(empty_office).
	room(stock_room).
	room(dark_room).
	room(world_outside).
	room(inventory).

	exitfromto(empty_office, "south", stock_room).
	exitfromto(stock_room, "north", empty_office).
	
	here(empty_office).
	
	object(lamp).
	object(key).

	location(lamp, empty_office).
	location(key, stock_room).
	
	description(empty_office, "an empty office. There is a door to the south and a locked door to the east.").
	description(stock_room, "in the stock room.").
	description(dark_room, "in a dark room.").
	description(world_outside, "in the world outside.").

	description(lamp, "a lamp").
	description(key, "a key").

	look() :-
		here(Location),
		description(Location, Description),
		write("You are in ", Description), nl,
		write("You see:"), nl,
		list_things(Location), nl.
	
	list_things(Location) :-
		location(Thing, Location),
		description(Thing, Desc),
		writef("\t"),
		write(Desc),
		nl,
		fail.
	list_things(Location) :-
		not(location(_, Location)),
		writef("\t"),
		write("Nothing."),
		nl,
		fail.
	list_things(_).
	
	goto(Direction) :-
		here(From),
		exitfromto(From, Direction, To),
		move(To).
	goto(_) :- write("You can't go in this direction"), nl, fail.
		
	move(X) :- 
		retract(here(_)),
		assert(here(X)).
		
	take(Obj) :-
		location(Obj, Location),
		here(Location),
		change_location(Obj, inventory),
		description(Obj, Desc),
		write("You have taken ", Desc), nl.
	take(Obj) :-
		write("There's no ", Obj, " here."), nl.

	drop(Obj) :-
		location(Obj, inventory),
		here(Here),
		change_location(Obj, Here),
		description(Obj, Desc),
		write("You have dropped ", Desc, "."),nl.
	drop(Obj) :-
		write("You aren't carrying ", Obj, "."), nl.
				
	change_location(Obj, Location) :-
		retract(location(Obj, _)),
		assert(location(Obj, Location)).
		
	inventory() :-
		write("You are carrying:"), nl,
		list_things(inventory).
```

### Step 5 Parsing user input

Examples of valid commands:

go north (verb, noun)
take key (verb, noun)
drop key (verb, noun)
light lamp (verb, noun)
open door (verb, noun)
help (verb)

Command as list of words:
[go, north]
[take, key]
[help]

```
domains
	word,location,direction=symbol
	wordlist=word*
predicates
	room(location)
	object(word)
	description(symbol, string)
	exitfromto(location, symbol, location)
	look()
	list_things(location)
	goto(word)
	move(location)
	take(word)
	drop(word)
	change_location(word, location)
	string_wordlist(string, wordlist)
	direction(word)
	do(wordlist)
	end_condition(wordlist)
	user_input(string)
	repeat
	game_loop
database
	here(location)
	location(word, location)
clauses
	room(empty_office).
	room(stock_room).
	room(dark_room).
	room(world_outside).
	room(inventory).

	exitfromto(empty_office, "south", stock_room).
	exitfromto(stock_room, "north", empty_office).
	
	here(empty_office).
	
	object(lamp).
	object(key).

	location(lamp, empty_office).
	location(key, stock_room).
	
	description(empty_office, "an empty office. There is a door to the south and a locked door to the east.").
	description(stock_room, "in the stock room.").
	description(dark_room, "in a dark room.").
	description(world_outside, "in the world outside.").

	description(lamp, "a lamp").
	description(key, "a key").

	look() :-
		here(Location),
		description(Location, Description),
		write("You are in ", Description), nl,
		write("You see:"), nl,
		list_things(Location), nl.
	
	list_things(Location) :-
		location(Thing, Location),
		description(Thing, Desc),
		writef("\t"),
		write(Desc),
		nl,
		fail.
	list_things(Location) :-
		not(location(_, Location)),
		writef("\t"),
		write("Nothing."),
		nl,
		fail.
	list_things(_).
	
	goto(Direction) :-
		here(From),
		exitfromto(From, Direction, To),
		move(To).
	goto(_) :- write("You can't go in this direction"), nl, !.
		
	move(X) :- 
		retract(here(_)),
		assert(here(X)).
		
	take(Obj) :-
		location(Obj, Location),
		here(Location),
		change_location(Obj, inventory),
		description(Obj, Desc),
		write("You have taken ", Desc),
		nl.
	take(Obj) :-
		write("There's no ", Obj, " here."), nl.

	drop(Obj) :-
		location(Obj, inventory),
		here(Here),
		change_location(Obj, Here),
		description(Obj, Desc),
		write("You have dropped ", Desc, "."),nl.
	drop(Obj) :-
		write("You aren't carrying ", Obj, "."), nl.
				
	change_location(Obj, Location) :-
		retract(location(Obj, _)),
		assert(location(Obj, Location)).
	
	string_wordlist(S, [H|T]) :-
		fronttoken(S, H, S1),!,
		string_wordlist(S1,T).
	string_wordlist(_, []).
	
	direction(north).
	direction(south).
	direction(east).
	direction(west).
	
	do([go, Direction]) :-
		direction(Direction),
		goto(Direction), !.
		
	do([take, Obj]) :-
		object(Obj),
		take(Obj), !.
	
	do([drop, Obj]) :-
		object(Obj),
		drop(Obj), !.
	
	do([inventory]) :-
		write("You are carrying:"), nl,
		list_things(inventory), !.

	do([help]) :-
		write("Try some of the following commands: go, take, drop, inventory, light, unlock."), nl, !.
	
	do([quit]).
	
	do(_) :-
		write("What?"), nl, !.
		
	end_condition([quit]) :-
		write("Quitting game"), nl.
	
	end_condition(_) :-
		here(world_outside),
		write("Congratulations, you have won the game!").
	
	user_input(String) :-
		write("> "), readln(StringInput),
		upper_lower(StringInput, String).
	
	repeat.
	repeat :- repeat.
		
	game_loop :-
		write("* GET LAMP - A (SHORT) TEXT ADVENTURE *"),
		repeat,
		nl,
		look,
		user_input(String), nl,
		string_wordlist(String, Words),
		do(Words),
		end_condition(Words).
goal
	game_loop
```

### Step 7: the complete game

```
domains
	word,location,direction=symbol
	wordlist=word*
predicates
	room(location)
	add_exitfromto(location, direction, location)
	object(word)
	change_description(symbol, string)
	look()
	list_things(location)
	goto(word)
	move(location)
	take(word)
	drop(word)
	change_location(word, location)
	string_wordlist(string, wordlist)
	direction(word)
	do(wordlist)
	end_condition(wordlist)
	user_input(string)
	repeat
	game_loop
database
	here(location)
	location(word, location)
	description(symbol, string)
	exitfromto(location, symbol, location)
clauses
	room(empty_office).
	room(stock_room).
	room(dark_room).
	room(world_outside).
	room(inventory).

	exitfromto(empty_office, "south", stock_room).
	exitfromto(stock_room, "north", empty_office).
	
	add_exitfromto(From, Direction, NewTo) :- 
		assert(exitfromto(From, Direction, NewTo)).

	here(empty_office).
	
	object(lamp).
	object(key).

	location(lamp, empty_office).
	location(key, stock_room).
	
	description(empty_office, "an empty office. There is a door to the south and a locked door to the east.").
	description(stock_room, "in the stock room.").
	description(dark_room, "in a dark room.").
	description(world_outside, "in the world outside.").

	description(lamp, "a lamp").
	description(key, "a key").

	change_description(Target, NewDesc) :-
		retract(description(Target, _)),
		assert(description(Target, NewDesc)).

	look() :-
		here(Location),
		description(Location, Description),
		write("You are in ", Description), nl,
		write("You see:"), nl,
		list_things(Location), nl.
	
	list_things(Location) :-
		location(Thing, Location),
		description(Thing, Desc),
		writef("\t"),
		write(Desc),
		nl,
		fail.
	list_things(Location) :-
		not(location(_, Location)),
		writef("\t"),
		write("Nothing."),
		nl,
		fail.
	list_things(_).
	
	goto(Direction) :-
		here(From),
		exitfromto(From, Direction, To),
		move(To).
	goto(_) :- write("You can't go in this direction"), nl, !.
		
	move(X) :- 
		retract(here(_)),
		assert(here(X)).
		
	take(Obj) :-
		location(Obj, Location),
		here(Location),
		change_location(Obj, inventory),
		description(Obj, Desc),
		write("You have taken ", Desc),
		nl.
	take(Obj) :-
		write("There's no ", Obj, " here."), nl.

	drop(Obj) :-
		location(Obj, inventory),
		here(Here),
		change_location(Obj, Here),
		description(Obj, Desc),
		write("You have dropped ", Desc, "."),nl.
	drop(Obj) :-
		write("You aren't carrying ", Obj, "."), nl.
				
	change_location(Obj, Location) :-
		retract(location(Obj, _)),
		assert(location(Obj, Location)).
	
	string_wordlist(S, [H|T]) :-
		fronttoken(S, H, S1),!,
		string_wordlist(S1,T).
	string_wordlist(_, []).
	
	direction(north).
	direction(south).
	direction(east).
	direction(west).
	
	do([go, Direction]) :-
		direction(Direction),
		goto(Direction), !.
		
	do([take, Obj]) :-
		object(Obj),
		take(Obj), !.
	
	do([drop, Obj]) :-
		object(Obj),
		drop(Obj), !.
	
	do([inventory]) :-
		write("You are carrying:"), nl,
		list_things(inventory), !.

	do([unlock, door]) :-
		here(Here),
		Here = empty_office,
		location(key, inventory),
		change_description(empty_office, "an empty office. There are doors to the south and to the east"),
		add_exitfromto(empty_office, east, dark_room),
		write("You have unlocked the door."), nl, !.

	do([unlock, door]) :-
		not(location(key, inventory)),
		write("With what?"), nl, !.

	do([unlock, door]) :-
		write("There is no door to unlock here."), nl, !.
		
	do([light, lamp]) :-
		location(lamp, inventory),
		change_description(lamp, "a lit lamp"),
		change_description(dark_room, "an empty room. You see doors leading west and south"),
		add_exitfromto(dark_room, south, world_outside),
		write("Now you have a lit lamp."),nl,!.

	do([light, lamp]) :-
		not(location(lamp, inventory)),
		write("You don't have a lamp."), nl, !.	
		
	do([help]) :-
		write("Try some of the following commands: go, take, drop, inventory, light, unlock."), nl, !.
	
	do([quit]).
	
	do(_) :-
		write("What?"), nl, !.
		
	end_condition([quit]) :-
		write("Quitting game"), nl.
	
	end_condition(_) :-
		here(world_outside),
		write("Congratulations, you have won the game!").
	
	user_input(String) :-
		write("> "), readln(StringInput),
		upper_lower(StringInput, String).
	
	repeat.
	repeat :- repeat.
		
	game_loop :-
		write("* GET LAMP - A (SHORT) TEXT ADVENTURE *"),
		repeat,
		nl,
		look,
		user_input(String), nl,
		string_wordlist(String, Words),
		do(Words),
		end_condition(Words).
goal
	game_loop
```
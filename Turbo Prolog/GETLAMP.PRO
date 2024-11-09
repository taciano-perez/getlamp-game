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
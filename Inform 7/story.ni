"GetLamp" by Taciano Perez

An Empty Office is a room. "You are in an empty office. There is a door to the south and a black door to the east."

The Stock Room is a room. It is south of An Empty Office. "You are in the stock room. There is a door to the north."

A Waiting Room is a dark room. It is west of An Empty Office. "You are in a waiting room. You see doors leading west and south."

The World Outside is a room. It is south of A Waiting Room. "You are in the world outside!"

The Black Door is a door. It is lockable and locked. It is scenery. It is east of An Empty Office. It is west of A Waiting Room.

A Key is a thing in The Stock Room. It unlocks the Black Door. "a key"

A device called A Lamp is in An Empty Office. "a lamp"

Understand the command “light” as something new.
Understand “light [something]” as switching on.

A Lamp can be either lit or unlit.
A Lamp is unlit.

Carry out switching on lamp:
now A Waiting Room is lit.

Instead of going south in A Waiting Room when A Lamp is switched off: say "You cannot see a thing. You cannot go in that direction."

After going to The World Outside:
  end the story finally saying "You are in the world outside![line break]Congratulations, you have won the game!";

Understand "help" as summoning help. Summoning help is an action applying to nothing.
Carry out summoning help:
    say "Try some of the following commands: GO, TAKE, DROP, INVENTORY, LIGHT, UNLOCK".

Test win with "take lamp / s / take key / n / unlock door with key / e / light lamp / s".

Test light with "take lamp / s / take key / n / unlock door with key / e / s"

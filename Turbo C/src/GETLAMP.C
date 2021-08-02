#include <stdio.h>
#include <string.h>

#include "game_structs.h"

#define MAX_INPUT 256
#define OBJS_LEN sizeof(objs)/sizeof(objs[0])

#define LOC_OFFICE 0
#define LOC_STOCKROOM 1
#define LOC_DARKROOM 2
#define LOC_OUTSIDE 3

/* global variables */
struct location locs[] = {
	{"an empty office. There is a door to the south and a locked door to the east", NOWHERE, LOC_STOCKROOM, NOWHERE, NOWHERE},
	{"the stock room. There is a door to the north", LOC_OFFICE, NOWHERE, NOWHERE, NOWHERE},
	{"a dark room. You cannot see a thing", NOWHERE, NOWHERE, NOWHERE, LOC_OFFICE},
	{"the world outside", LOC_DARKROOM, NOWHERE, NOWHERE, NOWHERE}
};

struct object objs[] = {
	{"a lamp", "lamp", &locs[0]},
	{"a key", "key", &locs[1]}
};

int cur_loc = 0;

/* functions */
process_input(const char *input)
{
	const char *verb, *noun;
	verb = strtok(input, " \n");
	noun = strtok(NULL, " \n");
	if (verb != NULL)
	{
		if(strcmp(verb, "go") == 0)
		{
			cmd_go(noun);
		}
		else if(strcmp(verb, "inventory") == 0)
		{
			cmd_inventory();
		}
		else if(strcmp(verb, "take") == 0)
		{
			cmd_take(noun);
		}
		else if(strcmp(verb, "drop") == 0)
		{
			cmd_drop(noun, &locs[cur_loc]);
		}
		else if (strcmp(verb, "light") == 0 && strcmp(noun, "lamp") == 0)
		{
			cmd_light_lamp();
		}
		else if (strcmp(verb, "unlock") == 0 && strcmp(noun, "door") == 0)
		{
			cmd_unlock_door();
		}
		else if(strcmp(verb, "help") == 0)
		{
			cmd_help();
		}
		else if(strcmp(verb, "quit") == 0)
		{
			cmd_quit();
		}
		else
		{
			printf("I don't know how to %s\n", input);
		}
	}
	return;
}

cmd_go(const char *noun)
{
	int dest = NOWHERE;
	if (noun == NULL)
	{
		printf("where to?\n");
		return;
	}
	else if (strcmp(noun, "north") == 0)
	{
		dest = locs[cur_loc].north;
	}
	else if (strcmp(noun, "south") ==  0)
	{
		dest = locs[cur_loc].south;
	}
	else if (strcmp(noun, "east") == 0)
	{
		dest = locs[cur_loc].east;
	}
	else if (strcmp(noun, "west") == 0)
	{
		dest = locs[cur_loc].west;
	}
	else
	{
		printf("I don't know this location: %s\n", noun);
		return;
	}
	if (dest == NOWHERE)
	{
		printf("You cannot go %s.\n", noun);
	} else
	{
		cur_loc = dest;
	}
	return;
}

struct object *find_object_by_tag(const char *obj_tag)
{
	int i;
	struct object *obj = objs;
	for (i=0; i<OBJS_LEN; i++, obj++)
	{
		if (strcmp(obj->tag, obj_tag) == 0)
		{
			return obj;
		}
	}
	return NULL;
}

cmd_take(const char *noun)
{
	struct object *obj = find_object_by_tag(noun);
	if (obj != NULL && obj->location == &locs[cur_loc])
	{
		obj->location = INVENTORY;
		printf("You have taken %s.\n", obj->desc);
	} else {
		printf("You don't see that object in here.\n");
	}
	return;
}

cmd_inventory()
{
	int i;
	struct object *obj = objs;
	printf("You are carrying:\n");
	for (i=0; i<OBJS_LEN; i++, obj++)
	{
		if (obj->location == INVENTORY)
		{
			printf(" %s\n", obj->desc);
		}
	}
	return;
}

cmd_drop(const char *obj_name, const struct location *loc)
{
	struct object *obj = find_object_by_tag(obj_name);
	if (obj != NULL && obj->location == INVENTORY)
	{
		obj->location = loc;
		printf("You have dropped %s.\n", obj->desc);
	} else {
		printf("You don't have that object.\n", obj_name);
	}
	return;
}

list_objs(const struct location *loc)
{
	int i;
	struct object* obj = objs;
	for (i = 0; i<OBJS_LEN; i++, obj++)
	{
		if (obj->location == loc)
		{
			printf("You see %s.\n", obj->desc);
		}
	}
	return;
}

cmd_light_lamp()
{
	struct object *lamp = find_object_by_tag("lamp");
	if (lamp != NULL && lamp->location == INVENTORY)
	{
		lamp->desc = "a lit lamp";
		locs[LOC_DARKROOM].desc = "an empty room. You see doors leading west and south";
		locs[LOC_DARKROOM].south = LOC_OUTSIDE;
		printf("Now you have a lit lamp.\n");
	}
	else
	{
		printf("You don't have a lamp.\n");
	}
	return;
}

cmd_unlock_door()
{
	struct object *key = find_object_by_tag("key");

	if (&locs[cur_loc] != &locs[LOC_OFFICE])
	{
		printf("There is no door to unlock here.\n");
	}
	else if (locs[LOC_OFFICE].east == LOC_DARKROOM)
	{
		printf("The door is already unlocked.\n");
	}
	else if (key == NULL || key->location != INVENTORY)
	{
		printf("With what?\n");
	}
	else
	{
		locs[LOC_OFFICE].desc = "an empty office. There are doors to the south and to the east";
		locs[LOC_OFFICE].east = LOC_DARKROOM;
		printf("You have unlocked the door.\n");
	}
	return;
}

cmd_help()
{
	printf("Try some of the following commands: go, take, drop, inventory, light, unlock.\n");
	return;
}

cmd_quit()
{
			printf("Quitting game\n");
			exit(0);
}

game_loop()
{
	// variables
	char input[MAX_INPUT];

	// main loop
	printf("\nYou are in %s.\n", locs[cur_loc].desc);
	if (cur_loc == LOC_OUTSIDE)
	{
		printf("Congratulations, you have won the game!");
		exit(0);
	}
	list_objs(&locs[cur_loc]);
	printf("> ");
	fgets(input, sizeof(input), stdin);
	process_input(input);
	return;
 }

main() {
	while (1)
	{
		game_loop();
	}
}
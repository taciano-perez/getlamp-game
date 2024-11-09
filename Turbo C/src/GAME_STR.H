#define NOWHERE -1
#define INVENTORY NULL

struct location {
	const char *desc;
	const int north;
	const int south;
	const int east;
	const int west;
};

struct object {
	const char *desc;
	const char *tag;
	struct location *location;
};

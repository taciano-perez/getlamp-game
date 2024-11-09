# Get Lamp - Apple IIe 6502C Assembly version

The main game loop lies in `main.s`. Common constants used by all modules are defined in `common.s`.

Generic string manipulation routines can be found in `printstring.s`, `inputstring.s` and `cmpstring.s`.

Data and routines for locations and objects are under `location.s` and `objects.s`.

Most of the game consists in parsing commands, accomplished via `cmdgo.s`, `cmdtake.s`, `cmddrop.s`, `cmdinventory.s`, `cmdunlock.s`, `cmdlight.s`, and `cmdhelp.s`.

The next section lists constants used throughout this implementation.

## Locations

| #  | Name             |
| -- | ---------------- |
| 00 | Empty office     |
| 01 | Stock room       |
| 02 | Dark room        |
| 03 | Outside          |
| AA | Player (objects) |
| FF | NOWHERE          |

## Directions
| #  | Name  |
| -- | ------|
| 01 | NORTH |
| 02 | SOUTH |
| 03 | EAST  |
| 04 | WEST  |
| FF | No exit on this direction  |

## Location vs. Direction table

| Origin | NORTH | SOUTH | EAST | WEST |
| ------ | ----- | ----- | ---- | ---- |
| 00     | FF    | 01    | FF   | FF   |
| 01     | 00    | FF    | FF   | FF   |
| 02     | FF    | FF    | FF   | 00   |
| 03     | 02    | FF    | FF   | FF   |


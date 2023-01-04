# Get Lamp - Apple II 6502 Assembly version

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


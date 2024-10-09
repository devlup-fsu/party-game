# mazes.json Specification

Each level contains two sections:
	- `static` - Nonmoving walls
	- `dynamic` - Moving walls

The coordinates for the walls are normalized to a 11x11 grid, meaning that (0, 0) is the 
top left, (10, 10) is the bottom right, and (5, 5) is the center. If you need greater
precision, you can of course use decimals.

## Static
A static wall is just an array representing a line segment in the form `[x1, y1, x2, y2]`, like this:
	`[1, 1, 4, 5]`  -> A line segment from (1, 1) to (4, 5).

That's literally all there is to these ones, I might add an option for wall thickness
if it's necessary.


## Dynamic
There are two types of dynamic walls:
	- Oscillatory - Moves back and forth based on a sin wave
	- Rotational - Rotates around a given point or on its own axis

### Oscillatory
Oscillatory walls must be formatted like this:
	`[0, line segment, movement vector, speed, amplitude]`

Here's an example:
	`[0, [1, 1, 4, 5], [1, 0, 0], 1, 5]`

The movement vector controls the direction the wall will move in.
	- `[1, 0, 0]` -> Left to right (x)
	- `[0, 0, 1]` -> Forward and backward (z)
	- `[0, 1, 0]` -> Up and down (probably don't use this one)

The speed is self explanatory, and amplitude controls how far the wall will move.

### Rotational
Rotational walls must be formatted like this:
	`[1, line segment, center coordinate, speed]`

Here's an example:
	`[1, [4, 1, 6, 1], [5, 5], 1]`

You can also make a wall rotate on its axis if the point lies on the wall's center:
	`[1, [4, 5, 6, 5], [5, 5], 1]`

Making the speed negative will make the wall spin in the opposite direction.

# TODO

Finalizations to Factory Minigame, should be completed by 1-31-25

## Gameplay Changes
[x] Swtich to a "home base" collection system
	- Each player will now have their own base to bring fuel back to
	- Now only 1 type of fuel
	- This is much more intuitive and makes more sense overall
[x] Punching
	[~] Don't let players punch through walls
		- Implemented, but needs to be tested
	[x] Lock player direction while punching
[ ] Reduce throw strength
[ ] Joystick snapback fix?
[ ] Remove drop-punch exploit?
	- This is when you drop your held fuel, punch immediately, then pick the fuel back up
	- This could be a cool tech to keep in if it's made more difficult to perform
[x] Increase throw charge time
[x] Make throw charge oscillate while button is held
	- This would make it so players actually have to time their throw to get the maximum strength
[ ] Reposition receptacle hitbox

## Graphical Changes
[ ] Replace brick wall material with something else
[ ] Increase floor texture resolution
[ ] Add material to maze walls (could just copy outer walls)

## Audio
[ ] Sound effects
	[ ] Pickup
	[x] Punch
	[x] Hit by punch
	[ ] Deposit fuel
	[x] Throw fuel
	[ ] Launch fuel
	[x] Fuel hit wall
[ ] Music

## Other
[x] Refactoring
	- Rename directories, files, etc to match convention
[ ] ACTUAL GAME NAME
[ ] Intro cutscene
	- Probably just a 3, 2, 1 countdown
[ ] Ending cutscene

## Bugfixes
[ ] Players getting stuck when sliding against outer walls
	- No idea what's causing this, happens at the same point on each wall
	- Maybe if we switch out the CSGBoxes, it'll just fix itself?

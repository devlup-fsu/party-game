extends Node

## Represents the place a player earns in a minigame.
## Godot enums are just integers if that makes calculation easier.
enum Place {
	FIRST,  # = 0
	SECOND, # = 1
	THIRD,  # = 2
	FOURTH  # = 3
}


func place_to_string(place: Place) -> String:
	match place:
		Place.FIRST: return "1st"
		Place.SECOND: return "2nd"
		Place.THIRD: return "3rd"
		Place.FOURTH: return "4th"
	
	return ""

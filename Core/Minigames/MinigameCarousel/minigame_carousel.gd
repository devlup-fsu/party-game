class_name MinigameCarousel
extends Control

@export var portrait_vel: float = 1000.0
@export var spacing: float = 16

var _portrait_scene: PackedScene = load("res://Core/Minigames/MinigameCarousel/minigame_portrait.tscn")

var _portraits: Array[MinigamePortrait] = []


func initialize(target_minigame: Minigame) -> void:
	if not is_node_ready():
		await ready
	
	var minigames = SceneManager.get_published_minigames()
	minigames += minigames + minigames
	minigames.erase(target_minigame)
	minigames.shuffle()
	minigames = minigames.slice(0, 3)  # Get three random minigames.
	minigames.append(target_minigame)
	minigames.shuffle()
	
	for minigame in minigames:
		var portrait: MinigamePortrait = _portrait_scene.instantiate()
		_portraits.push_back(portrait)
		%Portraits.add_child(portrait)
		
		portrait.set_minigame(minigame)
	
	%Selector.size = _portraits[0].size


#func _process(delta: float) -> void:
	#for portrait in _portraits:
		#portrait.position.x -= portrait_vel * delta
		#
		#if portrait.position.x < -portrait.size.x:
			#portrait.position.x = (_portraits.size() - 1) * (portrait.size.x + spacing)# + get_viewport().size.x

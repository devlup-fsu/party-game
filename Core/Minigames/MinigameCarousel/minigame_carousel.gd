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
	minigames.shuffle()
	minigames = minigames + minigames + minigames + minigames
	
	var initial_y = get_viewport().size.y / 2
	
	for i in range(minigames.size()):
		var minigame = minigames[i]
		
		var portrait: MinigamePortrait = _portrait_scene.instantiate()
		_portraits.push_back(portrait)
		add_child(portrait)
		
		portrait.set_minigame(minigame)
		portrait.position.y = initial_y - (portrait.size.y / 2)
		portrait.position.x = i * (portrait.size.x + spacing) + get_viewport().size.x


#func _process(delta: float) -> void:
	#for portrait in _portraits:
		#portrait.position.x -= portrait_vel * delta
		#
		#if portrait.position.x < -portrait.size.x:
			#portrait.position.x = minigames.size() * (portrait.size.x + spacing) + get_viewport().size.x

extends Control

var _target_minigame: Minigame

func initialize(target_minigame: Minigame) -> void:
	_target_minigame = target_minigame
	if not is_node_ready():
		await ready
	
	%Title.text = _target_minigame.name
	%Description.text = _target_minigame.description
	
	var game_scene = _target_minigame.scene.instantiate()
	%SubViewport.add_child(game_scene)
	
	for control in _target_minigame.controls:
		var texture_rect = TextureRect.new()
		texture_rect.texture = control
		%ControlsContainer.add_child(texture_rect)

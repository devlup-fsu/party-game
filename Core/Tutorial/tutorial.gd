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


func _physics_process(delta: float) -> void:
	for player in range(Controls.Player.ONE, Controls.Player.size()):
		if Controls.is_action_just_pressed(player, "core_submit"):
			SceneManager.load_minigame_for_real_this_time(_target_minigame)

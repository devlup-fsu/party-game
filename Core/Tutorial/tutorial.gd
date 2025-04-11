class_name TutorialScreen
extends Control

var _target_minigame: Minigame
var _game_scene: Node

func initialize(target_minigame: Minigame) -> void:
	_target_minigame = target_minigame
	if not is_node_ready():
		await ready
	
	%Title.text = _target_minigame.name
	%Description.text = _target_minigame.description
	
	restart_practice_minigame()
	
	for control in _target_minigame.controls:
		var texture_rect = TextureRect.new()
		texture_rect.texture = control
		%ControlsContainer.add_child(texture_rect)


func _physics_process(delta: float) -> void:
	for player in range(Controls.Player.ONE, Controls.Player.size()):
		if Controls.is_action_just_pressed(player, "core_submit"):
			SceneManager.load_minigame_for_real_this_time(_target_minigame)


func restart_practice_minigame() -> void:
	if _game_scene != null:
		_game_scene.queue_free()
	
	_game_scene = _target_minigame.scene.instantiate()
	%SubViewport.add_child(_game_scene)

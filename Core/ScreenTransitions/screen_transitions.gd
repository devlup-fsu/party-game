extends Node


@onready var fade_scene = preload("res://Core/ScreenTransitions/fade_scene.tscn")
@onready var countdown_scene = preload("res://Core/ScreenTransitions/countdown.tscn")


## Create a new fade scene.
## If `fade_out` is true, the current scene will fade out. Otherwise, the scene will fade in.
func _create_fade_scene(fade_out: bool, on_finish: Callable) -> FadeScene:
	var scene: FadeScene = fade_scene.instantiate()
	scene.on_finish = on_finish
	scene.fade_type = fade_out
	return scene

## Create a new countdown scene.
func _create_countdown_scene(on_finish: Callable) -> CountdownScene:
	var scene: CountdownScene = countdown_scene.instantiate()
	scene.on_finish = on_finish
	return scene


## Fades to `next_scene`.
## If `pop_current` is true, then the current scene will be popped when the fade is completed.
func fade(next_scene: Node, pop_current: bool=false):
	var fade_in_finish = func():
		SceneManager._pop_scene().queue_free()  # pop the fade in scene
	
	var fade_out_finish = func():
		var fade_in_scene = _create_fade_scene(false, fade_in_finish)
		SceneManager._pop_scene().queue_free()          # pop the fade out scene
		if pop_current:
			SceneManager._pop_scene().queue_free()      # pop the current scene if necessary
		SceneManager._push_scene(next_scene)            # push the next scene and hide the current scene
		SceneManager._push_scene(fade_in_scene, false)  # push the fade in scene, keeping the next scene visible
	
	var fade_out_scene = _create_fade_scene(true, fade_out_finish)
	SceneManager._push_scene(fade_out_scene, false)


## Fades back to the board.
func fade_to_board():
	var fade_in_finish = func():
		SceneManager._pop_scene().queue_free()
	
	var fade_out_finish = func():
		var fade_in_scene = _create_fade_scene(false, fade_in_finish)
		SceneManager._pop_to_board()
		SceneManager._push_scene(fade_in_scene, false)
	
	var fade_out_scene = _create_fade_scene(true, fade_out_finish)
	SceneManager._push_scene(fade_out_scene, false)


## Fades to the next scene and includes a countdown after the fade is done.
func fade_with_countdown(next_scene: Node):
	var countdown_finish = func():
		SceneManager._pop_scene().queue_free()
	
	var fade_in_finish = func():
		var countdown_scene = _create_countdown_scene(countdown_finish)
		SceneManager._pop_scene().queue_free()  # pop the fade in scene
		SceneManager._push_scene(countdown_scene, false)
	
	var fade_out_finish = func():
		var fade_in_scene = _create_fade_scene(false, fade_in_finish)
		SceneManager._pop_to_board()
		SceneManager._push_scene(next_scene)
		SceneManager._push_scene(fade_in_scene, false)
		next_scene.process_mode = Node.PROCESS_MODE_INHERIT
		await get_tree().create_timer(0.1).timeout
		next_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
	var fade_out_scene = _create_fade_scene(true, fade_out_finish)
	SceneManager._push_scene(fade_out_scene, false)

extends Node


@onready var fade_scene = preload("res://Core/ScreenTransitions/fade_scene.tscn")


## Create a new fade scene.
## If `fade_out` is true, the current scene will fade out. Otherwise, the scene will fade in.
func create_fade_scene(fade_out: bool, onexit: Callable) -> FadeScene:
	var scene = fade_scene.instantiate()
	scene.onexit = onexit
	scene.fade_type = fade_out
	return scene


## Fades to `next_scene`.
func fade(next_scene: Node):
	var fade_in_exit = func():
		SceneManager._pop_scene().queue_free()
	
	var fade_out_exit = func():
		var fade_in_scene = create_fade_scene(false, fade_in_exit)
		SceneManager._pop_scene().queue_free()  # pop the fade out scene
		SceneManager._push_scene(next_scene)
		SceneManager._push_scene(fade_in_scene, false)
	
	var fade_out_scene = create_fade_scene(true, fade_out_exit)
	SceneManager._push_scene(fade_out_scene, false)

extends Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("core_debug_screenshot"):
		DirAccess.make_dir_absolute("res://.godot/screenshots")
		
		var img = get_viewport().get_texture().get_image()
		img.save_png("res://.godot/screenshots/%s.png" % int(Time.get_unix_time_from_system()))

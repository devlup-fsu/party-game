extends Node


func build_animated_texture(directory: String):
	var dir = DirAccess.open(directory)
	
	var frame_files = []
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.get_extension() == "png":
			var file_name_without_ext = file_name.substr(0, file_name.length() - 4)
			
			if file_name_without_ext.get_extension().is_valid_int():
				frame_files.push_back(file_name_without_ext)
		file_name = dir.get_next()
	
	frame_files.sort_custom(func(a, b): return int(a.get_extension()) < int(b.get_extension()))

	dir.list_dir_end()
	
	var animated_texture = AnimatedTexture.new()
	animated_texture.frames = frame_files.size()
	for i in range(frame_files.size()):
		var image = Image.load_from_file(directory + "/" + frame_files[i] + ".png")
		animated_texture.set_frame_texture(i, ImageTexture.create_from_image(image))
		animated_texture.set_frame_duration(i, 1.0 / 30.0)
	
	return animated_texture

@tool
extends Node3D

@export_dir var emission_dir: String = ""
@export_dir var properties_dir: String = ""

@onready var ufo_mesh: MeshInstance3D = $FinalUFO/UFO


func _ready() -> void:
	ufo_mesh.mesh.surface_get_material(0).metallic_texture_channel = BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_RED
	ufo_mesh.mesh.surface_get_material(0).roughness_texture_channel = BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_GREEN
	
	var emission_tex = AnimatedTextureBuilder.build_animated_texture(emission_dir)
	ufo_mesh.mesh.surface_get_material(1).emission_texture = emission_tex

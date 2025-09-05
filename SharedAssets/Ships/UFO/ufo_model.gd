@tool
extends Node3D

@export_dir var emission_dir: String = ""
@export_dir var properties_dir: String = ""

@onready var ufo_mesh: MeshInstance3D = $FinalUFO/UFO

var use_alt_material = false


func _ready() -> void:
	ufo_mesh.mesh.resource_local_to_scene = true
	ufo_mesh.mesh.surface_get_material(0).resource_local_to_scene = true
	
	if use_alt_material:
		ufo_mesh.mesh.surface_get_material(0).albedo_texture = load("res://SharedAssets/Ships/UFO/UFO Assests/UFO-body-Alt_Bake2_PBR_Diffuse.png")
	
	ufo_mesh.mesh.surface_get_material(0).metallic_texture_channel = BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_RED
	ufo_mesh.mesh.surface_get_material(0).roughness_texture_channel = BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_GREEN
	
	var emission_tex = AnimatedTextureBuilder.build_animated_texture(emission_dir)
	ufo_mesh.mesh.surface_get_material(1).emission_texture = emission_tex

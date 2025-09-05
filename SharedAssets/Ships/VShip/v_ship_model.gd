@tool
extends Node3D

@export_dir var emission_dir: String = ""

@onready var v_ship_mesh: MeshInstance3D = $VshipGameReady/Vship

var use_alt_material = false


func _ready() -> void:
	v_ship_mesh.mesh.resource_local_to_scene = true
	v_ship_mesh.mesh.surface_get_material(0).resource_local_to_scene = true
	
	if use_alt_material:
		v_ship_mesh.mesh.surface_get_material(0).albedo_texture = load("res://SharedAssets/Ships/VShip/Assets/VShipAlt_Bake2_PBR_Diffuse.png")
	
	
	v_ship_mesh.mesh.surface_get_material(0).metallic_texture_channel = BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_RED
	v_ship_mesh.mesh.surface_get_material(0).roughness_texture_channel = BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_GREEN
	
	var emission_tex = AnimatedTextureBuilder.build_animated_texture(emission_dir)
	v_ship_mesh.mesh.surface_get_material(1).emission_texture = emission_tex

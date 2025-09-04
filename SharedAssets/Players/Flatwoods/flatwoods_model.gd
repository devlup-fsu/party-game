@tool
extends Node3D

@onready var flatwoods_mesh: MeshInstance3D = $FlatwoodsGameReady/FlatArma/Skeleton3D/FlatWoods
@onready var animation_tree: AnimationTree = $AnimationTree

var use_alt_material = false

func _ready() -> void:
	flatwoods_mesh.mesh.resource_local_to_scene = true
	
	if not use_alt_material:
		flatwoods_mesh.mesh.surface_set_material(0, load("res://SharedAssets/Players/Flatwoods/flatwoods_shader_mat.tres"))
	else:
		flatwoods_mesh.mesh.surface_set_material(0, load("res://SharedAssets/Players/Flatwoods/alternative_flatwoods_shader_mat.tres"))

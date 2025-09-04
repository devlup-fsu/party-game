@tool
extends Node3D

@onready var grey_mesh: MeshInstance3D = $GreyGameReady/Grey/Skeleton3D/Grey_001
@onready var animation_tree: AnimationTree = $AnimationTree

var use_alt_material = false

func _ready() -> void:
	grey_mesh.mesh.resource_local_to_scene = true
	
	if not use_alt_material:
		grey_mesh.mesh.surface_set_material(0, load("res://SharedAssets/Players/Grey/grey_shader_material.tres"))
	else:
		grey_mesh.mesh.surface_set_material(0, load("res://SharedAssets/Players/Grey/alternative_grey_shader_material.tres"))

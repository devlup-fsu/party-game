@tool
extends Node3D

@onready var flatwoods_mesh: MeshInstance3D = $FlatwoodsGameReady/FlatArma/Skeleton3D/FlatWoods
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	flatwoods_mesh.mesh.surface_set_material(0, load("res://SharedAssets/Players/Flatwoods/flatwoods_shader_mat.tres"))

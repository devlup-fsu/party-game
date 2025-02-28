@tool
extends Node3D

@onready var grey_mesh: MeshInstance3D = $GreyGameReady/Grey/Skeleton3D/Grey_001


func _ready() -> void:
	grey_mesh.mesh.surface_set_material(0, load("res://SharedAssets/Players/Grey/grey_shader_material.tres"))

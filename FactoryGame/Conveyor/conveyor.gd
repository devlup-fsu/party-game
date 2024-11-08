@tool
extends Node3D

@export var length: int = 1:
	set(value):
		length = value
		update_node_lengths()


func update_node_lengths():
	if is_node_ready():
		$ConveyorMesh.mesh.size.x = length
		$StaticBody3D/Shape.shape.size.x = length
		$ForceArea/Shape.shape.size.x = length
		$ConveyorMesh.get_surface_override_material(0).uv1_scale.x = length*2


func _ready() -> void:
	update_node_lengths()


func _process(delta: float) -> void:
	var conveyor_material = $ConveyorMesh.get_surface_override_material(0)
	conveyor_material.uv1_offset.x = wrap(conveyor_material.uv1_offset.x+0.01, 0, 1)

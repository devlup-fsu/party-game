@tool
extends Node3D


@onready var conveyor_material = $ConveyorMesh.get_surface_override_material(0)


@export var length: int = 1:
	set(value):
		length = value
		update_node_lengths()


@export var preview_scroll: bool = false:
	set(value):
		preview_scroll = value
		conveyor_material.uv1_offset.x = 0


func update_node_lengths():
	if is_node_ready():
		$ConveyorMesh.mesh.size.x = length
		$StaticBody3D/Shape.shape.size.x = length
		$ForceArea/Shape.shape.size.x = length
		conveyor_material.uv1_scale.x = length*2


func _ready() -> void:
	update_node_lengths()


func _process(delta: float) -> void:
	if preview_scroll:
		conveyor_material.uv1_offset.x = wrap(conveyor_material.uv1_offset.x+0.01, 0, 1)

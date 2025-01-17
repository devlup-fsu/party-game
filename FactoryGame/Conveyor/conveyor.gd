@tool
extends Node3D

const SCROLL_SPEED = 0.005

@onready var conveyor_material = $Mesh.get_surface_override_material(0)
@onready var cylinder_material = $LeftCylinder.get_surface_override_material(0)

@export var length: float = 1:
	set(value):
		length = value
		update_node_lengths()

@export var preview_scroll: bool = false:
	set(value):
		preview_scroll = value
		conveyor_material.uv1_offset.x = 0
	
@export var disable_force: bool = false:
	set(value):
		disable_force = value


func update_node_lengths():
	if is_node_ready():
		$Mesh.mesh.size.x = length
		$StaticBody3D/Shape.shape.size.x = length
		$ForceArea/Shape.shape.size.x = length
		$LeftCylinder.position.x = -length / 2.0
		$RightCylinder.position.x = length / 2.0
		conveyor_material.uv1_scale.x = length * 0.75


func _ready() -> void:
	update_node_lengths()
	if not Engine.is_editor_hint():
		$ArrowSprite.visible = false
		$ForceArea/Shape.disabled = disable_force


func _process(_delta: float) -> void:
	if preview_scroll or not Engine.is_editor_hint():
		conveyor_material.uv1_offset.x = wrap(conveyor_material.uv1_offset.x+SCROLL_SPEED, 0, 1)
		cylinder_material.uv1_offset.x = wrap(cylinder_material.uv1_offset.x+SCROLL_SPEED, 0, 1)

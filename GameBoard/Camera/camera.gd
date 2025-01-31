class_name BoardCamera
extends Camera3D

@export var target: Node3D
@export var target_offset := Vector3(0, 4, 5)
@export var lerp_speed := 4


func _ready() -> void:
	global_position = target.global_position + target_offset


func _process(delta: float) -> void:
	global_position = global_position.lerp(target.global_position + target_offset, delta * lerp_speed)


func teleport_to_player(player: Node3D) -> void:
	global_position = player.global_position + target_offset

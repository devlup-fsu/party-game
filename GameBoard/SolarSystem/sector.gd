@tool
class_name Sector
extends Marker3D

@export var index: int = 0
@export var next: Array[Sector] = []
@export var player: BoardPlayer = null


func _ready() -> void:	
	_debug_display_index()


func get_player_position() -> Vector3:
	return global_position if player == null else global_position + Vector3(0, 1.5, 0)


func is_occupied() -> bool:
	return player != null


func _debug_display_index() -> void:
	if not Engine.is_editor_hint():
		return
	
	var label := Label3D.new()
	add_child(label)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.position.y += 0.5
	label.text = str(index)

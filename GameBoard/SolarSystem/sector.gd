@tool
class_name Sector
extends Marker3D

@export var index: int = 0
@export var next: Array[Sector] = []


func _ready() -> void:	
	_debug_display_index()


func _debug_display_index() -> void:
	if not Engine.is_editor_hint():
		return
	
	var label := Label3D.new()
	add_child(label)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.position.y += 0.5
	label.text = str(index)

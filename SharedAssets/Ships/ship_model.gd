@tool
class_name ShipModel
extends Node3D

var model_scenes = [
	load("res://SharedAssets/Ships/UFO/UfoModelAlt.tscn"),
	load("res://SharedAssets/Ships/VShip/VShipModelAlt.tscn"),
	load("res://SharedAssets/Ships/UFO/UfoModel.tscn"),
	load("res://SharedAssets/Ships/VShip/VShipModel.tscn"),
]

@export var player: Controls.Player:
	set(value):
		player = value
		_update_model()

var model

func _ready() -> void:
	_update_model()

func _update_model():
	if model is Node3D:
		model.queue_free()
	
	model = model_scenes[player].instantiate()
	
	if player == Controls.Player.ONE or player == Controls.Player.TWO:
		model.use_alt_material = true
	
	add_child(model)
	
	if not model.is_node_ready():
		await model.ready

@tool
class_name PlayerModel
extends Node3D

var model_scenes = [
	load("res://SharedAssets/Players/Grey/GreyModel.tscn"),
	load("res://SharedAssets/Players/Flatwoods/FlatwoodsModel.tscn"),
	load("res://SharedAssets/Players/Grey/GreyModel.tscn"),
	load("res://SharedAssets/Players/Flatwoods/FlatwoodsModel.tscn"),
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
	add_child(model)
	play_idle()

func play_idle() -> void:
	model.animation_tree["parameters/Transition/transition_request"] = "idle"

func play_running() -> void:
	model.animation_tree["parameters/Transition/transition_request"] = "running"

func punch() -> void:
	model.animation_tree["parameters/Punch/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func play_aim() -> void:
	model.animation_tree["parameters/Aim/transition_request"] = "aiming"
	model.animation_tree["parameters/AimBlend/blend_amount"] = 1.0

func throw() -> void:
	model.animation_tree["parameters/Aim/transition_request"] = "none"
	model.animation_tree["parameters/AimBlend/blend_amount"] = 0.0
	model.animation_tree["parameters/Throw/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

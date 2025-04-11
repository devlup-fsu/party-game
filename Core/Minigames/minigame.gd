class_name Minigame
extends Resource

@export var name: String
@export_multiline var description: String
@export var portrait: Texture2D = load("res://Core/Minigames/default_portrait.png")
@export var scene: PackedScene
@export var published: bool
@export var controls: Array[Texture2D]
